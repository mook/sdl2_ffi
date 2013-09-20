require 'sdl2'
require 'sdl2/video'

module SDL2
  
  typedef :int64, :touch_id
  typedef :int64, :finger_id
  
  class Finger < Struct
    layout :id, :finger_id,
      :x, :float,
      :y, :float,
      :pressure, :float
  end
  
  TOUCH_MOUSEID = -1 
  
  ##
	#
	api :SDL_GetNumTouchDevices, [], :int
  ##
	#
	api :SDL_GetTouchDevice, [:int], :touch_id
  ##
	#
	api :SDL_GetNumTouchFingers, [:touch_id], :int
  ##
	#
	api :SDL_GetTouchFinger, [:touch_id, :int], Finger.by_ref
  
  
end