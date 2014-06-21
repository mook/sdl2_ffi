require 'sdl2'
require 'sdl2/surface'
require 'sdl2/image/sdl_image_module'
require 'active_support/inflector'

module SDL2
  ##
  # == SDL2::Image
  # This module provides direct access to the SDL2_image 2.0 library.
  #
  # === RLE acceleration
  #
  # From the `SDL_image.h` source: (translated into ruby by BadQuanta)
  #
  # > If the image format supports a transparent pixel, SDL will set the
  # > `colorkey` for the surface.  You can enable RLE acceleration on the
  # > surface afterwards by calling:
  #
  #   image.set_color_key
  module Image
    extend FFI::Library
    extend Library
    ffi_lib SDL_IMAGE_MODULE

    module INIT
      include EnumerableConstants
      JPG = next_const_value
      PNG = next_const_value
      TIF = next_const_value
      WEBP = next_const_value
    end
    enum :init_flags, INIT.flatten_consts

    ##
    # Loads dynamic libraries and prepares them for use.  Flags should be
    # one or more flags from IMG_InitFlags OR'd together.
    # It returns the flags successfully initialized, or 0 on failure.
    api :IMG_Init, [:init_flags], :int, {error: true, filter: OK_WHEN_NOT_ZERO}
    ##
    # Unloads libraries loaded with init.
    api :IMG_Quit, [], :void
    ##
    # Load a surface of a specified type (string) from a specified RWops,
    # The integer indicates if the source should be freed.
    api :IMG_LoadTyped_RW, [RWops.by_ref, :int, :string], Surface.ptr
    ##
    # Autodetect format and load a surface from a path string
    api :IMG_Load, [:string], Surface.ptr, {error: true, filter: OK_WHEN_NOT_NULL }
    ##
    # Autodetect format and load a surface from a RWops
    api :IMG_Load_RW, [RWops.by_ref, :int], Surface.ptr

    ##
    # Check if RWops is a ICO?
    api :IMG_isICO, [RWops.by_ref], :int
    ##
    # Check if RWops is a CUR?
    api :IMG_isCUR, [RWops.by_ref], :int
    ##
    # Check if RWops is a BMP?
    api :IMG_isBMP, [RWops.by_ref], :int
    ##
    # Check if RWops is a GIF?
    api :IMG_isGIF, [RWops.by_ref], :int
    ##
    # Check if RWops is a JPG?
    api :IMG_isJPG, [RWops.by_ref], :int
    ##
    # Check if RWops is a LBM?
    api :IMG_isLBM, [RWops.by_ref], :int
    ##
    # Check if RWops is a PCX?
    api :IMG_isPCX, [RWops.by_ref], :int
    ##
    # Check if RWops is a PNG?
    api :IMG_isPNG, [RWops.by_ref], :int
    ##
    # Check if RWops is a PNM?
    api :IMG_isPNM, [RWops.by_ref], :int
    ##
    # Check if RWops is a TIF?
    api :IMG_isTIF, [RWops.by_ref], :int
    ##
    # Check if RWops is a XCF?
    api :IMG_isXCF, [RWops.by_ref], :int
    ##
    # Check if RWops is a XPM?
    api :IMG_isXPM, [RWops.by_ref], :int
    ##
    # Check if RWops is a XV?
    api :IMG_isXV, [RWops.by_ref], :int
    ##
    # Check if RWops is a WEBP?
    api :IMG_isWEBP, [RWops.by_ref], :int

    ##
    # Load a ICO from a given RWops
    api :IMG_LoadICO_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a CUR from a given RWops
    api :IMG_LoadCUR_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a BMP from a given RWops
    api :IMG_LoadBMP_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a GIF from a given RWops
    api :IMG_LoadGIF_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a JPG from a given RWops
    api :IMG_LoadJPG_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a LBM from a given RWops
    api :IMG_LoadLBM_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a PCX from a given RWops
    api :IMG_LoadPCX_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a PNG from a given RWops
    api :IMG_LoadPNG_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a PNM from a given RWops
    api :IMG_LoadPNM_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a TGA from a given RWops
    api :IMG_LoadTGA_RW, [RWops.by_ref], Surface.ptr
    ##
    # Load a TIF from a given RWops
    api :IMG_LoadTIF_RW, [RWops.by_ref], Surface.ptr, method_name: :load_TIF_rw
    ##
    # Load an XCF from a given RWops
    api :IMG_LoadXCF_RW, [RWops.by_ref], Surface.ptr, method_name: :load_XCF_rw
    ##
    # Load an XPM from a given RWops
    api :IMG_LoadXPM_RW, [RWops.by_ref], Surface.ptr, method_name: :load_XPM_rw
    ##
    # Load an XV from a given RWops
    api :IMG_LoadXV_RW, [RWops.by_ref], Surface.ptr, method_name: :load_XV_rw
    ##
    # Load a WEBP from a given RWops
    api :IMG_LoadWEBP_RW, [RWops.by_ref], Surface.ptr

    ##
    # Read an XPM from a memory pointer
    api :IMG_ReadXPMFromArray, [:pointer], Surface.ptr
    ##
    # Save given surface as PNG to given path
    api :IMG_SavePNG, [Surface.by_ref, :string], :int
    ##
    # Save given surface as PNG to given RWops
    api :IMG_SavePNG_RW, [Surface.by_ref, RWops.by_ref, :int], :int

  end
  ##
  # Alias to follow IMG_xxx convention
  IMG = Image 

end