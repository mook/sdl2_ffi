module SDL2
  class Event
    # Keyboard text input event structure (event.text.*)
    class TextInput < Abstract

      TEXT_SIZE = 32 # Line 203
      layout *SHARED + [
        :windowID, :uint32,
        :char, [:char, TEXT_SIZE]
      ]
      member_readers *members
      member_writers *members
    end
  end
end