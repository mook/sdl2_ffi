module SDL2
  class Event
    # Window state change event data (event.window.*)
    class Window < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :event, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :data1, :int32,
        :data2, :int32
      ]
      member_readers *members
      member_writers *members
    end
  end
end