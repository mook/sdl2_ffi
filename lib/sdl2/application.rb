require 'sdl2'

module SDL2

  # Input/Output engine.
  class Engine

    def initialize(opts = {})
      # TODO: ??
    end

    attr_reader :surface

    def on_handlers
      @on_handlers ||= {}
    end

    def on(*args, &block)
      raise "Must specify EVENTTYPEs to handle" if args.empty?
      raise "Must give block to call on event" if args.empty? unless block.nil?
      args.each do |event_hash|
        raise "Expected Hash: #{event_hash.inspect}" unless event_hash.kind_of? Hash
        on_handlers[event_hash] = block
      end
    end

    def handle_event(event)
      #binding.pry if [:MOUSEBUTTONDOWN, :MOUSEBUTTONUP].include?(event.type)
      @on_handlers.each_pair do |event_hash, handler|        
        return true if handler.call(event) if event == event_hash
      end
      return false # if we get to here.
    end
    
    # This routine should be overriden.
    def paint_to(surface)
      false
    end

  end

  class Engines < Engine

    def initialize(opts)      
      super(opts)
      @engines = [] #opts[:engines] || []
      @current_idx = 0      
    end

    attr_reader :engines

    def current_engine
      @engines[@current_idx] 
    end

    def handle_event(event)
      return true if super(event) # self swallowed event.
      if current_engine
        puts "Passing to current engine."
        return true if current_engine.handle_event(event)      
      end
      puts "Unable to handle"
      return false # if we get to here.
    end
    
    def paint_to(surface)
      if ce = current_engine
        return ce.paint_to(surface)
      else
        return false
      end        
    end

  end

  # Single window app.
  class Application < Engines
    
    attr_accessor :window

    def initialize(opts = {})
      super(opts)
      title = opts[:title] || self.to_s
      x = opts[:x] || :CENTERED
      y = opts[:y] || :CENTERED
      w = opts[:w] || 640
      h = opts[:h] || 480
      flags = opts[:flags] || :SHOWN
      

      @window = Window.create(title, x, y, w, h, flags)

      # Default ON handler for :QUIT events:
      self.on({type: :QUIT}) do |event|
        @quit_loop = true
      end

    end
    
    def quit()
      @window.free
    end
    
    

    attr_accessor :poll_count_limit

    def poll(cnt = poll_count_limit)
      puts "Poll Start"
      times = 0
      while (event = Event.poll()) and (cnt.nil? or (times+=1 < cnt))
        puts "GOT: #{event.type}"
        handle_event(event)
      end
      
      puts "Poll End"
    end

    attr_accessor :loop_count_limit

    def loop(cnt = loop_count_limit)
      @quit_loop = false
      times = 0
      while (cnt.nil?) or ((times+=1) <= cnt)
        puts ">>> Loop##{times}"
        poll # Process input
        break if @quit_loop
        # Update the surface when we are painted to
        @window.update_surface if paint_to(@window.surface)
        puts "<<< Loop##{times}"
        
      end
    end

  end

end