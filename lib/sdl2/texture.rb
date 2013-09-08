require 'sdl2'

module SDL2
  class Texture < FFI::Struct
    # TODO: Layout of Texture struct
    
    def self.create(renderer, format, access, w, h)
      create_texture(renderer, format, access.to_i, w.to_i, h.to_i)
    end
    
    def self.create_from_surface(renderer, surface)
      create_texture_from_surface(renderer, surface)
    end
    
    def self.release(pointer)
      destroy_texture(pointer)
    end
    
  end
    
  attach_function :create_texture, :SDL_CreateTexture, [Renderer.by_ref, :uint32, :int, :int, :int], Texture.auto_ptr
  attach_function :create_texture_from_surface, :SDL_CreateTextureFromSurface, [Renderer.by_ref, Surface.by_ref], Texture.auto_ptr
  
  attach_function :destroy_texture, :SDL_DestroyTexture, [Texture.by_ref], :void
  
  attach_function :get_texture_alpha_mod, :SDL_GetTextureAlphaMod, [Texture.by_ref, UInt8Struct.by_ref], :int
  attach_function :get_texture_blend_mode, :SDL_GetTextureBlendMode, [Texture.by_ref, BlendMode.by_ref], :int
  attach_function :get_texture_color_mod, :SDL_GetTextureColorMod, [Texture.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref], :int
  
  attach_function :lock_texture, :SDL_LockTexture, [Texture.by_ref, Rect.by_ref, :pixels, :pitch], :int
  attach_function :query_texture, :SDL_QueryTexture, [Texture.by_ref, UInt32Struct.by_ref, IntStruct.by_ref, IntStruct.by_ref, IntStruct.by_ref], :int
end