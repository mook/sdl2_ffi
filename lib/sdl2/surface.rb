require 'sdl2'
require 'sdl2/pixel_format'

module SDL2
  class Surface < FFI::Struct
    layout :flags, :uint32,
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

  end
end