require 'sdl2'

module SDL2
  
  ALPHA_OPAQUE = 255
  ALPHA_TRANSPARENT = 0
  
  enum :pixeltype, [:unknown, :index1, :index4, :index8, 
    :packed8, :packed16, :packed32, 
    :arrayU8, :arrayU16, :arrayU32, 
    :arrayF16, :arrayF32
  ]
  enum :bitmaporder, [:none, :_4321, :_1234]
  enum :packedorder, [:none, :xrgb, :rgbx, :argb, :rgba, :xbgr, :bgrx, :abgr, :bgra]  
  enum :arrayorder, [:none, :rgb, :rgba, :argb, :bgr, :bgra, :abgr]
  enum :packedlayout, [:none, :_332, :_4444, :_1555, :_5551, :_565, :_8888, :_2101010, :_1010102]
    
end