require 'sdl2/error'
require 'sdl2/color'
require 'sdl2/pixel_format'
require 'yinum'

# SDL_pixels.h API
module SDL2
  ALPHA_OPAQUE = 255
  ALPHA_TRANSPARENT = 0

  PIXELTYPE = Enum.new :PIXELTYPE, {
    UNKNOWN: 0,
    INDEX1: 1,
    INDEX4: 2,
    INDEX8: 3,
    PACKED8: 4,
    PACKED16: 5,
    PACKED32: 6,
    ARRAYU8: 7,
    ARRAYU16: 8,
    ARRAYU32: 9,
    ARRAYF16: 10,
    ARRAYF32: 11
  }
  enum :pixeltype, PIXELTYPE.by_name

  BITMAPORDER = Enum.new :BITMAPORDER, {
    NONE: 0,
    _4321: 1,
    _1234: 2
  }
  enum :bitmaporder, BITMAPORDER.by_name

  PACKEDORDER = Enum.new :PACKEDORDER, {
    NONE: 0,
    XRGB: 1,
    RGBX: 2,
    ARGB: 3,
    RGBA: 4,
    XBGR: 5,
    BGRX: 6,
    ABGR: 7,
    BGRA: 8
  }
  enum :packedorder, PACKEDORDER.by_name

  ARRAYORDER = Enum.new :ARRAYORDER, {
    NONE: 0,
    RGB: 1,
    RGBA: 2,
    ARGB: 3,
    BGR: 4,
    BGRA: 5,
    ABGR: 6
  }
  enum :arrayorder, ARRAYORDER.by_name

  PACKEDLAYOUT = Enum.new :PACKEDLAYOUT, {
    NONE: 0,
    _332: 1,
    _4444: 2,
    _1555: 3,
    _5551: 4,
    _565: 5,
    _8888: 6,
    _2101010: 7,
    _1010102: 8
  }
  enum :packedlayout, PACKEDLAYOUT.by_name

  #MACRO: SDL_DEFINE_PIXELFOURCC(A, B, C, D) SDL_FOURCC(A, B, C, D)
  def self.define_pixelfourcc(a,b,c,d); SDL2.fourcc(a,b,c,d); end

  #MACRO: SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) \
  #    ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | \
  #     ((bits) << 8) | ((bytes) << 0))
  def self.define_pixelformat(type, order, layout, bits, bytes)
    ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | ((bits) << 8) | ((bytes) << 0))
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

  PIXELFORMAT = Enum.new(:PIXELFORMAT, {
    UNKNOWN: 0,
    INDEX1LSB:
    define_pixelformat(PIXELTYPE.INDEX1, BITMAPORDER._4321, 0,
    1, 0),
    INDEX1MSB:
    define_pixelformat(PIXELTYPE.INDEX1, BITMAPORDER._1234, 0,
    1, 0),
    INDEX4LSB:
    define_pixelformat(PIXELTYPE.INDEX4, BITMAPORDER._4321, 0,
    4, 0),
    INDEX4MSB:
    define_pixelformat(PIXELTYPE.INDEX4, BITMAPORDER._1234, 0,
    4, 0),
    INDEX8:
    define_pixelformat(PIXELTYPE.INDEX8, 0, 0, 8, 1),
    RGB332:
    define_pixelformat(PIXELTYPE.PACKED8, PACKEDORDER.XRGB,
    PACKEDLAYOUT._332, 8, 1),
    RGB444:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.XRGB,
    PACKEDLAYOUT._4444, 12, 2),
    RGB555:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.XRGB,
    PACKEDLAYOUT._1555, 15, 2),
    BGR555:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.XBGR,
    PACKEDLAYOUT._1555, 15, 2),
    ARGB4444:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.ARGB,
    PACKEDLAYOUT._4444, 16, 2),
    RGBA4444:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.RGBA,
    PACKEDLAYOUT._4444, 16, 2),
    ABGR4444:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.ABGR,
    PACKEDLAYOUT._4444, 16, 2),
    BGRA4444:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.BGRA,
    PACKEDLAYOUT._4444, 16, 2),
    ARGB1555:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.ARGB,
    PACKEDLAYOUT._1555, 16, 2),
    RGBA5551:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.RGBA,
    PACKEDLAYOUT._5551, 16, 2),
    ABGR1555:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.ABGR,
    PACKEDLAYOUT._1555, 16, 2),
    BGRA5551:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.BGRA,
    PACKEDLAYOUT._5551, 16, 2),
    RGB565:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.XRGB,
    PACKEDLAYOUT._565, 16, 2),
    BGR565:
    define_pixelformat(PIXELTYPE.PACKED16, PACKEDORDER.XBGR,
    PACKEDLAYOUT._565, 16, 2),
    RGB24:
    define_pixelformat(PIXELTYPE.ARRAYU8, ARRAYORDER.RGB, 0,
    24, 3),
    BGR24:
    define_pixelformat(PIXELTYPE.ARRAYU8, ARRAYORDER.BGR, 0,
    24, 3),
    RGB888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.XRGB,
    PACKEDLAYOUT._8888, 24, 4),
    RGBX8888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.RGBX,
    PACKEDLAYOUT._8888, 24, 4),
    BGR888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.XBGR,
    PACKEDLAYOUT._8888, 24, 4),
    BGRX8888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.BGRX,
    PACKEDLAYOUT._8888, 24, 4),
    ARGB8888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.ARGB,
    PACKEDLAYOUT._8888, 32, 4),
    RGBA8888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.RGBA,
    PACKEDLAYOUT._8888, 32, 4),
    ABGR8888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.ABGR,
    PACKEDLAYOUT._8888, 32, 4),
    BGRA8888:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.BGRA,
    PACKEDLAYOUT._8888, 32, 4),
    ARGB2101010:
    define_pixelformat(PIXELTYPE.PACKED32, PACKEDORDER.ARGB,
    PACKEDLAYOUT._2101010, 32, 4),

    YV12:
    define_pixelfourcc('Y', 'V', '1', '2'),
    IYUV:
    define_pixelfourcc('I', 'Y', 'U', 'V'),
    YUY2:
    define_pixelfourcc('Y', 'U', 'Y', '2'),
    UYVY:
    define_pixelfourcc('U', 'Y', 'V', 'Y'),
    YVYU:
    define_pixelfourcc('Y', 'V', 'Y', 'U')
  })

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