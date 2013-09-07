require 'sdl2'
require 'sdl2/error'

module SDL2  
  # System Window
  # A rectangular area you can blit into.
  class Window < FFI::Struct
    FULLSCREEN         = 0x00000001       
    OPENGL             = 0x00000002       
    SHOWN              = 0x00000004      
    HIDDEN             = 0x00000008      
    BORDERLESS         = 0x00000010      
    RESIZABLE          = 0x00000020      
    MINIMIZED          = 0x00000040      
    MAXIMIZED          = 0x00000080      
    INPUT_GRABBED      = 0x00000100      
    INPUT_FOCUS        = 0x00000200        
    MOUSE_FOCUS        = 0x00000400        
    FULLSCREEN_DESKTOP = ( FULLSCREEN | 0x00001000 )
    FOREIGN            = 0x00000800    
    
    layout :nothing, :uint8        
    
    def self.create(title ='', x = 0, y = 0, w = 100, h = 100, flags = 0)
      create_window(title, x, y, w, h, flags)
    end
    
    def self.create_from(data)      
      create_window_from(data)
    end
    
    private_class_method :new 
    
    
    def self.create!(*args)
      creation = create(*args)
      get_error() if creation.null?
      return creation
    end
    
    def self.release(pointer)
      destroy_window(pointer)
    end             
    
  end
  
  enum :window_flags, [
    :fullscreen, Window::FULLSCREEN,
    :opengl, Window::OPENGL,
    :shown, Window::SHOWN,
    :hidden, Window::HIDDEN,
    :borderless, Window::BORDERLESS,
    :minimized, Window::MINIMIZED,
    :maximized, Window::MAXIMIZED,
    :input_grabbed, Window::INPUT_GRABBED,
    :input_focus, Window::INPUT_FOCUS,
    :mouse_focus, Window::MOUSE_FOCUS,
    :fullscreen_desktop, Window::FULLSCREEN_DESKTOP,
    :foreign, Window::FOREIGN
  ]
  
  attach_function :create_window, :SDL_CreateWindow, [:string, :int, :int, :int, :int, :uint32], Window.auto_ptr
  attach_function :destroy_window, :SDL_DestroyWindow, [Window.by_ref], :void
  attach_function :create_window_from, :SDL_CreateWindowFrom, [:pointer], Window.auto_ptr
  
end
