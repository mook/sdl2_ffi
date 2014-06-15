module SDL2
  ##
  # BadQuanta: sdl2_ffi messes with the FFI::Struct class for some useful additions.
  class Struct < FFI::Struct
    extend StructHelper
    ##
    # Allows creation and use within block, automatically freeing pointer after block.
    def initialize(*args, &block)
      Debug.log(self){"Initializing with args: #{args.inspect}"}
      super(*args)
      if block_given?
        Debug.log(self){'Block given, will be disposed of later'}
        throw 'Release must be defined to use block' unless self.class.respond_to?(:release)
        yield self
        Debug.log(self){'Block returned, now disposing.'}
        self.class.release(self.pointer)
      end
    end

    ##
    # Placeholder for Structs that need to initialize values.
    def self.create(values = {})
      Debug.log(self){"Constructing with values: #{values.inspect}"}
      created = self.new
      created.update_members(values)
      created
    end

    ##
    # A default release scheme is defined, but should be redefined where appropriate.
    def self.release(pointer)
      Debug.log(self){"Freeing pointer: #{pointer.inspect}"}
      pointer.free
    end

    ##
    # A default free operation, but should be redefined where appropriate.
    # TODO: Is this wrong to do in conjuction with release?
    def free()
      if self.pointer.autorelease?
        Debug.log(self){"Freeing autorelease pointer: #{pointer.inspect}"}
        self.pointer.free
      else
        Debug.log(self){"Not freeing pointer"}
        binding.pry
      end
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

    ##
    # Compare two structures by class and values.
    # This will return true when compared to a "partial hash" and
    # all the key/value pairs the hash defines equal the
    # corrisponding members in the structure.
    # Otherwise all values must match between structures.
    # TODO: CLEAN UP THIS COMPARISON CODE!!!
    def ==(other)
      Debug.log(self){
        "COMPARING #{self} to #{other}"
      }

      result = catch(:result) do
        unless self.class == other.class or other.kind_of? Hash
          Debug.log(self){"Class Mismatch"}
          throw :result, false
        end

        if (other.kind_of? Hash) and (other.keys - members).any?
          Debug.log(self){"Extra Keys: #{other.keys-members}"}
          thorw :result, false
        end

        if (other.respond_to?:null?) and (self.null? or other.null?)
          unless self.null? and other.null?
            Debug.log(self){"AHHHAOne is null and the other is not"}
            throw :result, false
          end
        else
          fields = other.kind_of?(Hash) ? members & other.keys : members
          fields.each do |field|
            Debug.log(self){"#{field}:#{self[field].class} = "}

            unless self[field] == other[field]

              Debug.log(self){"NO MATCH: #{self[field].to_s} #{other[field].to_s}"}
              throw :result, false
            end
            Debug.log(self){"MATCH"}
          end
        end

        # Everything passed
        throw :result, true

      end
      Debug.log(self){
        "RESULT = #{result}"
      }
      return result
    end

    ##
    # Default cast handler.
    #
    #
    # BadQuanta says:
    #   Casting means to take something and try to make it into a Structure
    #   - Other instances of the same class (simply returns that instance)
    #   - Any hash, this structure will be "created" with the has specifying members.
    #   - A nil object, which will return the same nil object assuming that is o.k.
    def self.cast(something)
      if something.kind_of? self
        Debug.log(self){'No casting required.'}
        return something
      elsif something.kind_of? Hash
        Debug.log(self){'Attempting to construct from hash.'}
        return self.create(something)
      elsif something.nil?
        Debug.log(self){'Something is nil, returning nil.'}
        return something #TODO: Assume NUL is ok?
      else
        # No need for a debug message, exception will act as one.
        raise "#{self} can't cast #{something.insepct}"
      end
    end

    ##
    # Set members to values contained within hash.
    def update_members(values)
      Debug.log(self){"Updating members from values: #{values.inspect}"}
      if values.kind_of? Array
        raise "#{self} has less fields then #{values.inspect}" if values.count > members.count
        Debug.log(self){"Field to value map: #{Hash.new(members.first(values.count).zip(values)).inspect}"}
        members.first(values.count).each_with_index do |field, idx|
          self[field] = values[idx]
        end
      elsif values.kind_of? Hash
        common = (self.members & values.keys)
        Debug.log(self){
          ignored_keys = values.keys - common
          ignored_keys.empty? ? "All hash keys mapped to struct members." : "Ignored these value keys: #{ignored_keys.inspect}"
        }
        common.each do |field|
          self[field] = values[field]
        end
      elsif values.kind_of? self.class
        Debug.log(self){'Coping values from another instance.'}
        members.each do |member|
          self[member] = values[member]
        end
      else
        raise "#{self}#update_members unable to update from #{values.inspect}"
      end
    end

    ##
    # Human readable translation of a structure
    def to_s
      null = self.to_ptr.null?
      values = members.map do |member|
        "#{member}=#{null ? 'null' : self[member]}"
      end unless null
      "<#{self.class.to_s} #{null ? 'NULL' : values.join(' ')}>"
    end
  end

end