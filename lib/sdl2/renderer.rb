require 'sdl2'
require 'sdl2/renderer_info'
module SDL2
  
  module RENDERER
    include EnumerableConstants
    
    SOFTWARE       = 0x00000001         
    ACCELERATED    = 0x00000002      
    PRESENTVSYNC   = 0x00000004     
    TARGETTEXTURE  = 0x00000008
  end
  
  class Renderer < Struct
    include RENDERER
    
    layout :blank, :uint8 # Ignore Structure?    
    
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
   
end