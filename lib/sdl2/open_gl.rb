require 'sdl2'

module SDL2
  # TODO: Should we use this here?
  class FloatStruct < FFI::Struct
    layout :float, :value      
  end
  
  attach_function :gl_bind_texture, :SDL_GL_BindTexture, [Texture.by_ref, FloatStruct.by_ref, FloatStruct.by_ref], :int
  
  # Binds texture to GL context returning width and height, but throwing on error
  def gl_bind_texture!(texture)
    w = FloatStruct.new
    h = FloatStruct.new
    throw get_error() unless gl_bind_texture(texture, w, h) == 0
    [w[:value], h[:value]]
  end
  
  attach_function :gl_unbind_texture, :SDL_GL_UnbindTexture, [Texture.by_ref], :int
  
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
    
  attach_function :gl_create_context, :SDL_GL_CreateContext, [Window.by_ref], GLContext.auto_ptr
  attach_function :gl_delete_context, :SDL_GL_DeleteContext, [GLContext], :void
  
  attach_function :gl_make_current, :SDL_GL_MakeCurrent, [Window.by_ref, GLContext], :int
  attach_function :gl_extension_supported, :SDL_GL_ExtensionSupported, [:string], :bool
    
  def gl_extension_supported?(extension)
    gl_extension_supported(extension) == :true
  end
  
  class IntStruct < FFI::Struct
    layout :int, :value
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
      
  
  attach_function :gl_get_attribute, :SDL_GL_GetAttribute, [:gl_attr, IntStruct.by_ref]
  # Gets the attribute value and returns the integer, throws on error
  def gl_get_attribute!(gl_attr)
    int = IntStruct.new
    throw get_error() if gl_get_attribute(gl_attr, int) != 0
    int[:value]
  end
  
  attach_function :gl_set_attribute, :SDL_GL_SetAttribute, [:gl_attr, IntStruct], :int
  # Sets the attribute value from an integer always returning true on success, but throws on error
  def gl_set_attribute!(gl_attr, value)
    int = IntStruct.new
    int[:value] = value.to_i
    throw get_error() if gl_set_attribute(gl_attr, int) != 0
    true
  end
  
  attach_function :gl_get_proc_address, :SDL_GL_GetProcAddress, [:string], :pointer
    
  attach_function :gl_load_library, :SDL_GL_LoadLibrary, [:string], :int
  def gl_load_library!(path)
    throw get_error() unless gl_load_library(path) == 0
  end
  
  attach_function :gl_unload_library, :SDL_GL_UnloadLibrary, [], :void
  
  attach_function :gl_get_swap_interval, :SDL_GL_GetSwapInterval, [], :int
  attach_function :gl_set_swap_interval, :SDL_GL_SetSwapInterval, [:int], :int
  def gl_set_swap_interval!(interval)
    throw get_error() unless gl_set_swap_interval(interval) == 0
  end
  
  attach_function :gl_swap_window, :SDL_GL_SwapWindow, [Window.by_ref], :void
  
  
  
  
end