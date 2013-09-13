require 'ffi'
require 'sdl2/sdl_module'
require 'active_support/inflector'

# libSDL2's interface
module SDL2
  extend FFI::Library
  ffi_lib SDL_MODULE

  TRUE_WHEN_ZERO = Proc.new do |result|
    result == 0
  end

  TRUE_WHEN_NOT_NULL = Proc.new do |result|
    (!result.null?)
  end

  # This converts the SDL Function Prototype name "SDL_XxxYyyyyZzz" to ruby's
  # "xxx_yyyy_zzz" convetion
  def self.api(func_name, args, type, options = {})

    options = {
      :error => false,
      :filter => TRUE_WHEN_ZERO
    }.merge(options)

    camelCaseName = func_name.to_s.gsub('SDL_','')
    methodName = ActiveSupport::Inflector.underscore(camelCaseName).to_sym

    self.attach_function methodName, func_name, args, type

    if options[:error]
      returns_error(methodName, options[:filter])
    end

    if type == :bool
      boolean?(methodName)
    end

    return methodName
  end

  def self.metaclass

    class << self; self; end
  end

  # This constructs an alternative function with the same name but with an ! at
  # the end.
  # This version will throw an error if the return code != 0
  def self.returns_error(methodName, filter)
    metaclass.instance_eval do
      define_method "#{methodName}!".to_sym do |*args|
        result = self.send(methodName, *args)
        raise_error_unless filter.call(result)
        result
      end
    end
  end

  def self.boolean?(methodName)
    metaclass.instance_eval do
      define_method("#{methodName}?".to_sym) do |*args|
        self.send(methodName, *args) == :true
      end
    end
  end

  class Struct < FFI::Struct

    def initialize(*args, &block)
      super(*args)
      if block_given?
        throw 'Release must be defined to use block' unless self.class.respond_to?(:release)
        yield self
        self.class.release(self.pointer)
      end
    end

    def self.release(pointer)
      pointer.free
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

  # SDL_Bool
  enum :bool, [:false, 0, :true, 1]
    
  def self.raise_error
    raise "SDL Error: #{SDL2.get_error()}"
  end

  def self.raise_error_unless(condition)
    raise_error unless condition
  end

  def self.raise_error_if(condition)
    raise_error if condition
  end

  # Simple Type Structures to interface 'typed-pointers'
  # TODO: Research if this is the best way to handle 'typed-pointers'
  class FloatStruct < ManagedStruct
    layout :value, :float
  end

  class IntStruct < Struct
    layout :value, :int
  end

  class UInt16Struct < Struct
    layout :value, :uint16
  end

  class UInt32Struct < Struct
    layout :value, :uint32
  end

  class UInt8Struct < Struct
    layout :value, :uint8
  end

  # TODO: Review if this is the best place to put it.
  # BlendMode is defined in a header file that is always included, so I'm
  # defineing again here.
  enum :blend_mode, [
    :none, 0x00000000,
    :blend, 0x00000001,
    :add, 0x00000002,
    :mod, 0x00000004
  ]

  class BlendModeStruct < Struct
    layout :value, :blend_mode
  end

  typedef :uint32, :pixel_format

  # Simple typedef to represent array sizes.
  typedef :int, :count

end
