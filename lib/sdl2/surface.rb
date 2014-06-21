require 'sdl2/error'
require 'sdl2/rwops'
require 'sdl2/pixels'
require 'sdl2/rect'
require 'sdl2/palette'

##
# SDL2 provides surfaces. Representations of bit-mapped images in memory.
module SDL2
  typedef :uint32, :surface_flags
  ##
  #\brief A collection of pixels used in software blitting.
  #
  #\note  This structure should be treated as read-only, except for \c pixels,
  #       which, if not NULL, contains the raw pixel data for the surface.
  class Surface < Struct
    ##
    # The field accessor has been made private for safety, maybe.
    private :[], :[]=

    layout :flags, :surface_flags,
    :format, PixelFormat.by_ref,
    :w, :int,
    :h, :int,
    :pitch, :int,
    :pixels, :pointer,
    :userdata, :pointer,
    :locked, :int,
    :lock_data, :pointer,
    :clip_rect, Rect,
    :map, :pointer,
    :refcount, :int

    ##
    # All members are read-only
    member_readers(*members)

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

    ##
    # Use this function to determine whether a surface must be locked for access
    # Macro, redefined here for use.  Seems to just check if RLEACCEL is true.
    def must_lock?
      self[:flags] & RLEACCEL != 0
    end

    ##
    # Blit from source to this surface
    def blit_in(src, src_rect = nil, dst_rect = nil)
      src_rect = Rect.cast(src_rect)
      dst_rect = Rect.cast(dst_rect)
      SDL2.blit_surface!(src, src_rect, self, dst_rect)
    end

    ##
    # Blit from this surface to dest
    def blit_out(dest, dst_rect = nil, src_rect = nil)
      src_rect = Rect.cast(src_rect)
      dst_rect = Rect.cast(dst_rect)
      SDL2.blit_surface!(self, src_rect, dest, dst_rect)
    end

    ##
    # Perform a scaled blit into this surface
    def blit_in_scaled(src, src_rect = nil, dst_rect = nil)
      src_rect = Rect.cast(src_rect)
      dst_rect = Rect.cast(dst_rect)
      SDL2.blit_scaled!(src, src_rect, self, dst_rect = nil)
    end

    ##
    # Perform a scaled blit out from this surface
    def blit_out_scaled(dst, dst_rect = nil, src_rect = nil)
      src_rect = Rect.cast(src_rect)
      dst_rect = Rect.cast(dst_rect)
      SDL2.blit_scaled!(self, src_rect, dst, dst_rect)
    end

    ##
    # Enable or disable surface RLE
    def set_rle(flag)
      SDL2.set_surface_rle!(self, flag)
    end
    ##
    # #rle= is #set_rle
    alias_method :rle=, :set_rle
    
    ##
    # Return a copy of the alpha modulation
    def get_alpha_mod()
      modulation = SDL2::TypedPointer::UInt8.new
      SDL2.get_surface_alpha_mod!(self, modulation)
      modulation.value
    end
    ##
    # See: SDL2::Surface#get_alpha_mod
    alias_method :alpha_mod, :get_alpha_mod
    ##
    # Set the surface alpha modulation   
    def set_alpha_mod(modulation)
      SDL2.set_surface_alpha_mod!(self, modulation)
    end
    ##
    # See: SDL2::Surface#set_alpha_mod
    alias_method :alpha_mod=, :set_alpha_mod
    ##
    # Retrieve the SurfaceBlendMode
    def get_blend_mode
      mode = SDL2::TypedPointer::BlendMode.new
      SDL2.get_surface_blend_mode!(self, mode)
      mode.value
    end
    ##
    # See: SDL2::Surface#get_blend_mode
    alias_method :blend_mode, :get_blend_mode
    ##
    # Set the Surface's current Blend Mode
    def set_blend_mode(blend_mode)
      SDL2.set_surface_blend_mode!(self, blend_mode)
    end
    alias_method :blend_mode=, :set_blend_mode
    # Sets the color key for this surface.
    #   *  key may be 1) A pixel value encoded for this surface's format
    # 2) Anything that Color::cast can handle.
    # 3) Nil, which will disable the color key for this surface.
    def set_color_key(key)

      if key.nil?#then disable color keying
        SDL2.set_color_key(self, false, 0)
      else# Enable color key by value
        #binding.pry
        if key.kind_of? Integer
          pixel_value = key
        else
          pixel_value = format.map_rgb(Color.cast(key))
        end
        SDL2.set_color_key(self, true, pixel_value)
      end
    end
    ##
    # Get the color modulation
    # Returns the SDL2::Color representation of the color modulation
    def get_color_mod
      colors = 3.times.map{SDL2::TypedPointer::UInt8.new}
      SDL2.get_surface_color_mod!(self, *colors)
      SDL2::Color.cast(colors.map(&:value))
    end 
    ##
    # See: `#get_color_mod
    alias_method :color_mod, :get_color_mod
    ##
    # Set the color modulation
    def set_color_mod(*colors)
      raise "No color specified" unless colors.count >= 1
      if colors.count == 1
        c = SDL2::Color.cast(colors[0])
      else
        c = SDL2::Color.cast(colors)
      end
      SDL2.set_surface_color_mod!(self, c.r, c.g, c.b)
      c
    end
    ##
    # See: `#set_color_mod`
    alias_method :color_mod=, :set_color_mod
    ##
    # Gets the color key for this surface.
    # @returns Nil, indicating no color keying, or the encoded pixel value used.
    def get_color_key()
      key = TypedPointer::UInt32.new
      if SDL2.get_color_key(self, key) == -1
        nil
      else
        key.value
      end
    end
    #
    ##
    # color_key is the same as get_color_key
    alias_method :color_key, :get_color_key
    ##
    # color_key = is the same as set_color_key
    alias_method :color_key=, :set_color_key

    ##
    # Gets a COPY of the current clip rect
    def get_clip_rect
      copy = SDL2::Rect.new
      SDL2.get_clip_rect(self, copy)
      copy
    end

    ##
    # Sets the current clip rect (properly)
    # Returns true if the new clip rect intersects the surface
    # Returns false otherwise and all operations will be clipped.
    def set_clip_rect?(to_rect)
      to_rect = SDL2::Rect.cast(to_rect)
      SDL2.set_clip_rect?(self, to_rect)
    end

    ##
    # Sets the current clip rect
    # returns the set clip rect
    def clip_rect=(new_rect)
      self.set_clip_rect?(new_rect)
      new_rect
    end

    # Convert existing surface into this surface's format
    def convert(surface, flags = 0)
      raise "surface may not be nil" if surface.nil?
      SDL2.convert_surface!(surface, self.format, flags)
    end

    ##
    # Fill a rectangle within surface with a color.
    # Unless color is an intager, it will be cast to a SDL2::Color
    # and then mapped using this surface's format.
    # THe rect will be cast to an SDL2::Rect
    def fill_rect(rect, color)
      if color.kind_of? Integer
        pixel_value = color
      else
        pixel_value = format.map(Color.cast(color))
      end
      rect = Rect.cast(rect)
      SDL2.fill_rect!(self, rect, pixel_value)
    end

    ##
    # Fill a set of rectangles.
    # Rects should be an array of things that are or can
    # be cast to SDL2::Rects.
    # Color may be an Integer value or something that
    # can be cast to an SDL2::Color
    def fill_rects(rects, color)
      if color.kind_of? Integer
        pixel_value = color
      else
        pixel_value = format.map(Color.cast(color))
      end
      rects = SDL2::StructArray.clone_from(rects, SDL2::Rect)
      SDL2.fill_rects!(self, rects.first, rects.count, pixel_value)
    end

    # Returns a RECT for the whole surface:
    def rect
      Rect.cast(x: 0, y: 0, w: self.w, h: self.h)
    end

  end

  callback :blit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int

  ##
  # Use this function to allocate a new RGB surface
  # :surface_flags/:uint32 -> "flags are unused and should be set to 0"
  # :int -> width
  # :int -> height
  # :int -> depth
  # :uint32 -> Rmask
  # :uint32 -> Gmask
  # :uint32 -> Bmask
  # :uint32 -> Amask
  api :SDL_CreateRGBSurface, [:surface_flags, :int, :int, :int, :uint32, :uint32, :uint32, :uint32], Surface.ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  # Use this to allocate a new RGB surface with existing pixel data.
  # * :pointer -> Exisiting Pixel Data
  # * :int -> width
  # * :int -> height
  # * :int -> depth
  # * :int -> pitch
  # * :uint32 -> Rmask
  # * :uint32 -> Gmask
  # * :uint32 -> Bmask
  # * :uint32 -> Amask
  api :SDL_CreateRGBSurfaceFrom, [:pointer, :int, :int, :int, :int, :uint32, :uint32, :uint32, :uint32], Surface.ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  # Use this function to free a surface
  api :SDL_FreeSurface, [Surface.by_ref], :void
  ##
  #
  api :SDL_SetSurfacePalette, [Surface.by_ref, Palette.by_ref], :int, {error: true}
  ##
  #
  api :SDL_LockSurface, [Surface.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_UnlockSurface, [Surface.by_ref], :void
  ##
  #
  api :SDL_LoadBMP_RW, [RWops.by_ref, :int], Surface.ptr, {error: true, filter: OK_WHEN_NOT_NULL}

  # Redefine SDL_LoadBMP macro:
  def self.load_bmp(file)
    SDL2.load_bmp_rw(RWops.from_file(file, 'rb'), 1)
  end
  ##
  #
  returns_error(:load_bmp,OK_WHEN_NOT_NULL)

  ##
  #
  api :SDL_SaveBMP_RW, [Surface.by_ref, RWops.by_ref, :int], :int, {error: true, filter: OK_WHEN_ZERO}

  def self.save_bmp(surface, file)
    SDL2.save_bmp_rw(surface, RWops.from_file(file, 'wb'), 1)
  end
  ##
  #
  returns_error(:save_bmp,OK_WHEN_ZERO)

  ##
  # Use this function to set the RLE acceleration hint for a surface
  # NOTE: If RLE is enabled, color key and alpha blending blits are much faster,
  # but the surface must be locked before directly accessing the pixels.
  api :SDL_SetSurfaceRLE, [Surface.by_ref, :int], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SetColorKey, [Surface.by_ref, :bool, :uint32], :int, {error: true}
  ##
  # Use this function to get the color key (transparent pixel) for a surface
  # * Surface -> Surface to query for it's current color key
  # * TypedPointer::UInt32 -> The place to store the result.
  api :SDL_GetColorKey, [Surface.by_ref, TypedPointer::UInt32.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SetSurfaceColorMod, [Surface.by_ref, :uint8, :uint8, :uint8], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_GetSurfaceColorMod, [Surface.by_ref, TypedPointer::UInt8.by_ref,TypedPointer::UInt8.by_ref,TypedPointer::UInt8.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SetSurfaceAlphaMod, [Surface.by_ref, :uint8], :int, {error: true}
  ##
  # Get additional alpha value used in blit operations
  # * Surface -> Surface to query
  # * TypedPointer::Uint8 -> The place to store the result
  api :SDL_GetSurfaceAlphaMod, [Surface.by_ref,TypedPointer::UInt8.by_ref], :int, {error: true}
  ##
  # Set a surface's blend mode
  api :SDL_SetSurfaceBlendMode, [Surface.by_ref, :blend_mode], :int, {error: true}
  ##
  #
  api :SDL_GetSurfaceBlendMode, [Surface.by_ref, SDL2::TypedPointer::BlendMode.by_ref], :int, {error: true}
  ##
  # Returns true if the rect intersects the surface, false if it does not and everything would be clipped.
  api :SDL_SetClipRect, [Surface.by_ref, Rect.by_ref], :bool
  ##
  # Use this function to get the clipping rectangle.
  # Note: You must give it a Rect to use for returning values
  # * Surface -> The surface to query
  # * Rect -> The rect to store the result in
  api :SDL_GetClipRect, [Surface.by_ref, Rect.by_ref], :void
  ##
  # Copy existing surface into a new one that is optimized for blitting to a
  # surface of specified pixel format.
  # * Surface -> Source of pixels to reformat
  # * PixelFormat -> Destination Surface's desired PixelFormat
  # * :surface_flags -> Features requested of the Destination Surface
  # NOTE: SDL2's documentation says the flags are unused and should be set to 0
  api :SDL_ConvertSurface, [Surface.by_ref, PixelFormat.by_ref, :surface_flags], Surface.ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  # Use this function to copy an existing surface to a new  surface of the specified format
  # * Surface -> Source of pixels to reformat
  # * :uint32/:pixel_format -> Destination Surface's desired PixelFormat
  # * :surface_flags -> Unused and should be zero according to SDL's docs.
  api :SDL_ConvertSurfaceFormat, [Surface.by_ref, :pixel_format, :surface_flags], Surface.ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  # Copy a block of pixels from one format to another:
  # * :int -> width
  # * :int -> height
  # * :uint32/:pixel_format -> src_format
  # * :pointer -> src
  # * :int -> src_pitch
  # * :uint32/:pixel_format -> dst_format
  # * :pointer -> dst
  # * :int -> dst_pitch
  api :SDL_ConvertPixels, [:int, :int, :pixel_format, :pointer, :int, :pixel_format, :pointer, :int], :int, {error: true}
  ##
  # fast fill of a rectangle with a specific color
  # * Surface -> destination
  # * Rect -> Rectangle struct of cords to use
  # * :uint32 -> Color value to use in fill
  api :SDL_FillRect, [Surface.by_ref, Rect.by_ref, :uint32], :int, {error: true}
  ##
  # fast fill of a set of rectangles in specific color to a surface
  # * Surface -> destination
  # * Rect -> First rectangle in an array (See: SDL2::StructArray)
  # * :int/:count -> The count of number of rectangles in said array.
  # * :uint32 -> Color value to fast fill with
  api :SDL_FillRects, [Surface.by_ref, Rect.by_ref, :count, :uint32], :int, {error: true}
  ##
  # See: `blit_surface`
  api :SDL_UpperBlit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int, {error: true}

  ##
  # Use this function to perform a fast surface copy to a destination surface
  # Note: using `upper_blit`
  def self.blit_surface(src, srcrect, dst, dstrect)
    upper_blit(src, srcrect, dst, dstrect)
  end
  ##
  # See: `blit_surface`
  returns_error(:blit_surface, OK_WHEN_ZERO)
  ##
  # See: `blit_surface`
  # See: https://wiki.libsdl.org/SDL_LowerBlit
  api :SDL_LowerBlit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SoftStretch, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  ##
  # See: `blit_scaled`
  api :SDL_UpperBlitScaled, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int

  ##
  # Use this function to perform a scaled surface copy to a destination surface.
  # NOTE: This method uses `upper_blit_scaled`
  def self.blit_scaled(src, srcrect, dst, dstrect)
    upper_blit_scaled(src, srcrect, dst, dstrect)
  end
  ##
  # See `blit_scaled`
  returns_error(:blit_scaled, OK_WHEN_ZERO)
  ##
  # See `blit_scaled`
  api :SDL_LowerBlitScaled, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
end