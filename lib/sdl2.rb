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
  
  autoload(:StructHelper, 'sdl2/struct_helper')  

  ##
  # BadQuanta: I Augmented for compares with anything that can be an array
  class FFI::Struct::InlineArray
    def ==(other)
      self.to_a == other.to_a
    end
  end
  
  autoload(:Struct, 'sdl2/struct')  
  autoload(:StructArray, File.expand_path('../struct_array.rb', __FILE__))
  autoload(:ManagedStruct, 'sdl2/managed_struct')
  autoload(:Union, 'sdl2/union')
  autoload(:TypedPointer, 'sdl2/typed_pointer')
  
  module BLENDMODE
    include EnumerableConstants
    NONE = 0x00000000
    BLEND = 0x00000001
    ADD = 0x00000002
    MOD = 0x00000004
  end
  # TODO: Review if this is the best place to put it.
  # BlendMode is defined in a header file that is always included, so I'm
  # defineing again here.
  enum :blend_mode, BLENDMODE.flatten_consts

  class BlendModeStruct < SDL2::TypedPointer
    layout :value, :blend_mode
  end

  

  # Simple typedef to represent array sizes.
  typedef :int, :count

end

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