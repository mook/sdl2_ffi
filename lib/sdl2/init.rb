require 'sdl2'
require 'sdl2/error'

module SDL2
  # SDL Constants, for OR'ing them
  INIT_TIMER          = 0x00000001
  INIT_AUDIO          = 0x00000010
  INIT_VIDEO          = 0x00000020
  INIT_JOYSTICK       = 0x00000200
  INIT_HAPTIC         = 0x00001000
  INIT_GAMECONTROLLER = 0x00002000
  INIT_EVENTS         = 0x00004000
  INIT_NOPARACHUTE    = 0x00100000
  INIT_EVERYTHING     = INIT_TIMER | INIT_AUDIO | INIT_VIDEO |
  INIT_EVENTS | INIT_JOYSTICK | INIT_HAPTIC |
  INIT_GAMECONTROLLER

  enum :init_flag, [
    :nothing, 0,
    :timer, INIT_TIMER,
    :audio, INIT_AUDIO,
    :video, INIT_VIDEO,
    :joystick, INIT_JOYSTICK,
    :haptic, INIT_HAPTIC,
    :game_controller, INIT_GAMECONTROLLER,
    :events, INIT_EVENTS,
    :no_parachute, INIT_NOPARACHUTE,
    :everything, INIT_EVERYTHING
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