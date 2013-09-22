require 'sdl2/engine'

module SDL2

  # An engine multiplexor.
  # Only has one focus, but that focus can change.
  class Engine::Engines < Engine

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
        puts "Passing to current engine."if SDL2::PrintDebug
        return true if current_engine.handle_event(event)
      end
      puts "Unable to handle"if SDL2::PrintDebug
      return false # if we get to here.
    end

    def paint_to(surface)
      if ce = current_engine
        return ce.paint_to(surface)
      else
        return false
      end
    end
    
    def quit()
      @engines.each(&:quit)
      super()
    end

  end

end