require 'sdl2'

module SDL2

  attach_function :clear_error, :SDL_ClearError, [], :void
  attach_function :get_error,   :SDL_GetError, [], :string
  attach_function :set_error,   :SDL_SetError, [:string, :varargs], :int
    
end