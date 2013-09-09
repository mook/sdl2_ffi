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
  
#  
#  def get_display_mode!(display_idx, mode_idx)
#    dm = DisplayMode.new
#    throw_error_unless get_display_mode(display_idx, mode_idx, dm) == 0
#    return dm
#  end   
#    
#  
#  def get_current_display_mode!(display_index)
#    dm = DisplayMode.new
#    throw_error_unless get_current_display_mode(display_index, dm) == 0
#    return dm
#  end
#  
#  
#  def get_desktop_display_mode!(display_index)
#    dm = DisplayMode.new
#    throw_error_unless get_desktop_display_mode(display_index, dm) == 0
#    return dm
#  end
#  
#  
#  def get_display_bounds!(display_index)
#    db = Rect.new
#    throw_error_unless get_display_bounds(display_index, db) == 0
#    return db
#  end
#   
end