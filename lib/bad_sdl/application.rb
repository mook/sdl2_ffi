require 'bad_sdl'
require 'sdl2'
require 'bad_sdl/engine/engines'

module BadSdl
  ##
  # A Top-Level SDL Application:
  # An application
  # TODO: Review SDL2::Application for removal
  class Application < Engine::Engines
  
    attr_accessor :window
  
    def initialize(opts = {})
      super(opts)
  
      opts[:title] ||= self.to_s
      opts[:width] ||= 640
      opts[:height] ||= 480
      opts[:flags] ||= :SHOWN
  
      @window = Window.create(opts)
      @window.surface.fill_rect(@window.surface.rect, [0,0,0,SDL2::ALPHA_OPAQUE])
  
      # Default ON handler for :QUIT events:
      self.on({type: :QUIT}) do |event|
        @quit_loop = true
      end
  
    end
  
    def quit()
      @window.destroy
      super()
    end
  
    attr_accessor :poll_count_limit
  
    # What makes an engine an "Application" is that it takes control of event
    # polling.  There should only ever be one "Application"
    def poll(cnt = poll_count_limit)
      Debug.log(self){"Poll Start"}
      times = 0
      while (event = Event.poll()) and (cnt.nil? or (times+=1 < cnt))
        Debug.log(self){"GOT: #{event.type}"}
        handle_event(event)
      end
  
      Debug.log(self){"Poll End"}
    end
  
    attr_accessor :loop_count_limit
  
    def loop(cnt = loop_count_limit, opts ={})
      @quit_loop = false
      times = 0
  
      while (cnt.nil?) or ((times+=1) <= cnt)
        before_loop.each(&:call)
        poll # Process input
        break if @quit_loop
        # Update the surface when we are painted to
        @window.update_surface if paint_to(@window.surface)
        delay(opts[:delay]) if opts.has_key? :delay
        after_loop.each(&:call)
      end
  
    end
  
    def before_loop(&block)
      @before_loop ||= []
      @before_loop << block unless block.nil?
      @before_loop
    end
  
    def after_loop(&block)
      @after_loop ||= []
      @after_loop << block unless block.nil?
      @after_loop
    end
  end

end