require 'sdl2'
# Stub for now.. need to implement!!!
module SDL2
  class Texture < FFI::Struct
    def self.release(pointer)
      SDL2.destroy_texture(pointer)
    end
  end
end