module SDL2
  class Event
    # Keyboard text editing event structure (event.edit.*)
    class TextEditing < Abstract

      TEXT_SIZE = 32 # Line 188
      layout *SHARED + [
        :windowID, :uint32,
        :char, [:char, TEXT_SIZE],
        :start, :int32,
        :length, :int32
      ]
      member_readers *members
      member_writers *members
    end
  end
end