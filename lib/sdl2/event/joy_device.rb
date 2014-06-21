module SDL2
  class Event
    # Joystick device event structure (event.jdevice.*)
    class JoyDevice < Abstract

      layout *SHARED + [
        :which, :joystick_id
      ]
      member_readers *members
      member_writers *members
    end

  end
end