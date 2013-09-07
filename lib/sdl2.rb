require 'ffi'
require 'sdl2/init'
module SDL2
  extend FFI::Library

  # TODO: Review default/hard-coded load paths?
  ffi_lib ['libSDL2','/usr/local/lib/libSDL2.so']

  # SDL_Bool
  enum :bool, [:false, 0, :true, 1]

  def throw_error_unless(condition)
    throw get_error() unless condition
  end
  
  # Simple Type Structures to interface 'typed-pointers'
  # TODO: Research if this is the best way to handle 'typed-pointers'
  class FloatStruct < FFI::Struct
    layout :float, :value      
  end
  
  class IntStruct < FFI::Struct
    layout :int, :value
  end
  
  class UInt16Struct < FFI::Struct
    layout :uint16, :value
  end
end
