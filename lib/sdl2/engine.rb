require 'sdl2'

module SDL2
  # Input/Output engine.
  class Engine
    def initialize(opts = {})
      
      # TODO: ??
    end

    def quit()
      
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
      
      @on_handlers.each_pair do |event_hash, handler|
        binding.pry if event.type == :KEYDOWN
        return true if handler.call(event) if event == event_hash
      end
      return false # if we get to here.
    end

    # This routine should be overriden.
    def paint_to(surface)
      false
    end
    
    protected
    
    
      

  end

end