require 'sdl2'

module SDL2
  #SDL_pixels.h:252~258
  class Color < Struct
    layout :r, :uint8,
      :g, :uint8,
      :b, :uint8,
      :a, :uint8
  end
  Colour = Color # Because SDL does it  
end