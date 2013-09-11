require 'sdl2'
require 'sdl2/renderer_info'
module SDL2
  
  class Renderer < Struct
    layout :blank, :uint8 # Ignore Structure?
    SOFTWARE       = 0x00000001         
    ACCELERATED    = 0x00000002      
    PRESENTVSYNC   = 0x00000004     
    TARGETTEXTURE  = 0x00000008
    
    def self.create(window, driver_idx, flags)
      create_render(window, driver_idx, flags)
    end
    
    def self.get(window)
      get_renderer(window)
    end
    
    def self.create_software(surface)
      create_software_renderer(surface)
    end         
    
    def self.release(pointer)
      destroy_renderer(pointer)
    end
    
    def clear
      render_clear(self)
    end
    
  end    
   
  
  #TODO: Move this to the right spot.
#  attach_function :create_renderer, :SDL_CreateRenderer, [Window.by_ref, :int, :render_flags], Render.auto_ptr
#  attach_function :get_renderer, :SDL_GetRenderer, [Window.by_ref], Renderer.auto_ptr
#  
#  attach_function :destroy_renderer, :SDL_DestroyRenderer, [Renderer.by_ref], :void
#  attach_function :create_software_renderer, :SDL_CreateSoftwareRenderer, [Surface.by_ref], Render.auto_ptr
#  
#  attach_function :get_render_driver_info, :SDL_GetRenderDriverInfo, [:int, RendererInfo.by_ref], :int
#  
#  attach_function :get_renderer_info, :SDL_GetRendererInfo, [Renderer.by_ref, RendererInfo.by_ref], :int
#  attach_function :get_num_render_drivers, :SDL_GetNumRenderDrivers,[],:int
#    
#  attach_function :get_render_draw_blend_mode, :SDL_GetRenderDrawBlendMode,[Renderer.by_ref, BlendMode.by_ref], :int
#  attach_function :get_render_draw_color, :SDL_GetRenderDrawColor, [Renderer.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref], :int
#  
#  attach_function :render_clear, :SDL_RenderClear, [Renderer.by_ref], :int
#  attach_function :render_copy, :SDL_RenderCopy, [Render.by_ref, Texture.by_ref, Rect.by_ref, Rect.by_ref], :int

end