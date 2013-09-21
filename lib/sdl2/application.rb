require 'sdl2/engine/engines'

module SDL2

  # A Top-Level SDL Application:
  # An application 
  
  
  class Application < Engine::Engines

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
      super()      
    end

    attr_accessor :poll_count_limit

    # What makes an engine an "Application" is that it takes control of event
    # polling.  There should only ever be one "Application"
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

  def loop(cnt = loop_count_limit, opts ={})      
      @quit_loop = false
      times = 0
      while (cnt.nil?) or ((times+=1) <= cnt)
        puts ">>> Loop##{times}"
        poll # Process input
        break if @quit_loop
        # Update the surface when we are painted to
        @window.update_surface if paint_to(@window.surface)
        puts "<<< Loop##{times}"
        delay(opts[:delay]) if opts.has_key? :delay
      end
    end

  end

end