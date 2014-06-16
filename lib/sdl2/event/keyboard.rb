module SDL2
  class Event
    # Keyboard button event structure (event.key.*)
    class Keyboard < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :state, :uint8,
        :repeat, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :keysym, Keysym
      ]
      member_readers *members
      member_writers *members
    end
  end
end