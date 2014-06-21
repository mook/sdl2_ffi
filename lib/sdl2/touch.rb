require 'sdl2'
require 'sdl2/video'

module SDL2

  typedef :int64, :touch_id
  typedef :int64, :finger_id

  TOUCH_MOUSEID = -1
  ##
  # SDL's touch functionality.
  module Touch
    
    class Finger < Struct
      
      layout :id, :int64,#:finger_id,
      :x, :float,
      :y, :float,
      :pressure, :float
    end
  end
  
  api :SDL_GetNumTouchDevices, [], :int
  api :SDL_GetTouchDevice, [:int], :touch_id
  api :SDL_GetNumTouchFingers, [:touch_id], :int
  api :SDL_GetTouchFinger, [:touch_id, :int], Touch::Finger.by_ref

end