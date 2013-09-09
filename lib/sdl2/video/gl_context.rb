require 'sdl2'

module SDL2  
  class GLContext < FFI::Struct
    layout :nothing, :uint8 # FIXME: This struct is just a pointer.
    
    def self.release(pointer)
      delete_context(pointer)
    end
    
    
  end
end