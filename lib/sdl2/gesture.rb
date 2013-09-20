require 'sdl2'

require 'sdl2/video'
require 'sdl2/touch'

module SDL2
  
  typedef :int64, :gesture_id
  
  ##
	#
	api :SDL_RecordGesture, [:touch_id], :int
  ##
	#
	api :SDL_SaveAllDollarTemplates, [RWops.by_ref], :int
  ##
	#
	api :SDL_SaveDollarTemplate, [:gesture_id, RWops.by_ref], :int
  ##
	#
	api :SDL_LoadDollarTemplates, [:touch_id, RWops.by_ref], :int

end