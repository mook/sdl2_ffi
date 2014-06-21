module SDL2
  class Event
    # Joystick trackball motion event structure (event.jball.*)
    class JoyBall < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :ball, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :xrel, :int16,
        :yrel, :int16
      ]
      member_readers *members
      member_writers *members
    end

  end
end