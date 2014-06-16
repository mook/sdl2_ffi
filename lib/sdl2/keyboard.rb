require 'sdl2'
require 'sdl2/error'
require 'sdl2/keycode'
require 'sdl2/video'

module SDL2
  
  typedef :int16, :keymod
  
  # The SDL keysym structure, used in key events.
  #
  # @note: If you are looking for translated character input, see the TextInputEvent.
  class Keysym < Struct
    layout :scancode, :int32,
      :sym, :keycode,
      :mod, :uint16,
      :unused, :uint32
      
    member_readers *members
    member_writers *members
  end
  
  ##
	# Get the window which currently has keyboard focus.
  # :call-seq:
  #   get_keyboard_focus()
  #   get_keyboard_focus!
	api :SDL_GetKeyboardFocus, [], Window.by_ref
	  
	  
	  
  ##
	#  brief Get a snapshot of the current state of the keyboard.
  #
  #    *  numkeys if non-NULL, receives the length of the returned array.
  #
  #  @return An array of key states. 
	#   Indexes into this array are obtained by using ::SDL_Scancode values.
	#
  #
  #  Example: See Keyboard::get_state()
  #  @code
  #    count = FFI::MemoryPointer.new :int, 1
  #    state = FFI::Pointer.new :uint8, SDL2::get_keyboard_state(count)
  #    if state[SDL2::SCANCODE::RETURN]
  #      puts("<RETURN> is pressed.\n");
	#    end
	api :SDL_GetKeyboardState, [TypedPointer::Int.by_ref], :pointer
	
  ##
	#
	api :SDL_GetModState, [], :keymod
  ##
	#
	api :SDL_SetModState, [:keymod], :void
  ##
	#
	api :SDL_GetKeyFromScancode, [:scancode], :keycode
  ##
	#
	api :SDL_GetScancodeFromKey, [:keycode], :scancode
  ##
	#
	api :SDL_GetScancodeName, [:scancode], :string
  ##
	#
	api :SDL_GetScancodeFromName, [:string], :scancode
  ##
	#
	api :SDL_GetKeyName, [:keycode], :string
  ##
	#
	api :SDL_GetKeyFromName, [:string], :keycode
  ##
	#
	api :SDL_StartTextInput, [], :void
  ##
	#
	api :SDL_IsTextInputActive, [], :bool
  ##
	#
	api :SDL_StopTextInput, [], :void
  ##
	#
	api :SDL_SetTextInputRect, [Rect.by_ref], :void
  ##
	#
	api :SDL_HasScreenKeyboardSupport, [], :bool
  ##
	#
	api :SDL_IsScreenKeyboardShown, [], :bool
	  
	module Keyboard
	  # Get the window which currently has keyboard focus
	  def self.get_focus()
	    SDL2::get_keyboard_focus()
	  end
	  
	  # Get a snapshot of the current state of the keyboard.  
    def self.get_state()      
      count = SDL2::TypedPointer::Int.new
      
      state = SDL2::get_keyboard_state(count)
      #binding.pry
      result = state.get_array_of_uint8(:uint8, :get_uint8, count.value)      
      count.free
      state.free
      return result
    end
    
    # Get the current key modifier state for the keyboard.
    def self.get_mod()
      SDL2::get_mod_state()
    end    
    
    # Set the current key modifire state for the keyboard.
    # @note This does not change the keyboard state, only the key modifier flags.
    def self.set_mod(modstate)
      SDL2::set_mod_state(modstate)
    end 
	end
end