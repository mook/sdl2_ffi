module SDL2
  class Event
    # Joystick hat position change event structure (event.jhat.*)
    class JoyHat < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :hat, :uint8,
        :value, :uint8,
        :padding1, :uint8,
        :padding2, :uint8
      ]
      member_readers *members
      member_writers *members
    end

  end
end