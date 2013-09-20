require 'sdl2'
require 'sdl2/error'
require 'sdl2/keycode'
require 'sdl2/video'

module SDL2
  
  typedef :int16, :keymod
  
  
  class Keysym < Struct
    layout :scancode, :int32,
      :sym, :keycode,
      :mod, :uint16,
      :unused, :uint32
      
    member_readers *members
    member_writers *members
  end
  
  api :SDL_GetKeyboardFocus, [], Window.by_ref
  api :SDL_GetKeyboardState, [:count], UInt8Struct.by_ref
  api :SDL_GetModState, [], :keymod
  api :SDL_SetModState, [:keymod], :void
  api :SDL_GetKeyFromScancode, [:scancode], :keycode
  api :SDL_GetScancodeFromKey, [:keycode], :scancode
  api :SDL_GetScancodeName, [:scancode], :string
  api :SDL_GetScancodeFromName, [:string], :scancode
  api :SDL_GetKeyName, [:keycode], :string
  api :SDL_GetKeyFromName, [:string], :keycode
  api :SDL_StartTextInput, [], :void
  api :SDL_IsTextInputActive, [], :bool
  api :SDL_StopTextInput, [], :void
  api :SDL_SetTextInputRect, [Rect.by_ref], :void
  api :SDL_HasScreenKeyboardSupport, [], :bool
  api :SDL_IsScreenKeyboardShown, [], :bool
end