require 'sdl2'

module SDL2 # SDL_syswm.h
          
  module SysWM
    class Msg < Struct
      
      class Win < Struct
        layout :hwnd, :pointer,
          :msg, :uint,
          :wparam, :int16,
          :lparam, :int32
      end      
      
      
      class X11 < Struct
        layout :dummy, :uint32 # TODO: FIXME: NOT YET SUPPORTED!
      end
      
      class DirectFB < Struct
        layout :event, :uint32 # TODO: FIXME: NOT YET SUPPORTED!
      end
      
      class Cocoa < Struct
        layout :dummy, :long # SDL2 says 'No Cocoa window events yet'
      end
      
      class UIKit < Struct
        layout :dummy, :long # SDL2 says 'No UIKit window events yet'
      end
      
      class MsgUnion < FFI::Union
        layout :win, Win,
          :x11, X11,
          :dfb, DirectFB,
          :cocoa, Cocoa,
          :uikit, UIKit,
          :dummy, :int
      end
      
      layout :version, Version,
        :subsystem, :int,
        :msg, MsgUnion
    end
  end 
end