require 'sdl2'

module SDL2
  
  
  
  # Binds texture to GL context returning width and height, but throwing on error
  def gl_bind_texture!(texture)
    w = FloatStruct.new
    h = FloatStruct.new
    throw get_error() unless gl_bind_texture(texture, w, h) == 0
    [w[:value], h[:value]]
  end
  
  
  
  def gl_unbind_texture!(texture)
    throw get_error() unless gl_unbind_texture(texture) == 0
  end
  
  
  
  class GLContext < FFI::Struct
    
    def self.release(pointer)
      gl_delete_context(pointer)
    end
    
    def make_current(window)
      gl_make_current(window, self)
    end
    
    def make_current!(window)
      if make_current(window) != 0
        throw get_error()
      end
    end
    
    
  end
    
  
    
  def gl_extension_supported?(extension)
    gl_extension_supported(extension) == :true
  end
  
  
  
  enum :gl_attr, [
    :red_size,
    :green_size,
    :blue_size,
    :alpha_size,
    :buffer_size,
    :doublebuffer,
    :depth_size,
    :stencil_size,
    :accum_red_size,
    :accum_green_size,
    :accum_blue_size,
    :accum_alpha_size,
    :stereo,
    :multisamplebuffers,
    :multisamplesamples,
    :accelerated_visual,
    :retained_backing,
    :context_major_version,
    :context_minor_version,
    :context_egl,
    :context_flags,
    :context_profile_mask,
    :share_with_current_context    
  ]
      
  
  
  # Gets the attribute value and returns the integer, throws on error
  def gl_get_attribute!(gl_attr)
    int = IntStruct.new
    throw get_error() if gl_get_attribute(gl_attr, int) != 0
    int[:value]
  end
  
  
  # Sets the attribute value from an integer always returning true on success, but throws on error
  def gl_set_attribute!(gl_attr, value)
    int = IntStruct.new
    int[:value] = value.to_i
    throw get_error() if gl_set_attribute(gl_attr, int) != 0
    true
  end
  
  
    
  
  def gl_load_library!(path)
    throw get_error() unless gl_load_library(path) == 0
  end
  
  def gl_set_swap_interval!(interval)
    throw get_error() unless gl_set_swap_interval(interval) == 0
  end
  
  
  
  
  
  
end