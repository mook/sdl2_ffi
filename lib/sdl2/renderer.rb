require 'sdl2/window'

module SDL2
  
  class Renderer < FFI::Struct
    layout :blank, :uint8 # Ignore Structure?
    SOFTWARE       = 0x00000001         
    ACCELERATED    = 0x00000002      
    PRESENTVSYNC   = 0x00000004     
    TARGETTEXTURE  = 0x00000008        
    
    def release(pointer)
      destroy_renderer(pointer)
    end
    
  end    
  
  enum :renderer_flags, [
      :software, Renderer::SOFTWARE,
      :accelerated, Renderer::ACCELERATED,
      :present_vsync, Renderer::PRESENTVSYNC,
      :target_texture, Renderer::TARGETTEXTURE
    ]
      
  attach_function :create_render, :SDL_CreateRender, [Window.by_ref, :int, :render_flags], Render.auto_ptr
  attach_function :create_window_and_renderer, :SDL_CreateWindowAndRender, [:int, :int, :renderer_flags, Window.auto_ptr, Renderer.auto_ptr], :int
    
  class RendererInfo < FFI::Struct              
    layout :name, :string,
      :flags, :uint32,
      :num_texture_formats, :uint32,
      :texture_formats, [:uint32, 16],
      :max_texture_width, :int,
      :max_texture_height, :int
  end
end