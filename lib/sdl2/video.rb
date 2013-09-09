require 'sdl2'
require 'sdl2/rect'
require 'sdl2/video/window'
require 'sdl2/video/renderer'
require 'sdl2/video/texture'
require 'sdl2/video/gl_context'
require 'sdl2/video/glattr'
require 'sdl2/video/display_mode'
require 'sdl2/surface'
require 'sdl2/sys_wm_info'
# 
module SDL2
  typedef :int, :display_index
  # This interface represents SDL_video.h
  #
  #
  #
  #
  #
  attach_function :create_window,                 :SDL_CreateWindow, [:string, :int, :int, :int, :int, :uint32], Window.auto_ptr
  attach_function :create_window_and_renderer,    :SDL_CreateWindowAndRenderer, [:int, :int, :renderer_flags, Window.auto_ptr, Renderer.auto_ptr], :int
  attach_function :create_window_from,            :SDL_CreateWindowFrom, [:pointer], Window.auto_ptr
  attach_function :destroy_window, :SDL_DestroyWindow, [Window.by_ref], :void
  attach_function :disable_screen_saver, :SDL_DisableScreenSaver, [], :void
  attach_function :enable_screen_saver, :SDL_EnableScreenSaver, [], :void
  attach_function :gl_bind_texture,   :SDL_GL_BindTexture, [Texture.by_ref, FloatStruct.by_ref, FloatStruct.by_ref], :int
  attach_function :gl_create_context, :SDL_GL_CreateContext, [Window.by_ref], GLContext.auto_ptr
  attach_function :gl_delete_context, :SDL_GL_DeleteContext, [GLContext], :void
  attach_function :gl_extension_supported, :SDL_GL_ExtensionSupported, [:string], :bool
  attach_function :gl_get_attribute, :SDL_GL_GetAttribute, [:glattr, IntStruct.by_ref], :int 
  attach_function :gl_get_proc_address, :SDL_GL_GetProcAddress, [:string], :pointer
  attach_function :gl_get_swap_interval, :SDL_GL_GetSwapInterval, [], :int
  attach_function :gl_load_library, :SDL_GL_LoadLibrary, [:string], :int
  attach_function :gl_make_current, :SDL_GL_MakeCurrent, [Window.by_ref, GLContext], :int
  attach_function :gl_set_attribute, :SDL_GL_SetAttribute, [:glattr, IntStruct], :int
  attach_function :gl_set_swap_interval, :SDL_GL_SetSwapInterval, [:int], :int
  attach_function :gl_swap_window, :SDL_GL_SwapWindow, [Window.by_ref], :void
  attach_function :gl_unbind_texture, :SDL_GL_UnbindTexture, [Texture.by_ref], :int
  attach_function :gl_unload_library, :SDL_GL_UnloadLibrary, [], :void
  attach_function :get_closest_display_mode, :SDL_GetClosestDisplayMode,  [:display_index, DisplayMode.by_ref, DisplayMode.by_ref], DisplayMode.by_ref
  attach_function :get_current_display_mode, :SDL_GetCurrentDisplayMode, [:int, DisplayMode.by_ref], :int
  attach_function :get_current_video_driver, :SDL_GetCurrentVideoDriver, [], :string
  attach_function :get_desktop_display_mode, :SDL_GetDesktopDisplayMode, [:int, DisplayMode.by_ref], :int
  attach_function :get_display_bounds, :SDL_GetDisplayBounds, [:int, Rect.by_ref], :int
  attach_function :get_display_mode, :SDL_GetDisplayMode, [:int, :int, DisplayMode.by_ref], :int
  attach_function :get_num_display_modes, :SDL_GetNumDisplayModes, [:int], :int
  attach_function :get_num_video_displays, :SDL_GetNumVideoDisplays, [], :int
  attach_function :get_num_video_drivers, :SDL_GetNumVideoDrivers, [], :int
  attach_function :get_video_driver, :SDL_GetVideoDriver, [:int], :string
  attach_function :get_window_brightness, :SDL_GetWindowBrightness, [Window.by_ref], :float
  attach_function :get_window_data, :SDL_GetWindowData, [Window.by_ref, :string], :pointer
  attach_function :get_window_display_index, :SDL_GetWindowDisplayIndex, [Window.by_ref], :int
  attach_function :get_window_display_mode, :SDL_GetWindowDisplayMode, [Window.by_ref, DisplayMode.by_ref], :int
  attach_function :get_window_flags, :SDL_GetWindowFlags, [Window.by_ref], :uint32
  attach_function :get_window_from_id, :SDL_GetWindowFromID, [:uint32], Window.by_ref
  attach_function :get_window_gamma_ramp, :SDL_GetWindowGammaRamp, [Window.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref], :int
  attach_function :get_window_grab, :SDL_GetWindowGrab, [Window.by_ref], :bool
  attach_function :get_window_id, :SDL_GetWindowID, [Window.by_ref], :uint32
  attach_function :get_window_maximum_size, :SDL_GetWindowMaximumSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  attach_function :get_window_minimum_size, :SDL_GetWindowMinimumSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  attach_function :get_window_pixel_format, :SDL_GetWindowPixelFormat, [Window.by_ref], :uint32
  attach_function :get_window_position, :SDL_GetWindowPosition, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  attach_function :get_window_size, :SDL_GetWindowSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  attach_function :get_window_surface, :SDL_GetWindowSurface, [Window.by_ref], Surface.by_ref
  attach_function :get_window_title, :SDL_GetWindowTitle, [Window.by_ref], :string
  attach_function :get_window_wm_info, :SDL_GetWindowWMInfo, [Window.by_ref, SysWMInfo.by_ref], :void
  attach_function :hide_window, :SDL_HideWindow, [Window.by_ref], :void
  attach_function :is_screen_saver_enabled, :SDL_IsScreenSaverEnabled, [], :bool
  attach_function :maximize_window, :SDL_MaximizeWindow, [Window.by_ref], :void
  attach_function :minimize_window, :SDL_MinimizeWindow, [Window.by_ref], :void
  attach_function :raise_window, :SDL_RaiseWindow, [Window.by_ref], :void
  attach_function :restore_window, :SDL_RestoreWindow, [Window.by_ref], :void
  attach_function :set_window_brightness, :SDL_SetWindowBrightness, [Window.by_ref, :float], :int
  attach_function :set_window_data, :SDL_SetWindowData, [Window.by_ref, :string, :pointer], :pointer
  attach_function :set_window_display_mode, :SDL_SetWindowDisplayMode, [Window.by_ref, :uint32], :int
  attach_function :set_window_fullscreen, :SDL_SetWindowFullscreen, [Window.by_ref, :uint32], :int
  attach_function :set_window_gamma_ramp, :SDL_SetWindowGammaRamp, [Window.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref], :int
  attach_function :set_window_grab, :SDL_SetWindowGrab, [Window.by_ref, :bool], :void
  attach_function :set_window_icon, :SDL_SetWindowIcon, [Window.by_ref, Surface.by_ref], :void
  attach_function :set_window_maximum_size, :SDL_SetWindowMaximumSize, [Window.by_ref, :int, :int], :void
  attach_function :set_window_minimum_size, :SDL_SetWindowMinimumSize, [Window.by_ref, :int, :int], :void
  attach_function :set_window_position, :SDL_SetWindowPosition, [Window.by_ref, :int, :int], :void
  attach_function :set_window_size, :SDL_SetWindowSize, [Window.by_ref, :int, :int], :void
  attach_function :set_window_title, :SDL_SetWindowTitle, [Window.by_ref, :string], :void
  attach_function :show_window, :SDL_ShowWindow, [Window.by_ref], :void
  attach_function :update_window_surface, :SDL_UpdateWindowSurface, [Window.by_ref], :int
  attach_function :update_window_surface_rects, :SDL_UpdateWindowSurfaceRects, [Window.by_ref, Rect.by_ref, :int], :int
  attach_function :video_init, :SDL_VideoInit, [:string], :int
  attach_function :video_quit, :SDL_VideoQuit, [], :void

  # FIXME: 'window_gamma_ramp' I don't think this is right, test it.  Should be
  # an array of UInt16, 256 long

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

end