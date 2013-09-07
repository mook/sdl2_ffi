require 'sdl2'

module SDL2
  
  class DisplayMode < FFI::Struct
    layout :format, :uint32,
      :w, :int,
      :h, :int,
      :refresh_rate, :int,
      :driverdata, :pointer
      
    def self.current(display_index)
      dm = DisplayMode.new      
      get_current_display_mode(display_index, dm)
      return dm
    end
    
    def self.current!(display_index)
      get_current_display_mode!(display_index)
    end
  end
  
  attach_function :get_display_mode, :SDL_GetDisplayMode, [:int, :int, DisplayMode.by_ref], :int
  def get_display_mode!(display_idx, mode_idx)
    dm = DisplayMode.new
    throw_error_unless get_display_mode(display_idx, mode_idx, dm) == 0
    return dm
  end   
    
  attach_function :get_current_display_mode, :SDL_GetCurrentDisplayMode, [:int, DisplayMode.by_ref], :int
  def get_current_display_mode!(display_index)
    dm = DisplayMode.new
    throw_error_unless get_current_display_mode(display_index, dm) == 0
    return dm
  end
  
  attach_function :get_desktop_display_mode, :SDL_GetDesktopDisplayMode, [:int, DisplayMode.by_ref], :int
  def get_desktop_display_mode!(display_index)
    dm = DisplayMode.new
    throw_error_unless get_desktop_display_mode(display_index, dm) == 0
    return dm
  end
  
  attach_function :get_display_bounds, :SDL_GetDisplayBounds, [:int, Rect.by_ref], :int
  def get_display_bounds!(display_index)
    db = Rect.new
    throw_error_unless get_display_bounds(display_index, db) == 0
    return db
  end
  
  attach_function :get_num_display_modes, :SDL_GetNumDisplayModes, [:int], :int
  
  
    
  
end