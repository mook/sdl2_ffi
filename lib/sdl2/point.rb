require 'sdl2'

module SDL2
  class Point < FFI::Struct
    layout :x, :int, :y, :int
  end
end