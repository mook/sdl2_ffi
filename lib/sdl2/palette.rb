require 'sdl2'

module SDL2
  class Palette < FFI::Struct
    layout :ncolors, :int,
      :colors, :pointer,
      :version, :uint32,
      :refcount, :int      
  end
end