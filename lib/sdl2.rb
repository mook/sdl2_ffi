require 'sdl2/sdl_module'
require 'active_support/inflector'
require 'enumerable_constants'
require 'sdl2/stdinc'
require 'sdl2/debug'
# The SDL2 Map of API Prototypes
module SDL2
  extend FFI::Library
  extend Library
  ffi_lib SDL_MODULE
  
  ##
  # StructHelper defines a couple of handy macros, useful in structures and unions.
  autoload(:StructHelper, 'sdl2/struct_helper')  

  ##
  # FFI::Struct::InlineArray is modified to allow == operations, may not be effecient but seems to work.
  class FFI::Struct::InlineArray
    def ==(other)
      self.to_a == other.to_a
    end
  end
  
  ##
  # Struct is locally defined, inheriting from FFI::Struct
  # The original FFI::Struct is unmodified
  autoload(:Struct, 'sdl2/struct')  
  ##
  # StructArray is a helper for Pointer of Structs.
  autoload(:StructArray, File.expand_path('../struct_array.rb', __FILE__))
  ##
  # TOOD: ManagedStruct is currently unused, and may not be.
  # I have run into trouble using FFI::Struct.auto_ptr
  autoload(:ManagedStruct, 'sdl2/managed_struct')
  autoload(:Union, 'sdl2/union')
  autoload(:TypedPointer, 'sdl2/typed_pointer')
  
  autoload(:BLENDMODE, 'sdl2/blendmode')
  

  autoload(:TTF, 'sdl2/ttf')
  autoload(:Image, 'sdl2/image')
  autoload(:Mixer, 'sdl2/mixer')
  # Simple typedef to represent array sizes.
  typedef :int, :count

end

require 'sdl2/blendmode'
require 'sdl2/init'

#TODO: require 'sdl2/assert'
#TODO: require 'sdl2/atomic'
require 'sdl2/audio'
require 'sdl2/clipboard'
require 'sdl2/cpuinfo'

#TODO: require 'sdl2/endian'
require 'sdl2/error'
require 'sdl2/events'
require 'sdl2/joystick'
require 'sdl2/gamecontroller'
require 'sdl2/haptic'
require 'sdl2/hints'
require 'sdl2/log'

#TODO: require 'sdl2/messagebox'
#TODO: require 'sdl2/mutex'
require 'sdl2/power'
require 'sdl2/render'
require 'sdl2/rwops'

#TODO: require 'sdl2/system'
#TODO: require 'sdl2/thread'
require 'sdl2/timer'
require 'sdl2/version'
require 'sdl2/video'