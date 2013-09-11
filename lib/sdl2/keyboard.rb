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
  end
  
  attach_function :get_keyboard_focus, :SDL_GetKeyboardFocus, [], Window.by_ref
  attach_function :get_keyboard_state, :SDL_GetKeyboardState, [:count], UInt8Struct.by_ref
  attach_function :get_mod_state, :SDL_GetModState, [], :keymod
  attach_function :set_mod_state, :SDL_SetModState, [:keymod], :void
  attach_function :get_key_from_scancode, :SDL_GetKeyFromScancode, [:scancode], :keycode
  attach_function :get_scancode_from_key, :SDL_GetScancodeFromKey, [:keycode], :scancode
  attach_function :get_scancode_name, :SDL_GetScancodeName, [:scancode], :string
  attach_function :get_scancode_from_name, :SDL_GetScancodeFromName, [:string], :scancode
  attach_function :get_key_name, :SDL_GetKeyName, [:keycode], :string
  attach_function :get_key_from_name, :SDL_GetKeyFromName, [:string], :keycode
  attach_function :start_text_input, :SDL_StartTextInput, [], :void
  attach_function :is_text_input_active, :SDL_IsTextInputActive, [], :bool
  attach_function :stop_text_input, :SDL_StopTextInput, [], :void
  attach_function :set_text_input_rect, :SDL_SetTextInputRect, [Rect.by_ref], :void
  attach_function :has_screen_keyboard_support, :SDL_HasScreenKeyboardSupport, [], :bool
  attach_function :is_screen_keyboard_shown, :SDL_IsScreenKeyboardShown, [], :bool
end