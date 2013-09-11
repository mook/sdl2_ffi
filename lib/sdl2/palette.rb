require 'sdl2'

module SDL2
  #SDL_pixels.h:261~267
  class Palette < FFI::Struct
    layout :ncolors, :int,
      :colors, :pointer,
      :version, :uint32,
      :refcount, :int
      
    def self.release(pointer)
      SDL2.free_palette(pointer)
    end      
  end
end