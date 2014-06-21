require 'bad_sdl/engine'
require 'sdl2/debug'

module BadSdl
  class Engine
    # An engine multiplexor.
    # Only has one focus, but that focus can change.
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
          Debug.log(self){"Passing to current engine."}
          return true if current_engine.handle_event(event)
        end
        SDL2::Debug.log(self){"Unable to handle"}
        return false # if we get to here.
      end
  
      def paint_to(surface)      
        result = false
                    
        result = true if super(surface)
        
        if ce = current_engine
          result = true if ce.paint_to(surface)
        end
        return result
      end
      
      def quit()
        @engines.each(&:quit)
        super()
      end
  
    end
  
  end
end