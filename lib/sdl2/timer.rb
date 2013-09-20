require 'sdl2'

module SDL2
  
  ##
	#
	api :SDL_GetTicks, [], :uint32
  ##
	#
	api :SDL_GetPerformanceCounter, [], :uint64
  ##
	#
	api :SDL_GetPerformanceFrequency, [], :uint64    
  ##
	#
	api :SDL_Delay, [:uint32], :void
  
  callback :timer_callback, [:uint32, :pointer], :uint32
    
  typedef :int, :timer_id
  
  ##
	#
	api :SDL_AddTimer, [:uint32, :timer_callback, :pointer], :timer_id
  ##
	#
	api :SDL_RemoveTimer, [:timer_id], :bool  
  
end