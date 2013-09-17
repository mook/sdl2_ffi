require 'sdl2/error'
require 'sdl2/color'
require 'sdl2/pixel_format'

# SDL_pixels.h API
module SDL2
  ALPHA_OPAQUE = 255
  ALPHA_TRANSPARENT = 0

  # Predefined pixel types.
  module PIXELTYPE
    include EnumerableConstants
    UNKNOWN
    INDEX1
    INDEX4
    INDEX8
    PACKED8
    PACKED16
    PACKED32
    ARRAYU8
    ARRAYU16
    ARRAYU32
    ARRAYF16
    ARRAYF32
  end
  enum :pixeltype, PIXELTYPE.flatten_consts

  # Bitmap pixel order, high bit -> low bit
  module BITMAPORDER
    include EnumerableConstants
    NONE 
    N4321
    N1234
  end

  enum :bitmaporder, BITMAPORDER.flatten_consts

  # Packed component order, high bit -> low bit
  module PACKEDORDER
    include EnumerableConstants
    NONE
    XRGB
    RGBX
    ARGB
    RGBA
    XBGR
    BGRX
    ABGR
    BGRA
  end

  enum :packedorder, PACKEDORDER.flatten_consts

  # Array component order, low byte -> hight byte
  module ARRAYORDER
    include EnumerableConstants
    NONE
    RGB
    RGBA
    ARGB
    BGR
    BGRA
    ABGR
  end

  enum :arrayorder, ARRAYORDER.flatten_consts

  # Packed component layout
  module PACKEDLAYOUT
    include EnumerableConstants
    NONE
    N332
    N4444
    N1555
    N5551
    N565
    N8888
    N2101010
    N1010102
  end

  enum :packedlayout, PACKEDLAYOUT.flatten_consts

  #MACRO: SDL_DEFINE_PIXELFOURCC(A, B, C, D) SDL_FOURCC(A, B, C, D)
  def self.define_pixelfourcc(a,b,c,d)
    SDL2.fourcc(a,b,c,d);
  end

  #MACRO: SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) \
  #    ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | \
  #     ((bits) << 8) | ((bytes) << 0))
  def self.define_pixelformat(type, order, layout, bits, bytes)
    ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | 
     ((bits) << 8) | ((bytes) << 0))
  end

  #MACRO: SDL_PIXELFLAG(X)    (((X) >> 28) & 0x0F)
  def self.pixelflag(x);      (((x) >> 28) & 0x0F); end

  #MACRO: SDL_PIXELTYPE(X)    (((X) >> 24) & 0x0F)
  def self.pixeltype(x);      (((x) >> 24) & 0x0F); end

  #MACRO: SDL_PIXELORDER(X)   (((X) >> 20) & 0x0F)
  def self.pixelorder(x);     (((x) >> 20) & 0x0F); end

  #MACRO: SDL_PIXELLAYOUT(X)  (((X) >> 16) & 0x0F)
  def self.pixellayout(x);    (((x) >> 16) & 0x0F); end

  #MACRO: SDL_BITSPERPIXEL(X) (((X) >> 8) & 0xFF)
  def self.bitsperpixel(x);   (((x) >> 8) & 0xFF); end

  #MACRO: SDL_BYTESPERPIXEL(X) \
  #    (SDL_ISPIXELFORMAT_FOURCC(X) ? \
  #        ((((X) == SDL_PIXELFORMAT_YUY2) || \
  #          ((X) == SDL_PIXELFORMAT_UYVY) || \
  #          ((X) == SDL_PIXELFORMAT_YVYU)) ? 2 : 1) : (((X) >> 0) & 0xFF))
  def self.bytesperpixel(x)
    (ispixelformat_fourcc(x) ?
    ((( x == PIXELFORMAT.YUV2 ) ||
    ( x == PIXELFORMAT.UYVY ) ||
    ( x == PIXELFORMAT.YVYU )) ? 2 : 1) : ((x >> 0) & 0xFF))
  end

  #MACRO: SDL_ISPIXELFORMAT_INDEXED(format)   \
  #(!SDL_ISPIXELFORMAT_FOURCC(format) && \
  #((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX1) || \
  #(SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX4) || \
  #(SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX8)))
  def self.ispixelformat_indexed(format)
    (!ispixelformat_fourcc(format) &&
    ((pixeltype(format) == PIXELTYPE.INDEX1) ||
    (pixeltype(format) == PIXELTYPE.INDEX4) ||
    (pixeltype(format) == PIXELTYPE.INDEX8)))
  end

  #MACRO: SDL_ISPIXELFORMAT_ALPHA(format)   \
  #(!SDL_ISPIXELFORMAT_FOURCC(format) && \
  #((SDL_PIXELORDER(format) == SDL_PACKEDORDER_ARGB) || \
  #(SDL_PIXELORDER(format) == SDL_PACKEDORDER_RGBA) || \
  #(SDL_PIXELORDER(format) == SDL_PACKEDORDER_ABGR) || \
  #(SDL_PIXELORDER(format) == SDL_PACKEDORDER_BGRA)))
  def self.ispixelformat_alpha(format)
    (!pixelformat_fourcc(format) &&
    ((pixelorder(format) == PACKEDORDER.ARGB) ||
    (pixelorder(format) == PACKEDORDER.RGBA) ||
    (pixelorder(format) == PACKEDORDER.ABGR) ||
    (pixelorder(format) == PACKEDORDER.BGRA)))
  end

  #MACRO: SDL_ISPIXELFORMAT_FOURCC(format)    \
  #((format) && (SDL_PIXELFLAG(format) != 1))
  def self.ispixelformat_fourcc(format)
    ((format) && (pixelflag(format) != 1))
  end

  module PIXELFORMAT
    include EnumerableConstants
    UNKNOWN =  0
    INDEX1LSB =     SDL2.define_pixelformat(PIXELTYPE::INDEX1, BITMAPORDER::N4321, 0,    1, 0)
    INDEX1MSB =     SDL2.define_pixelformat(PIXELTYPE::INDEX1, BITMAPORDER::N1234, 0,    1, 0)
    INDEX4LSB =     SDL2.define_pixelformat(PIXELTYPE::INDEX4, BITMAPORDER::N4321, 0,    4, 0)
    INDEX4MSB =     SDL2.define_pixelformat(PIXELTYPE::INDEX4, BITMAPORDER::N1234, 0,    4, 0)
    INDEX8 =        SDL2.define_pixelformat(PIXELTYPE::INDEX8, 0, 0, 8, 1)
    RGB332 =        SDL2.define_pixelformat(PIXELTYPE::PACKED8, PACKEDORDER::XRGB,    PACKEDLAYOUT::N332, 8, 1)
    RGB444 =        SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::XRGB,    PACKEDLAYOUT::N4444, 12, 2)
    RGB555 =        SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::XRGB,    PACKEDLAYOUT::N1555, 15, 2)
    BGR555 =        SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::XBGR,    PACKEDLAYOUT::N1555, 15, 2)
    ARGB4444 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::ARGB,    PACKEDLAYOUT::N4444, 16, 2)
    RGBA4444 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::RGBA,    PACKEDLAYOUT::N4444, 16, 2)
    ABGR4444 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::ABGR,    PACKEDLAYOUT::N4444, 16, 2)
    BGRA4444 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::BGRA,    PACKEDLAYOUT::N4444, 16, 2)
    ARGB1555 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::ARGB,    PACKEDLAYOUT::N1555, 16, 2)
    RGBA5551 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::RGBA,    PACKEDLAYOUT::N5551, 16, 2)
    ABGR1555 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::ABGR,    PACKEDLAYOUT::N1555, 16, 2)
    BGRA5551 =      SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::BGRA,    PACKEDLAYOUT::N5551, 16, 2)
    RGB565 =        SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::XRGB,    PACKEDLAYOUT::N565, 16, 2)
    BGR565 =        SDL2.define_pixelformat(PIXELTYPE::PACKED16, PACKEDORDER::XBGR,    PACKEDLAYOUT::N565, 16, 2)
    RGB24 =         SDL2.define_pixelformat(PIXELTYPE::ARRAYU8,  ARRAYORDER::RGB, 0,    24, 3)
    BGR24 =         SDL2.define_pixelformat(PIXELTYPE::ARRAYU8,  ARRAYORDER::BGR, 0,    24, 3)
    RGB888 =        SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::XRGB,    PACKEDLAYOUT::N8888, 24, 4)
    RGBX8888 =      SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::RGBX,    PACKEDLAYOUT::N8888, 24, 4)
    BGR888 =        SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::XBGR,    PACKEDLAYOUT::N8888, 24, 4)
    BGRX8888 =      SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::BGRX,    PACKEDLAYOUT::N8888, 24, 4)
    ARGB8888 =      SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::ARGB,    PACKEDLAYOUT::N8888, 32, 4)
    RGBA8888 =      SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::RGBA,    PACKEDLAYOUT::N8888, 32, 4)
    ABGR8888 =      SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::ABGR,    PACKEDLAYOUT::N8888, 32, 4)
    BGRA8888 =      SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::BGRA,    PACKEDLAYOUT::N8888, 32, 4)
    ARGB2101010 =   SDL2.define_pixelformat(PIXELTYPE::PACKED32, PACKEDORDER::ARGB,    PACKEDLAYOUT::N2101010, 32, 4)

    YV12 =          SDL2.define_pixelfourcc('Y', 'V', '1', '2')
    IYUV =          SDL2.define_pixelfourcc('I', 'Y', 'U', 'V')
    YUY2 =          SDL2.define_pixelfourcc('Y', 'U', 'Y', '2')
    UYVY =          SDL2.define_pixelfourcc('U', 'Y', 'V', 'Y')
    YVYU =          SDL2.define_pixelfourcc('Y', 'V', 'Y', 'U')
  end

  api :SDL_GetPixelFormatName, [:pixel_format], :string
  api :SDL_PixelFormatEnumToMasks, [:pixel_format, IntStruct.by_ref, UInt32Struct.by_ref, UInt32Struct.by_ref,UInt32Struct.by_ref,UInt32Struct.by_ref,], :bool
  api :SDL_MasksToPixelFormatEnum, [:int, :uint32, :uint32, :uint32, :uint32], :pixel_format
  api :SDL_AllocFormat, [:pixel_format], PixelFormat.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  api :SDL_FreeFormat, [PixelFormat.by_ref], :void
  api :SDL_AllocPalette, [:count], Palette.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  api :SDL_SetPixelFormatPalette, [PixelFormat.by_ref, Palette.by_ref], :int
  api :SDL_SetPaletteColors, [Palette.by_ref, :pointer, :int, :count], :int
  api :SDL_FreePalette, [Palette.by_ref], :void
  api :SDL_MapRGB, [PixelFormat.by_ref, :uint8, :uint8, :uint8], :uint32
  api :SDL_MapRGBA, [PixelFormat.by_ref, :uint8, :uint8, :uint8, :uint8], :uint32
  api :SDL_GetRGB, [:uint32, PixelFormat.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :void
  api :SDL_GetRGBA, [:uint32, PixelFormat.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :void

end