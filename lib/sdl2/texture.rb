require 'sdl2'
# Stub for now.. need to implement!!!
module SDL2
  class Texture < FFI::Struct
    layout :magic, :pointer,
      :format, :uint32,
      :access, :int,
      :w, :int,
      :h, :int,
      :mod_mode, :int,
      :blend_mode, :blend_mode,
      :r, :uint8,
      :g, :uint8,
      :b, :uint8,
      :a, :uint8,
      :renderer, SDL2::Renderer.by_ref,
      :native, SDL2::Texture.by_ref,
      :yuv, :pointer, #TODO: Review SDL_SW_YUVTexture
      :pixels, :pointer,
      :pitch, :int,
      :locked_rect, SDL2::Rect.by_ref,
      :driverdata, :pointer,
      :prev, SDL2::Texture.by_ref,
      :next, SDL2::Texture.by_ref
      
    def self.release(pointer)
      SDL2.destroy_texture(pointer)
    end
    
    def self.create(renderer, format, access, w, h)
      SDL2.create_texture!(renderer, format, access, w, h)
    end
  end
end