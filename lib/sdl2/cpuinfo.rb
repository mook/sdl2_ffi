require 'sdl2'

module SDL2
  
  CACHELINE_SIZE = 128
  
  ##
	#
	api :SDL_GetCPUCount, [], :int
  ##
	#
	api :SDL_GetCPUCacheLineSize, [], :int
  ##
	#
	api :SDL_HasRDTSC, [], :bool
  ##
	#
	api :SDL_HasAltiVec, [], :bool
  ##
	#
	api :SDL_Has3DNow, [], :bool
  ##
	#
	api :SDL_HasSSE, [], :bool
  ##
	#
	api :SDL_HasSSE2, [], :bool
  ##
	#
	api :SDL_HasSSE3, [], :bool
  ##
	#
	api :SDL_HasSSE41, [], :bool
  ##
	#
	api :SDL_HasSSE42, [], :bool
  
end