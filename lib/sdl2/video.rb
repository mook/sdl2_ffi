require 'sdl2/stdinc'
require 'sdl2/rect'
require 'sdl2/window'
require 'sdl2/display'
require 'sdl2/surface'

#require 'sdl2/renderer'
#require 'sdl2/texture'
require 'sdl2/syswm/info'

module SDL2
  typedef :int, :display_index

  enum :window_flags, WINDOW.flatten_consts
  # TODO: SDL_video.h lines 113~129
  enum :window_event_id, WINDOWEVENT.flatten_consts
  
  enum :windowpos, WINDOWPOS.flatten_consts
  
  typedef :pointer, :gl_context

  # OpenGL configuration attributes
  module GLattr
    include EnumerableConstants
    RED_SIZE			                   = next_const_value    
    GREEN_SIZE			                 = next_const_value
    BLUE_SIZE			                   = next_const_value
    ALPHA_SIZE			                 = next_const_value
    BUFFER_SIZE			                 = next_const_value
    DOUBLEBUFFER			               = next_const_value
    DEPTH_SIZE			                 = next_const_value
    STENCIL_SIZE			               = next_const_value  
    ACCUM_RED_SIZE		               = next_const_value
    ACCUM_GREEN_SIZE	               = next_const_value
    ACCUM_BLUE_SIZE		               = next_const_value
    ACCUM_ALPHA_SIZE	               = next_const_value
    STEREO			                     = next_const_value
    MULTISAMPLEBUFFERS               = next_const_value
    MULTISAMPLESAMPLES               = next_const_value                
    ACCELERATED_VISUAL               = next_const_value              
    RETAINED_BACKING	               = next_const_value
    CONTEXT_MAJOR_VERSION	          = next_const_value
    CONTEXT_MINOR_VERSION	    = next_const_value
    CONTEXT_EGL= next_const_value
    CONTEXT_FLAGS= next_const_value
    CONTEXT_PROFILE_MASK			= next_const_value
    SHARE_WITH_CURRENT_CONTEXT= next_const_value
  end
  
  # lines 165~190
  enum :gl_attr, GLattr.flatten_consts
  
  # OpenGL Profile Values
  module GLprofile
    include EnumerableConstants
    CORE = 0x0001
    COMPATIBILITY = 0x0002
    ES = 0x0004
  end
  enum :gl_profile, GLprofile.flatten_consts
  
  # OpenGL Context Values
  module GLcontextFlag
    include EnumerableConstants
    DEBUG = 0x001
    FORWARD_COMPATIBLE = 0x0002
    ROBUST_ACCESS = 0x0004
    RESET_ISOLATION = 0x0008
  end
  # lines 199~205
  enum :gl_context_flag, GLcontextFlag.flatten_consts

  # This interface represents SDL_video.h function prototypes, lines 208~
  
  ##
	#
	api :SDL_GetNumVideoDrivers, [], :int  
  ##
	#
	api :SDL_GetVideoDriver, [:int], :string
  ##
	#
	api :SDL_VideoInit, [:string], :int
  ##
	#
	api :SDL_VideoQuit, [], :void
  ##
	#
	api :SDL_GetCurrentVideoDriver, [], :string
  ##
	#
	api :SDL_GetNumVideoDisplays, [], :int
  ##
	#
	api :SDL_GetDisplayName, [:display_index], :string
  ##
	#
	api :SDL_GetDisplayBounds, [:int, Rect.by_ref], :int
  ##
	#
	api :SDL_GetNumDisplayModes, [:int], :int
  ##
	#
	api :SDL_GetDisplayMode, [:int, :int, Display::Mode.by_ref], :int
  ##
	#
	api :SDL_GetDesktopDisplayMode, [:int, Display::Mode.by_ref], :int
  ##
	#
	api :SDL_GetCurrentDisplayMode, [:int, Display::Mode.by_ref], :int
  ##
	#
	api :SDL_GetClosestDisplayMode,  [:display_index, Display::Mode.by_ref, Display::Mode.by_ref], Display::Mode.by_ref
  ##
	#
	api :SDL_GetWindowDisplayIndex, [Window.by_ref], :int
  ##
	#
	api :SDL_SetWindowDisplayMode, [Window.by_ref, :uint32], :int
  ##
	#
	api :SDL_GetWindowDisplayMode, [Window.by_ref, Display::Mode.by_ref], :int
  ##
	#
	api :SDL_GetWindowPixelFormat, [Window.by_ref], :uint32
  ##
	#
	api :SDL_CreateWindow, [:string, :int, :int, :int, :int, :window_flags], Window.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_CreateWindowFrom, [:pointer], Window.auto_ptr
  ##
	#
	api :SDL_GetWindowFromID, [:uint32], Window.by_ref
  ##
	#
	api :SDL_GetWindowID, [Window.by_ref], :uint32
  ##
	#
	api :SDL_GetWindowFlags, [Window.by_ref], :uint32
  ##
	#
	api :SDL_GetWindowTitle, [Window.by_ref], :string
  ##
	#
	api :SDL_SetWindowTitle, [Window.by_ref, :string], :void
  ##
	#
	api :SDL_SetWindowIcon, [Window.by_ref, Surface.by_ref], :void
  ##
	#
	api :SDL_SetWindowData, [Window.by_ref, :string, :pointer], :pointer
  ##
	#
	api :SDL_GetWindowData, [Window.by_ref, :string], :pointer
  ##
	#
	api :SDL_SetWindowPosition, [Window.by_ref, :int, :int], :void
  ##
	#
	api :SDL_GetWindowPosition, [Window.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :void
  ##
	#
	api :SDL_SetWindowSize, [Window.by_ref, :int, :int], :void
  ##
	#
	api :SDL_GetWindowSize, [Window.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :void
  ##
	#
	api :SDL_SetWindowMaximumSize, [Window.by_ref, :int, :int], :void
  ##
	#
	api :SDL_GetWindowMaximumSize, [Window.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :void
  ##
	#
	api :SDL_SetWindowMinimumSize, [Window.by_ref, :int, :int], :void
  ##
	#
	api :SDL_GetWindowMinimumSize, [Window.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :void
  ##
	#
	api :SDL_SetWindowBordered, [Window.by_ref, :bool], :void
  ##
	#
	api :SDL_ShowWindow, [Window.by_ref], :void
  ##
	#
	api :SDL_HideWindow, [Window.by_ref], :void
  ##
	#
	api :SDL_RaiseWindow, [Window.by_ref], :void
  ##
	#
	api :SDL_MaximizeWindow, [Window.by_ref], :void
  ##
	#
	api :SDL_MinimizeWindow, [Window.by_ref], :void
  ##
	#
	api :SDL_RestoreWindow, [Window.by_ref], :void
  ##
	#
	api :SDL_SetWindowFullscreen, [Window.by_ref, :uint32], :int
  ##
	#
	api :SDL_GetWindowSurface, [Window.by_ref], Surface.by_ref
  ##
	#
	api :SDL_UpdateWindowSurface, [Window.by_ref], :int, {error: true}
  ##
	#
	api :SDL_UpdateWindowSurfaceRects, [Window.by_ref, Rect.by_ref, :int], :int, {error: true}
  ##
	#
	api :SDL_GetWindowGrab, [Window.by_ref], :bool
  ##
	#
	api :SDL_SetWindowGrab, [Window.by_ref, :bool], :void
  ##
	#
	api :SDL_GetWindowBrightness, [Window.by_ref], :float
  ##
	#
	api :SDL_SetWindowBrightness, [Window.by_ref, :float], :int
  ##
	#
	api :SDL_GetWindowGammaRamp, [Window.by_ref, TypedPointer::UInt16.by_ref, TypedPointer::UInt16.by_ref, TypedPointer::UInt16.by_ref], :int
  ##
	#
	api :SDL_SetWindowGammaRamp, [Window.by_ref, TypedPointer::UInt16.by_ref, TypedPointer::UInt16.by_ref, TypedPointer::UInt16.by_ref], :int
  ##
	#
	api :SDL_DestroyWindow, [Window.by_ref], :void
  ##
	#
	api :SDL_IsScreenSaverEnabled, [], :bool
  ##
	#
	api :SDL_DisableScreenSaver, [], :void
  ##
	#
	api :SDL_EnableScreenSaver, [], :void
  ##
	#
	api :SDL_GL_LoadLibrary, [:string], :int
  ##
	#
	api :SDL_GL_GetProcAddress, [:string], :pointer
  ##
	#
	api :SDL_GL_UnloadLibrary, [], :void
  ##
	#
	api :SDL_GL_ExtensionSupported, [:string], :bool
  ##
	#
	api :SDL_GL_SetAttribute, [:gl_attr, TypedPointer::Int], :int
  ##
	#
	api :SDL_GL_GetAttribute, [:gl_attr, TypedPointer::Int.by_ref], :int
  ##
	#
	api :SDL_GL_CreateContext, [Window.by_ref], :gl_context
  ##
	#
	api :SDL_GL_MakeCurrent, [Window.by_ref, :gl_context], :int
  ##
	#
	api :SDL_GL_GetCurrentWindow, [], Window.by_ref
  ##
	#
	api :SDL_GL_GetCurrentContext, [], :gl_context
  ##
	#
	api :SDL_GL_SetSwapInterval, [:int], :int
  ##
	#
	api :SDL_GL_GetSwapInterval, [], :int
  ##
	#
	api :SDL_GL_DeleteContext, [:gl_context], :void
  ##
	#
	api :SDL_GL_SwapWindow, [Window.by_ref], :void
end