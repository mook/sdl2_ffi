require 'ffi'
require 'sdl2/sdl_module'
require 'active_support/inflector'

require 'enumerable_constants'

# libSDL2's prototypes are attached directly to this module.
# 
module SDL2
  extend FFI::Library
  ffi_lib SDL_MODULE
 
  

  [:int, :uint8, :int8, :uint16, :int16, :uint32, :int32, :uint64, :int64, :float, :double].each do |type|
    typedef :pointer, "p_#{type}".to_sym
  end

  #Filter Proc, True when arg equals zero
  TRUE_WHEN_ZERO = Proc.new do |result|
    result == 0
  end

  # Filter Proc, True when arg not null?
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

  # Returns the 'singleton class' so we can define class-level methods on the
  # fly.
  # There may be a better place to put this.
  def self.metaclass

    class << self; self; end
  end

  # Generates an alternative version of methodName that will raise a SDL Error
  # when the return value fails the filter test.  The alternative version has
  # the same name, but with an exclamation mark ("!") at the end, indicating the
  # danger.
  def self.returns_error(methodName, filter)
    metaclass.instance_eval do
      define_method "#{methodName}!".to_sym do |*args|
        result = self.send(methodName, *args)
        raise_error_unless filter.call(result)
        result
      end
    end
  end

  # Generates an alternative version of methodName that will return Ruby's `true`
  # if the method named returns SDL_true/:true enum value.  The alternative
  # method has the same name with a question mark ("?") appended, to indicate its
  # boolean nature.
  def self.boolean?(methodName)
    metaclass.instance_eval do
      define_method("#{methodName}?".to_sym) do |*args|
        self.send(methodName, *args) == :true
      end
    end
  end

  # Define a four character code as a Uint32
  #MACRO: SDL_FOURCC(A, B, C, D) \
  #    ((SDL_static_cast(Uint32, SDL_static_cast(Uint8, (A))) << 0) | \
  #     (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (B))) << 8) | \
  #     (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (C))) << 16) | \
  #     (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (D))) << 24))
  def self.fourcc(*args)
    bit_cnt = 0
    result = 0
    args.each do |arg|
      arg = arg.codepoints[0] if arg.kind_of? String
      result = result | (arg << bit_cnt)
      bit_cnt += 8
    end
    return result
  end

  # FFI::Struct class with some useful additions.
  class Struct < FFI::Struct

    # Allows creation and use within block, automatically freeing pointer after block.
    def initialize(*args, &block)
      super(*args)
      if block_given?
        throw 'Release must be defined to use block' unless self.class.respond_to?(:release)
        yield self
        self.class.release(self.pointer)
      end
    end

    # A default release scheme is defined, but should be redefined where appropriate.
    def self.release(pointer)
      pointer.free
    end

    # A human-readable representation of the struct and it's values.
    def inspect
      return 'nul' if pointer.null?
      binding.pry
      #binding.pry
      #return self.to_s      
      
      report = "struct #{self.class.to_s}{"
      report += self.class.members.collect do |field|
        "#{field}->#{self[field].inspect}"
      end.join(' ')
      report += "}"
    end

    # Compare two structures by class and values.
    def ==(other)
      return false unless self.class == other.class
      self.class.members.each do |field|
        return false unless self[field] == other[field]
      end
      true # return true if we get this far.
    end
  end

  # FFI::ManagedStruct possibly with useful additions.
  class ManagedStruct < FFI::ManagedStruct

    # Allows create and use the struct within a block.
    def initialize(*args, &block)
      super(*args)
      if block_given?
        yield self
      end
    end

  end

  # SDL_Bool: SDL's TRUE/FALSE enumeration.
  # Ruby does not automatically evaluate 0 as false.
  enum :bool, [:false, 0, :true, 1]

  # Raise the current error value as a RuntimeException
  def self.raise_error
    raise "SDL Error: #{SDL2.get_error()}"
  end

  # Conditionally raise an error, unless true
  def self.raise_error_unless(condition)
    raise_error unless condition
  end

  # Conditionally raise an error, unless false
  def self.raise_error_if(condition)
    raise_error if condition
  end
  
  class TypedPointer < Struct
    def self.type(kind)
      layout :value, kind
    end
    
    def value
      self[value]
    end
    
    alias_method :deref, :value
  end

  # Simple Type Structures to interface 'typed-pointers'
  # TODO: Research if this is the best way to handle 'typed-pointers'
  class FloatPointer < TypedPointer
    type :float
  end

  # Int-typed pointer
  class IntStruct < TypedPointer
    type :int
  end

  # 
  class UInt16Struct < TypedPointer
    type :uint16
  end

  class UInt32Struct < TypedPointer 
    type :uint32
  end

  class UInt8Struct < TypedPointer
    type :uint8
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
