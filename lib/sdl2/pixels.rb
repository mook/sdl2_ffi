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
    
  attach_function :get_pixel_format_name, :SDL_GetPixelFormatName, [:pixel_format], :string
  attach_function :pixel_format_enum_to_masks, :SDL_PixelFormatEnumToMasks, [:pixel_format, IntStruct.by_ref, UInt32Struct.by_ref, UInt32Struct.by_ref,UInt32Struct.by_ref,UInt32Struct.by_ref,], :bool
  attach_function :masks_to_pixel_format_enum, :SDL_MasksToPixelFormatEnum, [:int, :uint32, :uint32, :uint32, :uint32], :pixel_format
  attach_function :alloc_format, :SDL_AllocFormat, [:pixel_format], PixelFormat.auto_ptr
  attach_function :free_format, :SDL_FreeFormat, [PixelFormat.by_ref], :void
  attach_function :alloc_palette, :SDL_AllocPalette, [:count], Palette.auto_ptr
  attach_function :set_pixel_format_palette, :SDL_SetPixelFormatPalette, [PixelFormat.by_ref, Palette.by_ref], :int
  attach_function :set_palette_colors, :SDL_SetPaletteColors, [Palette.by_ref, Color.by_ref, :int, :count], :int
  attach_function :free_palette, :SDL_FreePalette, [Palette.by_ref], :void
  attach_function :map_rgb, :SDL_MapRGB, [PixelFormat.by_ref, :uint8, :uint8, :uint8], :uint32
  attach_function :map_rgba, :SDL_MapRGBA, [PixelFormat.by_ref, :uint8, :uint8, :uint8, :uint8], :uint32
  attach_function :get_rgb, :SDL_GetRGB, [:uint32, PixelFormat.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :void
  attach_function :get_rgba, :SDL_GetRGBA, [:uint32, PixelFormat.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :void
  
  
end