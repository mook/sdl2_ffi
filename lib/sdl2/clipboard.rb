require 'sdl2'

module SDL2

  module Clipboard

    def self.has
      SDL2.has_clipboard_text
    end

    def self.has?
      SDL2.has_clipboard_text?
    end

    def self.get
      SDL2.get_clipboard_text
    end

    def self.set(text)
      SDL2.set_clipboard_text(text.to_s)
    end
  end

  ##
	#
	api :SDL_SetClipboardText, [:string], :int
  ##
	#
	api :SDL_GetClipboardText, [], :string
  ##
	#
	api :SDL_HasClipboardText, [], :bool
end