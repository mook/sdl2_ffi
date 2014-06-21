module SDL2
  class Event
    class Abstract < Struct
      SHARED = [:type, :event_type, :timestamp, :uint32]

      def to_event
        SDL2::Event.new(self.pointer)
      end
    end
  end
end