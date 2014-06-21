module SDL2
  ##
  # BadQuanta says: "Typed pointes let you get to the value."
  class TypedPointer < Struct
    def self.type(kind)
      layout :value, kind
    end

    def value
      self[:value]
    end

    alias_method :deref, :value

    # Simple Type Structures to interface 'typed-pointers'
    # TODO: Research if this is the best way to handle 'typed-pointers'
    class Float < TypedPointer
      type :float
    end

    # Int-typed pointer
    class Int < TypedPointer
      type :int
    end

    #
    class UInt16 < TypedPointer
      type :uint16
    end

    class UInt32 < TypedPointer
      type :uint32
    end

    class UInt8 < TypedPointer
      type :uint8
    end
    
    class Pointer < TypedPointer
      type :pointer
    end
        

  end
end