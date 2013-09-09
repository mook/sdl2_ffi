require 'sdl2'
#require 'sdl2/point'

module SDL2
  class Rect < FFI::Struct
    layout :x, :int, :y, :int, :w, :int, :h, :int
  end
end