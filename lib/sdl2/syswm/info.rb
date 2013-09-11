require 'sdl2'
require 'sdl2/version'

module SDL2
  
  module SysWM
    class Info < Struct
      
      class Win < Struct
        layout :window, :pointer
      end
      
      class X11 < Struct
        layout :display, :pointer,
          :window, :ulong
      end
      
      class DirectFB < Struct
        layout :dfb, :pointer,
          :window, :pointer,
          :surface, :pointer
      end
      
      class Cocoa < Struct
        layout :window, :pointer
      end
      
      class UIKit < Struct
        layout :window, :pointer
      end
      
      class InfoUnion < FFI::Union
        layout :win, Win,
          :x11, X11,
          :dfb, DirectFB,
          :cocoa, Cocoa,
          :uikit, UIKit,
          :dummy, :int
        
      end
      
      layout :version, Version,
        :subsystem, :int,
        :info, InfoUnion
      
    end
  end
    
end