require 'sdl2/error'
require 'sdl2/rwops'
require 'sdl2/pixels'
require 'sdl2/rect'
require 'sdl2/palette'

#require 'sdl2/pixel_format'

module SDL2
  typedef :uint32, :surface_flags

  #\brief A collection of pixels used in software blitting.
  #
  #\note  This structure should be treated as read-only, except for \c pixels,
  #       which, if not NULL, contains the raw pixel data for the surface.
  class Surface < Struct

    private :[]

    layout :flags, :surface_flags,
    :format, PixelFormat.by_ref,
    :w, :int,
    :h, :int,
    :pixels, :pointer,
    :userdata, :pointer,
    :locked, :int,
    :lock_data, :pointer,
    :clip_rect, Rect,
    :map, :pointer,
    :refcount, :int

    member_readers(*members)

    [:flags, :format, :w, :h, :pixels, :userdata, :locked, :lock_data, :clip_rect, :map, :refcount].each do |field|
      define_method field do
        self[field]
      end
    end

    def self.release(pointer)
      SDL2.free_surface(pointer)
    end

    # Allocate and free an RGB surface
    # If depth is 4 or 8 bits, an empty palette is allocated for the surface.
    # If depth is > 8 bits, the pixel format is set using the flag masks.
    # If the function runs out of memory, it will return NULL.
    def self.create_rgb(flags, width, height, depth, rmask = 0, gmask = 0, bmask = 0, amask = 0)
      SDL2.create_rgb_surface!(flags, width, height, depth, rmask, gmask, bmask, amask)
    end

    def self.create_rgb_from(pixels, width, height, depth, pitch, rmask, gmask, bmask, amask)
      SDL2.create_rgb_surface_from!(pixels, width, height, depth, pitch, rmask, gmask, bmask, amask)
    end

    def self.load_bmp_rw(rwops, freesrc = 0)
      SDL2.load_bmp_rw!(rwops, freesrc)
    end

    def self.load_bmp(file)
      SDL2.load_bmp!(file)
    end

    def save_bmp_rw(rwops, freedst = 0)
      SDL2.save_bmp_rw!(self, rwops, freedst)
    end

    def save_bmp(file)
      SDL2.save_bmp!(self, file)
    end

    def free
      SDL2.free_surface(self)
    end

    def set_palette(palette)
      SDL2.set_surface_palette!(self, palette)
    end

    def get_palette()
      #SDL2.get_surface_palette!(self)
      format.palette
    end

    alias_method :palette=, :set_palette
    alias_method :palette, :get_palette

    def lock()
      SDL2.lock_surface(self)
    end

    def unlock()
      SDL2.unlock_surface(self)
    end

    # Surface Flags
    SWSURFACE = 0
    PREALLOC  = 0x00000001
    RLEACCEL  = 0x00000002
    DONTFREE  = 0x00000004

    # Macro, redefined here for use.
    def mustlock?
      self[:flags] & RLEACCEL != 0
    end

    # Blit from source to this surface
    def blit_in(src, src_rect = nil, dst_rect = nil)
      
      
      src_rect = Rect.cast(src_rect)
      dst_rect = Rect.cast(dst_rect)
      
      SDL2.blit_surface!(src, src_rect, self, dst_rect)
    end

    # Blit from this surface to dest
    def blit_out(dest, dst_rect = nil, src_rect = nil)
      src_rect = Rect.cast(src_rect)
      dst_rect = Rect.cast(dst_rect)
      SDL2.blit_surface!(self, src_rect, dest, dst_rect)
    end

    def set_rle(flag)
      SDL2.set_surface_rle!(self, flag)
    end

    alias_method :rle=, :set_rle

    # Sets the color key for this surface.
    # @param key may be 1) A pixel value encoded for this surface's format
    # 2) Anything that Color::cast can handle.
    # 3) Nil, which will disable the color key for this surface.
    def set_color_key(key)
      if key.kind_of? Integer
        pixel_value = key
      else
        pixel_value = format.map_rgb(Color.cast(key))
      end

      if key.nil?#then disable color keying
        SDL2.set_color_key(self, false, 0)
      else# Enable color key by value
        SDL2.set_color_key(self, true, pixel_value)
      end
    end

    # Gets the color key for this surface.
    # @returns Nil, indicating no color keying, or the encoded pixel value used.
    def get_color_key()
      key_s = UInt32Struct.new
      if SDL2.get_color_key?(self, key_s)
        result = key_s[:value]
      else
        result = nil
      end
      key_s.free
      return result
    end

    alias_method :color_key, :get_color_key
    alias_method :color_key=, :set_color_key

    # Convert existing surface into this surface's format
    def convert(surface, flags = 0)
      SDL2.convert_surface!(surface, self.format, flags)
    end
    
    def fill_rect(rect, color)
      
      if color.kind_of? Integer
        pixel_value = color
      else
        
        pixel_value = format.map(Color.cast(color))
      end
      rect = Rect.cast(rect)
      SDL2.fill_rect!(self, rect, pixel_value)
    end
    
    # Returns a RECT for the whole surface:
    def rect
      Rect.cast(x: 0, y: 0, w: self.w, h: self.h)
    end
    
  end

  callback :blit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int

  ##
	#
	api :SDL_CreateRGBSurface, [:surface_flags, :int, :int, :int, :uint32, :uint32, :uint32, :uint32], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_FreeSurface, [Surface.by_ref], :void
  ##
	#
	api :SDL_SetSurfacePalette, [Surface.by_ref, Palette.by_ref], :int, {error: true}
  ##
	#
	api :SDL_LockSurface, [Surface.by_ref], :int
  ##
	#
	api :SDL_UnlockSurface, [Surface.by_ref], :void
  ##
	#
	api :SDL_LoadBMP_RW, [RWops.by_ref, :int], Surface.auto_ptr

  # Redefine SDL_LoadBMP macro:
  def self.load_bmp(file)
    SDL2.load_bmp_rw(RWops.from_file(file, 'rb'), 1)
  end

  returns_error(:load_bmp,TRUE_WHEN_NOT_NULL)

  ##
	#
	api :SDL_SaveBMP_RW, [Surface.by_ref, RWops.by_ref, :int], :int

  def self.save_bmp(surface, file)
    SDL2.save_bmp_rw(surface, RWops.from_file(file, 'wb'), 1)
  end

  ##
	#
	api :SDL_SetSurfaceRLE, [Surface.by_ref, :int], :int
  ##
	#
	api :SDL_SetColorKey, [Surface.by_ref, :bool, :int], :int, {error: true}
  ##
	#
	api :SDL_GetColorKey, [Surface.by_ref, UInt32Struct.by_ref], :int, {error: true}
  # Could mean an SDL error... or maybe not?
  boolean? :get_color_key, TRUE_WHEN_ZERO
  ##
	#
	api :SDL_SetSurfaceColorMod, [Surface.by_ref, :uint8, :uint8, :uint8], :int
  ##
	#
	api :SDL_GetSurfaceColorMod, [Surface.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :int
  ##
	#
	api :SDL_SetSurfaceAlphaMod, [Surface.by_ref, :uint8], :int, {error: true}
  ##
	#
	api :SDL_GetSurfaceAlphaMod, [Surface.by_ref,UInt8Struct.by_ref], :int, {error: true}
  ##
	#
	api :SDL_SetSurfaceBlendMode, [Surface.by_ref, :blend_mode], :int, {error: true}
  ##
	#
	api :SDL_GetSurfaceBlendMode, [Surface.by_ref, BlendModeStruct.by_ref], :int, {error: true}
  ##
	#
	api :SDL_SetClipRect, [Surface.by_ref, Rect.by_ref], :int, {error: true}
  ##
	#
	api :SDL_GetClipRect, [Surface.by_ref, Rect.by_ref], :int, {error: true}
  ##
	#
	api :SDL_ConvertSurface, [Surface.by_ref, PixelFormat.by_ref, :surface_flags], Surface.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_ConvertSurfaceFormat, [Surface.by_ref, :pixel_format, :surface_flags], Surface.auto_ptr
  ##
	#
	api :SDL_ConvertPixels, [:int, :int, :pixel_format, :pointer, :int, :pixel_format, :pointer, :int], :int, {error: true}
  ##
	#
	api :SDL_FillRect, [Surface.by_ref, Rect.by_ref, :uint32], :int, {error: true}
  ##
	#
	api :SDL_FillRects, [Surface.by_ref, Rect.by_ref, :count, :uint32], :int, {error: true}
  ##
	#
	api :SDL_UpperBlit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int, {error: true}

  # using upper_blit
  def self.blit_surface(src, srcrect, dst, dstrect)
    
    upper_blit(src, srcrect, dst, dstrect)
  end

  returns_error(:blit_surface, TRUE_WHEN_ZERO)

  ##
	#
	api :SDL_LowerBlit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_SoftStretch, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_UpperBlitScaled, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int

  # using upper_blit_scaled
  def self.blit_scaled(src, srcrect, dst, dstrect)
    upper_blit_scaled(src, srcrect, dst, dstrect)
  end

  returns_error(:blit_scaled, TRUE_WHEN_ZERO)

  ##
	#
	api :SDL_LowerBlitScaled, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int

end