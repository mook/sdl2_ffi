require 'sdl2'
require 'sdl2/palette'

module SDL2
  
  class PixelFormat < FFI::Struct
    layout :format, :uint32,
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
  end
  
end