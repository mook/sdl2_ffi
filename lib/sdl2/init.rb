require 'sdl2'
require 'sdl2/error'

module SDL2

  # Enumeration of valid initialization flags.
  module INIT
    include EnumerableConstants

    TIMER          = 0x00000001
    AUDIO          = 0x00000010
    VIDEO          = 0x00000020
    JOYSTICK       = 0x00000200
    HAPTIC         = 0x00001000
    GAMECONTROLLER = 0x00002000
    EVENTS         = 0x00004000
    NOPARACHUTE    = 0x00100000
    EVERYTHING     = TIMER | AUDIO | VIDEO | EVENTS | JOYSTICK | HAPTIC | GAMECONTROLLER

  end
  
  enum :init_flag, INIT.flatten_consts
  

  api :SDL_Init, [:init_flag], :int, {error: true}


  api :SDL_InitSubSystem, [:init_flag], :int, {error: true}

  def init_sub_system!(flags)
    error_code = init_sub_system(flags)
    if (error_code != 0)
      throw get_error
    end
  end

  api :SDL_WasInit, [:init_flag], :uint32
    
  boolean? :was_init, TRUE_WHEN_NOT_ZERO

  api :SDL_Quit, [], :void

  api :SDL_QuitSubSystem, [:init_flag], :void
end