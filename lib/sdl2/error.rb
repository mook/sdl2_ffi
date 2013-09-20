require 'sdl2'

module SDL2

  ##
	#
	api :SDL_ClearError, [], :void
  ##
	#
	api :SDL_GetError, [], :string
  ##
	#
	api :SDL_SetError, [:string, :varargs], :int
    
end