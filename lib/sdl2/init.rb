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

  enum :init_flag, [
    :nothing, 0,
    :timer, INIT::TIMER,
    :audio, INIT::AUDIO,
    :video, INIT::VIDEO,
    :joystick, INIT::JOYSTICK,
    :haptic, INIT::HAPTIC,
    :game_controller, INIT::GAMECONTROLLER,
    :events, INIT::EVENTS,
    :no_parachute, INIT::NOPARACHUTE,
    :everything, INIT::EVERYTHING
  ]

  api :SDL_Init, [:init_flag], :int, {error: true}

  #def self.init!(flags)
  #  error_code = init(flags)
  #  if (error_code != 0)
  #    throw get_error()
  #  end
  #end

  api :SDL_InitSubSystem, [:init_flag], :int, {error: true}

  def init_sub_system!(flags)
    error_code = init_sub_system(flags)
    if (error_code != 0)
      throw get_error
    end
  end

  api :SDL_WasInit, [:init_flag], :uint32

  api :SDL_Quit, [], :void

  api :SDL_QuitSubSystem, [:init_flag], :void
end