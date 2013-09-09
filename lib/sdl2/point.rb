require 'sdl'

module SDL2
  class Point < FFI::Struct
    layout :x, :int, :y, :int
  end
end