require 'sdl2'
require 'sdl2/rect'
require 'sdl2/window'
require 'sdl2/display'
require 'sdl2/surface'

#require 'sdl2/renderer'
#require 'sdl2/texture'
require 'sdl2/syswm/info'

#
module SDL2
  typedef :int, :display_index
  

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
  # TODO: SDL_video.h lines 113~129

  # line: 134~155
  enum :window_event_id, [
    :none,
    :shown,
    :hidden,
    :exposed,
    :moved,
    :resized,
    :size_changed,
    :minimized,
    :maximized,
    :restored,
    :enter,
    :leave,
    :focus_gained,
    :focus_lost,
    :close
  ]
  # line 160
  typedef :pointer, :gl_context
  # lines 165~190
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
  # lines 192~197
  enum :gl_profile, [:core, 0x0001, :compatibility, 0x0002, :es, 0x0004]
  # lines 199~205
  enum :gl_context_flag, [:debug, 0x0001, :forward_compatible, 0x0002, :robust_access, 0x0004, :reset_isolation, 0x0008]

  # This interface represents SDL_video.h function prototypes, lines 208~
  api :SDL_GetNumVideoDrivers, [], :int
  api :SDL_GetVideoDriver, [:int], :string
  api :SDL_VideoInit, [:string], :int
  api :SDL_VideoQuit, [], :void
  api :SDL_GetCurrentVideoDriver, [], :string
  api :SDL_GetNumVideoDisplays, [], :int
  api :SDL_GetDisplayName, [:display_index], :string
  api :SDL_GetDisplayBounds, [:int, Rect.by_ref], :int
  api :SDL_GetNumDisplayModes, [:int], :int
  api :SDL_GetDisplayMode, [:int, :int, Display::Mode.by_ref], :int
  api :SDL_GetDesktopDisplayMode, [:int, Display::Mode.by_ref], :int
  api :SDL_GetCurrentDisplayMode, [:int, Display::Mode.by_ref], :int
  api :SDL_GetClosestDisplayMode,  [:display_index, Display::Mode.by_ref, Display::Mode.by_ref], Display::Mode.by_ref
  api :SDL_GetWindowDisplayIndex, [Window.by_ref], :int
  api :SDL_SetWindowDisplayMode, [Window.by_ref, :uint32], :int
  api :SDL_GetWindowDisplayMode, [Window.by_ref, Display::Mode.by_ref], :int
  api :SDL_GetWindowPixelFormat, [Window.by_ref], :uint32
  api :SDL_CreateWindow, [:string, :int, :int, :int, :int, :uint32], Window.auto_ptr
  api :SDL_CreateWindowFrom, [:pointer], Window.auto_ptr
  api :SDL_GetWindowFromID, [:uint32], Window.by_ref
  api :SDL_GetWindowID, [Window.by_ref], :uint32
  api :SDL_GetWindowFlags, [Window.by_ref], :uint32
  api :SDL_GetWindowTitle, [Window.by_ref], :string
  api :SDL_SetWindowTitle, [Window.by_ref, :string], :void
  api :SDL_SetWindowIcon, [Window.by_ref, Surface.by_ref], :void
  api :SDL_SetWindowData, [Window.by_ref, :string, :pointer], :pointer
  api :SDL_GetWindowData, [Window.by_ref, :string], :pointer
  api :SDL_SetWindowPosition, [Window.by_ref, :int, :int], :void
  api :SDL_GetWindowPosition, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  api :SDL_SetWindowSize, [Window.by_ref, :int, :int], :void
  api :SDL_GetWindowSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  api :SDL_SetWindowMaximumSize, [Window.by_ref, :int, :int], :void
  api :SDL_GetWindowMaximumSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  api :SDL_SetWindowMinimumSize, [Window.by_ref, :int, :int], :void
  api :SDL_GetWindowMinimumSize, [Window.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  api :SDL_SetWindowBordered, [Window.by_ref, :bool], :void
  api :SDL_ShowWindow, [Window.by_ref], :void
  api :SDL_HideWindow, [Window.by_ref], :void
  api :SDL_RaiseWindow, [Window.by_ref], :void
  api :SDL_MaximizeWindow, [Window.by_ref], :void
  api :SDL_MinimizeWindow, [Window.by_ref], :void
  api :SDL_RestoreWindow, [Window.by_ref], :void
  api :SDL_SetWindowFullscreen, [Window.by_ref, :uint32], :int
  api :SDL_GetWindowSurface, [Window.by_ref], Surface.by_ref
  api :SDL_UpdateWindowSurface, [Window.by_ref], :int
  api :SDL_UpdateWindowSurfaceRects, [Window.by_ref, Rect.by_ref, :int], :int
  api :SDL_GetWindowGrab, [Window.by_ref], :bool
  api :SDL_SetWindowGrab, [Window.by_ref, :bool], :void
  api :SDL_GetWindowBrightness, [Window.by_ref], :float
  api :SDL_SetWindowBrightness, [Window.by_ref, :float], :int
  api :SDL_GetWindowGammaRamp, [Window.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref], :int
  api :SDL_SetWindowGammaRamp, [Window.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref, UInt16Struct.by_ref], :int
  api :SDL_DestroyWindow, [Window.by_ref], :void
  api :SDL_IsScreenSaverEnabled, [], :bool    
  api :SDL_DisableScreenSaver, [], :void
  api :SDL_EnableScreenSaver, [], :void    
  api :SDL_GL_LoadLibrary, [:string], :int
  api :SDL_GL_GetProcAddress, [:string], :pointer
  api :SDL_GL_UnloadLibrary, [], :void
  api :SDL_GL_ExtensionSupported, [:string], :bool
  api :SDL_GL_SetAttribute, [:gl_attr, IntStruct], :int
  api :SDL_GL_GetAttribute, [:gl_attr, IntStruct.by_ref], :int  
  api :SDL_GL_CreateContext, [Window.by_ref], :gl_context  
  api :SDL_GL_MakeCurrent, [Window.by_ref, :gl_context], :int
  api :SDL_GL_GetCurrentWindow, [], Window.by_ref
  api :SDL_GL_GetCurrentContext, [], :gl_context
  api :SDL_GL_SetSwapInterval, [:int], :int
  api :SDL_GL_GetSwapInterval, [], :int
  api :SDL_GL_DeleteContext, [:gl_context], :void
  api :SDL_GL_SwapWindow, [Window.by_ref], :void
end