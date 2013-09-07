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
    
    def self.from_id(id)
      get_window_from_id(id)
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
    
    def brightness
      get_window_brightness(self)
    end
    
    def brightness=(level)
      set_window_brightness(self, level.to_f)
    end
    
    def data(named)
      get_window_data(self, named)
    end
    
    def data=(named, value)
      set_window_data(self, named, value)
    end
    
    def display_index
      get_window_display_index(self)
    end            
    
    def flags
      get_window_flags(self)
    end 
    
    def grab?
      get_window_grab(self) == :true
    end
    
    def grab=(value)
      unless value == :true or value == :false
        value = value ? :true : :false
      end
      set_window_grab(self, value)
    end
    
    def id
      get_window_id(self)
    end
    
    def maximum_size
      get_window_maximum_size!(self)
    end
    
    def minimum_size
      get_window_minimum_size!(self)
    end
    
    def pixel_format
      get_window_pixel_format(self)
    end
    
    def title
      get_window_title(self)
    end
    
    def hide
      hide_window(self)
    end
    
    def maximize
      maximize_window(self)
    end
    
    def minimize
      minimize_window(self)
    end
    
    def raise_above
      raise_window(self)
    end
    
    def restore
      restore_window(self)
    end
    
    def icon=(surface)
      set_window_icon(self, surface)
    end
    
    def update_surface()
      update_window_surface(self)
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
  
  attach_function :get_window_brightness, :SDL_GetWindowBrightness, [Window.by_ref], :float
  attach_funciton :set_window_brightness, :SDL_SetWindowBrightness, [Window.by_ref, :float], :int
  
  attach_function :get_window_data, :SDL_GetWindowData, [Window.by_ref, :string], :pointer
  attach_function :set_window_data, :SDL_SetWindowData, [Window.by_ref, :string, :pointer], :pointer
  
  attach_function :get_window_display_index, :SDL_GetWindowDisplayIndex, [Window.by_ref], :int
  
  attach_function :get_window_display_mode, :SDL_GetWindowDisplayMode, [Window.by_ref, DisplayMode.by_ref], :int
  attach_function :set_window_display_mode, :SDL_SetWindowDisplayMode, [Window.by_ref, DisplayMode.by_ref], :int
  
  attach_function :get_window_flags, :SDL_GetWindowFlags, [Window.by_ref], :uint32
  
  attach_function :get_window_from_id, :SDL_GetWindowFromID, [:uint32], Window.by_ref
  
  # FIXME: 'window_gamma_ramp' I don't think this is right, test it.  Should be an array of UInt16, 256 long  
  attach_function :get_window_gamma_ramp, :SDL_GetWindowGammaRamp, [Window.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref], :int
  attach_function :set_window_gamma_ramp, :SDL_SetWindowGammaRamp, [Window.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref], :int
  
  attach_function :get_window_grab, :SDL_GetWindowGrab, [Window.by_ref], :bool
  attach_function :set_window_grab, :SDL_SetWindowGrab, [Window.by_ref, :bool], :void
  
  attach_function :get_window_id, :SDL_GetWindowID, [Window.by_ref], :uint32
  
  attach_function :get_window_maximum_size, :SDL_GetWindowMaximumSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  # Returns Window Maximum size as [w,h]
  def get_window_maximum_size!(window)
    w = IntStruct.new
    h = IntStruct.new
    get_window_maximum_size(window, w, h)
    result = [w[:value],h[:value]]
    w.release
    h.release
    return result
  end
  
  attach_function :set_window_maximum_size, :SDL_SetWindowMaximumSize, [Window.by_ref, :int, :int], :void 
  
  attach_function :get_window_minimum_size, :SDL_GetWindowMinimumSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  # Returns Window Minimum size as [w,h]
  def get_window_minimum_size!(window)
    w = IntStruct.new
    h = IntStruct.new
    get_window_minimum_size(window, w, h)
    result = [w[:value],h[:value]]
    w.release
    h.release
    return result
  end
  
  attach_function :set_window_minimum_size, :SDL_SetWindowMinimumSize, [Window.by_ref, :int, :int], :void
  
  
  attach_function :get_window_pixel_format, :SDL_GetWindowPixelFormat, [Window.by_ref], :uint32
  
  attach_function :get_window_position, :SDL_GetWindowPosition, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  attach_function :set_window_position, :SDL_SetWindowPosition, [Window.by_ref, :int, :int], :void
  
  attach_function :get_window_size, :SDL_GetWindowSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  attach_function :set_window_size, :SDL_SetWindowSize, [Window.by_ref, :int, :int], :void
  
  attach_function :get_window_surface, :SDL_GetWindowSurface, [Window.by_ref], Surface.by_ref
  
  attach_function :get_window_title, :SDL_GetWindowTitle, [Window.by_ref], :string
  attach_function :set_window_title, :SDL_SetWindowTitle, [Window.by_ref, :string], :void
  
  attach_function :get_window_wm_info, :SDL_GetWindowWMInfo, [Window.by_ref, SysWMInfo.by_ref], :void
  
  attach_function :hide_window, :SDL_HideWindow, [Window.by_ref], :void
  attach_function :maximize_window, :SDL_MaximizeWindow, [Window.by_ref], :void
  attach_function :minimize_window, :SDL_MinimizeWindow, [Window.by_ref], :void
  attach_function :raise_window, :SDL_RaiseWindow, [Window.by_ref], :void
  attach_function :restore_window, :SDL_RestoreWindow, [Window.by_ref], :void
  attach_function :show_window, :SDL_ShowWindow, [Window.by_ref], :void
  
  
  attach_function :set_window_display_mode, :SDL_SetWindowDisplayMode, [Window.by_ref, :uint32], :int
  attach_function :set_window_icon, :SDL_SetWindowIcon, [Window.by_ref, Surface.by_ref], :void
  
  attach_function :update_window_surface, :SDL_UpdateWindowSurface, [Window.by_ref], :int
  attach_function :update_window_surface_rects, :SDL_UpdateWindowSurfaceRects, [Window.by_ref, Rect.by_ref, :int], :int
end
