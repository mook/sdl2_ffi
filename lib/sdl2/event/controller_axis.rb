module SDL2
  class Event
    # Game controller axis motion event structure (event.caxis.*)
    class ControllerAxis < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :axis, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :value, :int16,
        :padding4, :uint16
      ]
      member_readers *members
      member_writers *members
    end

  end
end