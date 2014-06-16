module SDL2
  class Event
    # Controller device event structure (event.cdevice.*)
    class ControllerDevice < Abstract

      layout *SHARED + [
        :which, :joystick_id
      ]
      member_readers *members
      member_writers *members
    end

  end
end