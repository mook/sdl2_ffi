require 'sdl2/sdl_module'
require 'active_support/inflector'
require 'enumerable_constants'
require 'sdl2/stdinc'

# libSDL2's prototypes are attached directly to this module.
#
module SDL2
  extend FFI::Library
  extend Library
  ffi_lib SDL_MODULE

  PrintDebug = false

  module StructHelper

    # Define a set of member readers
    # Ex1: `member_readers [:one, :two, :three]`
    # Ex2: `member_readers *members`
    def member_readers(*members_to_define)
      #self.class_eval do
      members_to_define.each do |member|
        define_method member do
          self[member]
        end
      end
      #end
    end

    # Define a set of member writers
    # Ex1: `member_writers [:one, :two, :three]`
    # Ex2: `member_writers *members`
    def member_writers(*members_to_define)
      members_to_define.each do |member|
        define_method "#{member}=".to_sym do |value|
          self[member]= value
        end
      end
    end

  end

  # Augmented for compares with anything that can be an array
  class FFI::Struct::InlineArray

    def ==(other)
      self.to_a == other.to_a
    end
  end

  # FFI::Struct class with some useful additions.
  class Struct < FFI::Struct
    extend StructHelper

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

    def free()
      self.pointer.free
    end

    # A human-readable representation of the struct and it's values.
    #def inspect
    #  return 'nil' if self.null?
    #
    #  #binding.pry
    #  #return self.to_s
    #
    #      report = "struct #{self.class.to_s}{"
    #      report += self.class.members.collect do |field|
    #        "#{field}->#{self[field].inspect}"
    #      end.join(' ')
    #      report += "}"
    #    end

    # Compare two structures by class and values.
    # This will return true if compared to a "partial hash",
    # if all the keys the hash defines equal
    def ==(other)
      if PrintDebug
        @@rec ||= -1
        @@rec += 1
        pad = "\t"*@@rec

        puts
        puts " #{pad}COMPARING #{self} to #{other}"
      end

      result = catch(:result) do
        unless self.class == other.class or other.kind_of? Hash
          puts "Class Mismatch" if PrintDebug
          throw :result, false
        end

        if (other.kind_of? Hash) and (other.keys - members).any?
          puts "Extra Keys: #{other.keys-members}"
          thorw :result, false
        end

        if (other.respond_to?:null?) and (self.null? or other.null?)
          unless self.null? and other.null?
            puts "AHHHAOne is null and the other is not" if PrintDebug
            throw :result, false
          end
        else
          fields = other.kind_of?(Hash) ? members & other.keys : members
          fields.each do |field|
            print "#{pad} #{field}:#{self[field].class} = " if PrintDebug

            unless self[field] == other[field]

              puts "NO MATCH: #{self[field].to_s} #{other[field].to_s}" if PrintDebug
              throw :result, false
            end
            puts "MATCH" if PrintDebug
          end
        end

        true # Everything passed.

      end
      if PrintDebug
        @@rec += -1
        puts
        puts "#{pad}RESULT = #{result}"
      end
      return result
    end

    # Default cast handler
    def self.cast(something)
      if something.kind_of? self
        return something
      elsif something.kind_of? Hash
        tmp = self.new
        tmp.update_members(something)
        return tmp
      elsif something.nil?
        return something #TODO: Assume NUL is ok?
      else
        raise "#{self} can't cast #{something.insepct}"
      end
    end

    # Set members to values contained within hash.
    def update_members(values)
      if values.kind_of? Array
        raise "#{self} has less fields then #{values.inspect}" if values.count > members.count
        members.first(values.count).each_with_index do |field, idx|
          self[field] = values[idx]
        end

      elsif values.kind_of? Hash
        common = (self.members & values.keys)
        raise "#{self} has nothing to update from #{values.inspect}" if common.empty?
        common.each do |field|
          self[field] = values[field]
        end
      else
        raise "#{self}#update_members unable to update from #{values.inspect}"
      end
    end
  end

  # FFI::ManagedStruct possibly with useful additions.
  class ManagedStruct < FFI::ManagedStruct
    extend StructHelper

    # Allows create and use the struct within a block.
    def initialize(*args, &block)
      super(*args)
      if block_given?
        yield self
      end
    end

  end

  class Union < FFI::Union
    extend StructHelper
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

#TODO?: require 'sdl2/loadso'
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