module SDL2
  class Event
    # Joystick button event structure (event.jbutton.*)
    class JoyButton < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :button, :uint8,
        :state, :uint8,
        :padding1, :uint8,
        :padding2, :uint8
      ]
      member_readers *members
      member_writers *members
    end

  end
end