require 'ffi'
require 'sdl2/sdl_module'

module SDL2
  extend FFI::Library
  
  class Struct < FFI::Struct
    def initialize(*args, &block)
      super(*args)
      if block_given?
        throw 'Release must be defined to use block' unless self.class.respond_to?(:release)
        yield self
        self.class.release(self.pointer)
      end
    end
  end
  
  class ManagedStruct < FFI::ManagedStruct
    def initialize(*args, &block)
      super(*args)
      if block_given?
        throw 'Release must be defined to use block' unless self.class.respond_to?(:release)
        yield self
        self.class.release(self.pointer)
      end
    end
  end
    

  # TODO: Review default/hard-coded load paths?
  ffi_lib SDL_MODULE

  # SDL_Bool
  enum :bool, [:false, 0, :true, 1]

  def self.throw_error_unless(condition)
    throw get_error() unless condition
  end
  
  def self.throw_error_if(condition)
    throw get_error() if condition
  end
  
  # Simple Type Structures to interface 'typed-pointers'
  # TODO: Research if this is the best way to handle 'typed-pointers'
  class FloatStruct < FFI::Struct
    layout :value, :float       
  end
  
  class IntStruct < FFI::Struct
    layout :value, :int
  end
  
  class UInt16Struct < FFI::Struct
    layout :value, :uint16
  end
  
  class UInt32Struct < FFI::Struct
    layout :value, :uint32
  end
  
  class UInt8Struct < FFI::Struct
    layout :value, :uint8
  end
  
  # TODO: Review if this is the best place to put it. 
  # BlendMode is defined in a header file that is always included, so I'm defineing again here.
  enum :blend_mode, [
      :none, 0x00000000,     
      :blend, 0x00000001,    
      :add, 0x00000002,      
      :mod, 0x00000004 
    ]
  class BlendModeStruct < FFI::Struct
    layout :value, :blend_mode
  end
  
  # Simple typedef to represent array sizes.
  typedef :int, :count
  
end
