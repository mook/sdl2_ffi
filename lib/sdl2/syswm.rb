require 'sdl2'
require 'sdl2/version'
require 'sdl2/video'
require 'sdl2/syswm/info'
require 'sdl2/syswm/msg'

module SDL2 # SDL_syswm.h
  
  module SysWM
    
  end
  
  SYSWM = SysWM # Because I don't care about case.
  
  # Line 99~107
  enum :syswm_type, [:unkown, :window, :x11, :directfb, :cocoa, :uikit]
  
  api :SDL_GetWindowWMInfo, [Window.by_ref, SYSWM::Info.by_ref], :bool
  
end