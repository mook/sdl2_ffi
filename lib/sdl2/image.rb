require 'sdl2'
require 'sdl2/surface'
require 'sdl2/image/sdl_image_module'
require 'active_support/inflector'

module SDL2

  module Image

    extend FFI::Library
    ffi_lib SDL_IMAGE_MODULE

    def self.api(func_name, args, type)
      camelCaseName = func_name.to_s.gsub('IMG_', '')
      methodName = ActiveSupport::Inflector.underscore(camelCaseName).to_sym
      self.attach_function methodName, func_name, args, type
      return methodName
    end

    enum :init_flags, [:JPG, :PNG, :TIF, :WEBP]

    api :IMG_Init, [:init_flags], :int
    api :IMG_Quit, [], :void
    api :IMG_LoadTyped_RW, [RWops.by_ref, :int, :string], Surface.auto_ptr
    api :IMG_Load, [:string], Surface.auto_ptr
    api :IMG_Load_RW, [RWops.by_ref, :int], Surface.auto_ptr

    api :IMG_isICO, [RWops.by_ref], :int
    api :IMG_isCUR, [RWops.by_ref], :int
    api :IMG_isBMP, [RWops.by_ref], :int
    api :IMG_isGIF, [RWops.by_ref], :int
    api :IMG_isJPG, [RWops.by_ref], :int
    api :IMG_isLBM, [RWops.by_ref], :int
    api :IMG_isPCX, [RWops.by_ref], :int
    api :IMG_isPNG, [RWops.by_ref], :int
    api :IMG_isPNM, [RWops.by_ref], :int
    api :IMG_isTIF, [RWops.by_ref], :int
    api :IMG_isXCF, [RWops.by_ref], :int
    api :IMG_isXPM, [RWops.by_ref], :int
    api :IMG_isXV, [RWops.by_ref], :int
    api :IMG_isWEBP, [RWops.by_ref], :int

    api :IMG_LoadICO_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadCUR_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadBMP_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadGIF_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadJPG_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadLBM_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadPCX_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadPNG_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadPNM_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadTGA_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadTIF_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadXCF_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadXPM_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadXV_RW, [RWops.by_ref], Surface.auto_ptr
    api :IMG_LoadWEBP_RW, [RWops.by_ref], Surface.auto_ptr
    
    api :IMG_ReadXPMFromArray, [:pointer], Surface.auto_ptr
      
    api :IMG_SavePNG, [Surface.by_ref, :string], :int
    api :IMG_SavePNG_RW, [Surface.by_ref, RWops.by_ref, :int], :int

  end

  IMG = Image # Alias to follow IMG_xxx convention

end