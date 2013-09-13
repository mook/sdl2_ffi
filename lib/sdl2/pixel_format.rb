require 'sdl2'
require 'sdl2/palette'

module SDL2

  #SDL_pixels.h:272~293  
  class PixelFormat < FFI::Struct
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

    [:format, :palette, :bytes_per_pixel, :bits_per_pixel,
      :padding, :r_mask, :g_mask, :b_mask, :a_mask,
      :r_loss, :g_loss, :b_loss, :refcount, :next].each do |field|
      define_method field do
        self[field]
      end
    end

    def self.release(pointer)
      SDL2.free_format(pointer)
    end
  end

end