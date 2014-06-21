module SDL2
  class Event
    # Mouse button event structure (event.button.*)
    class MouseButton < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :which, :uint32,
        :button, :uint8,
        :state, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :x, :int32,
        :y, :int32
      ]
      member_readers *members
      member_writers *members
    end

  end
end