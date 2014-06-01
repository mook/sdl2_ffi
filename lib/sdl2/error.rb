require 'sdl2'

##
# sdl_error.h - Error handling routines.
module SDL2
  
  ##
	# Remove current SDL error string.
	api :SDL_ClearError, [], :void
  ##
	# Retrieve current SDL error string.
	api :SDL_GetError, [], :string
  ##
	# Set current SDL error string.
	api :SDL_SetError, [:string, :varargs], :int
    
end