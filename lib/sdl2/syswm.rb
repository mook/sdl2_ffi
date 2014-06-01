require 'sdl2'
require 'sdl2/version'
require 'sdl2/video'
require 'sdl2/syswm/info'
require 'sdl2/syswm/msg'

##
# SDL_syswm.h - "Include file for SDL custom system window manager hooks."
#
#   Your application has access to a special type of event ::SDL_SYSWMEVENT,
#   which contains window-manager specific information and arrives whenever
#   an unhandled window event occurs.  This event is ignored by default, but
#   you can enable it with SDL_EventState().
module SDL2
  module SysWM
    module TYPE
      extend EnumerableConstants
      UNKOWN
      WINDOWS
      X11
      DIRECTFB
      COCOA
      UIKIT
      WAYLAND
      WINRT
    end
  end

  SYSWM = SysWM # Because I don't care about case.

  # Line 99~107
  enum :syswm_type, SysWM::TYPE.flatten_constants

  ##
  #
  api :SDL_GetWindowWMInfo, [Window.by_ref, SYSWM::Info.by_ref], :bool

end