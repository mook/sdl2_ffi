require 'sdl2'

module SDL2

  module Clipboard

    def self.has
      SDL2.has_clipboard_text()
    end

    def self.has?
      SDL2.has_clipboard_text == :true
    end

    def self.get
      SDL2.get_clipboard_text()
    end

    def self.set(text)
      SDL2.set_clipboard_text(text.to_s)
    end
  end

  attach_function :set_clipboard_text, :SDL_SetClipboardText, [:string], :int
  attach_function :get_clipboard_text, :SDL_GetClipboardText, [], :string
  attach_function :has_clipboard_text, :SDL_HasClipboardText, [], :bool
end