require 'sdl2'
require 'sdl2/color'
require 'sdl2/pixel_format'

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
    
  api :SDL_GetPixelFormatName, [:pixel_format], :string
  api :SDL_PixelFormatEnumToMasks, [:pixel_format, IntStruct.by_ref, UInt32Struct.by_ref, UInt32Struct.by_ref,UInt32Struct.by_ref,UInt32Struct.by_ref,], :bool
  api :SDL_MasksToPixelFormatEnum, [:int, :uint32, :uint32, :uint32, :uint32], :pixel_format
  api :SDL_AllocFormat, [:pixel_format], PixelFormat.auto_ptr
  api :SDL_FreeFormat, [PixelFormat.by_ref], :void
  api :SDL_AllocPalette, [:count], Palette.auto_ptr
  api :SDL_SetPixelFormatPalette, [PixelFormat.by_ref, Palette.by_ref], :int
  api :SDL_SetPaletteColors, [Palette.by_ref, Color.by_ref, :int, :count], :int
  api :SDL_FreePalette, [Palette.by_ref], :void
  api :SDL_MapRGB, [PixelFormat.by_ref, :uint8, :uint8, :uint8], :uint32
  api :SDL_MapRGBA, [PixelFormat.by_ref, :uint8, :uint8, :uint8, :uint8], :uint32
  api :SDL_GetRGB, [:uint32, PixelFormat.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :void
  api :SDL_GetRGBA, [:uint32, PixelFormat.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :void
  
  
end