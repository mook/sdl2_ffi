require 'sdl2'
require 'sdl2/palette'

module SDL2

  # SDL_pixels.h:272~293:typdef struct SDL_PixelFormat
  # \note Everything in the pixel format structure is read-only.
  class PixelFormat < Struct

    protected :[] # see note

    layout :format, :pixel_format,
    :palette, Palette.by_ref,
    :bits_per_pixel, :uint8,
    :bytes_per_pixel, :uint8,
    :padding, [:uint8, 2],
    :r_mask, :uint32,
    :g_mask, :uint32,
    :b_mask, :uint32,
    :a_mask, :uint32,
    :r_loss, :uint8,
    :g_loss, :uint8,
    :b_loss, :uint8,
    :a_loss, :uint8,
    :refcount, :int,
    :next, PixelFormat.by_ref

    # Because the struct is read-only
    [:format, :palette, :bytes_per_pixel, :bits_per_pixel,
      :padding, :r_mask, :g_mask, :b_mask, :a_mask,
      :r_loss, :g_loss, :b_loss, :refcount, :next].each do |field|
      define_method field do
        self[field]
      end
    end

    # Get the human readable name of a pixel format
    def self.get_name(pixel_format)
      SDL2.get_pixel_format_name(pixel_format)
    end

    # Get the human readable name of this pixel format
    def get_name
      self.class.get_name self.format
    end

    # Convert enumerated pixel value format to bpp & RGBA mask values
    # TODO: Review why this is needed?  Why not just read the Struct fields?
    def self.to_masks(format)
      p = Hash.new(){TypedPointer::UInt32.new}
      p[:bpp] = TypedPointer::Int.new
      SDL2.pixel_format_enum_to_masks(format, p[:bpp], p[:Rmask], p[:Bmask],p[:Amask])
      result = []
      p.each_value{|s|result << s[:value]}
      p.each(&:free)
      return result
    end
    
    # TODO Review Redundancy: Basically return the masks you could read directly anyway?
    def to_masks()
      self.class.to_masks(self.format)
    end
    
    # SDL_AllocFormat, renamed 'create' to follow ruby paradigms.
    # Create an PixelFormat from the Enumerated format value.
    def self.create(pixel_format)
      SDL2.alloc_format!(pixel_format)
    end
       
    # SDL_FreeFormat, renamed 'release' to follow FFI paradigms.
    def self.release(pointer)
      SDL2.free_format(pointer)
    end

    # Set the palette
    def set_palette(palette)
      SDL2.set_pixel_format_palette(self, palette)
    end
    
    alias_method :palette=, :set_palette
    
    # Maps a color struct to a pixel value.
    def map(color)
      #binding.pry
      c = Color.cast(color)
      map_rgba(c.to_a)
    end
    
    # Maps an RGB triple (array) to an opaque pixel value    
    def map_rgb(rgb)
      r, g, b = *rgb
      SDL2.map_rgb(self, r, g, b)
    end

    # Maps an RGBA quadruple (array) to a pixel value
    def map_rgba(rgba)
      r, g, b, a = rgba
      a = 0 if a.nil?
      SDL2.map_rgba(self, r, g, b, a)
    end
    
    # Get the RGB components (array) from a pixel value
    def get_rgb(pixel)
      ptr = Hash.new(){TypedPointer::UInt8.new}
      SDL2.get_rgb(pixel, self, ptr[:r], ptr[:g], ptr[:b])
      result = []
      ptr.each_value{|s|result << s[:value]}
      ptr.each(&:free)
      return result
    end

    # Get the RGBA components (array) from a pixel value
    def get_rgba(pixel)
      ptr = Hash.new(){TypedPointer::UInt8.new}
      SDL2.get_rgba(pixel, self, ptr[:r], ptr[:g], ptr[:b], ptr[:a])
      result = []
      ptr.each_value{|s|result << s[:value]}
      ptr.each(&:free)
      return result
    end
    
    
  end

end