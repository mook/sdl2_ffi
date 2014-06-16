module SDL2
  class Event
    # Mouse wheel event structure (event.wheel.*)
    class MouseWheel < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :which, :uint32,
        :x, :int32,
        :y, :int32
      ]
      member_readers *members
      member_writers *members
    end

  end
end