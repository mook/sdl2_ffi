module SDL2
  class Event
    class Abstract < Struct
      SHARED = [:type, :event_type, :timestamp, :uint32]

    end
  end
end