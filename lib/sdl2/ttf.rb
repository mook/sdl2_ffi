require 'sdl2'
require 'sdl2/version'
require 'sdl2/rwops'
require 'sdl2/color'
require 'sdl2/ttf/sdl_ttf_module'
require 'sdl2/ttf/font'
require 'active_support/inflector'

module SDL2

  # The SDL_ttf interface.  API prototypes are linked to this module.
  module TTF

    extend FFI::Library
    extend SDL2::Library
    ffi_lib SDL_TTF_MODULE

    api :TTF_Linked_Version, [], Version.auto_ptr

    UNICODE_BOM_NATIVE = 0xFEFF
    UNICODE_BOM_SWAPPED = 0xFFFE

    api :TTF_ByteSwappedUNICODE, [:int], :void

    api :TTF_Init, [], :int, {error: true, filter: TRUE_WHEN_ZERO}
    api :TTF_OpenFont, [:string, :int], Font.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_OpenFontIndex, [:string, :int, :long], Font.auto_ptr
    api :TTF_OpenFontRW, [RWops.by_ref, :int, :int], Font.auto_ptr
    api :TTF_OpenFontIndexRW, [RWops.by_ref, :int, :int, :long], Font.auto_ptr

    module STYLE
      include EnumerableConstants
      NORMAL = 0x00
      BOLD = 0x01
      ITALIC = 0x02
      UNDERLINE = 0x04
      STRIKETHROUGH = 0x08
    end

    enum :font_style, STYLE.flatten_consts

    api :TTF_GetFontStyle, [Font.by_ref], :int
    api :TTF_SetFontStyle, [Font.by_ref, :int], :void
    api :TTF_GetFontOutline, [Font.by_ref], :int
    api :TTF_SetFontOutline, [Font.by_ref, :int], :void

    module HINTING
      include EnumerableConstants
      NORMAL = 0
      LIGHT = 1
      MONO = 2
      NONE = 3
    end
    enum :hinting, HINTING.flatten_consts

    api :TTF_GetFontHinting, [Font.by_ref], :hinting
    api :TTF_SetFontHinting, [Font.by_ref, :int], :void

    api :TTF_FontHeight, [Font.by_ref], :int
    api :TTF_FontAscent, [Font.by_ref], :int
    api :TTF_FontDescent, [Font.by_ref], :int
    api :TTF_FontLineSkip, [Font.by_ref], :int
    api :TTF_GetFontKerning, [Font.by_ref], :int
    api :TTF_SetFontKerning, [Font.by_ref], :int
    api :TTF_FontFaces, [Font.by_ref], :long
    api :TTF_FontFaceIsFixedWidth, [Font.by_ref], :int
    api :TTF_FontFaceFamilyName, [Font.by_ref], :string
    api :TTF_FontFaceStyleName, [Font.by_ref], :string

    api :TTF_GlyphIsProvided, [Font.by_ref, :uint16], :int

    api :TTF_GlyphMetrics, [
      Font.by_ref,
      :uint16,
      IntStruct.by_ref,
      IntStruct.by_ref,
      IntStruct.by_ref,
      IntStruct.by_ref,
      IntStruct.by_ref
    ], :int

    api :TTF_SizeText, [Font.by_ref, :string, IntStruct.by_ref, IntStruct.by_ref], :int
    api :TTF_SizeUTF8, [Font.by_ref, :string, IntStruct.by_ref, IntStruct.by_ref], :int
    api :TTF_SizeUNICODE, [Font.by_ref, :string, IntStruct.by_ref, IntStruct.by_ref], :int

    api :TTF_RenderText_Solid, [Font.by_ref, :string, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUTF8_Solid, [Font.by_ref, :string, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUNICODE_Solid, [Font.by_ref, :string, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}

    api :TTF_RenderGlyph_Solid, [Font.by_ref, :uint16, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}

    api :TTF_RenderText_Shaded, [Font.by_ref, :string, Color.by_value, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUTF8_Shaded, [Font.by_ref, :string, Color.by_value, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUNICODE_Shaded, [Font.by_ref, :string, Color.by_value, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}

    api :TTF_RenderGlyph_Shaded, [Font.by_ref, :uint16, Color.by_value, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}

    api :TTF_RenderText_Blended, [Font.by_ref, :string, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUTF8_Blended, [Font.by_ref, :string, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUNICODE_Blended, [Font.by_ref, :string, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}

    api :TTF_RenderText_Blended_Wrapped, [Font.by_ref, :string, Color.by_value, :uint32], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUTF8_Blended_Wrapped, [Font.by_ref, :string, Color.by_value, :uint32], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
    api :TTF_RenderUNICODE_Blended_Wrapped, [Font.by_ref, :string, Color.by_value, :uint32], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}

    api :TTF_RenderGlyph_Blended, [Font.by_ref, :uint16, Color.by_value], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}

    api :TTF_CloseFont, [Font.by_ref], :void
    api :TTF_Quit, [], :void
    api :TTF_WasInit, [], :int
    api :TTF_GetFontKerningSize, [Font.by_ref, :int, :int], :int

  end

end