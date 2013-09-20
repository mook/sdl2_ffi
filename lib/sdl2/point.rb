require 'sdl2'

module SDL2
  class Point < Struct
    layout :x, :int, :y, :int
    
    member_readers *members
    member_writers *members
    
    def self.cast(something)
      if something.kind_of?(Array) and something.count == 2
        something.map!(&:to_i) 
        result = Point.new
        result.x, result.y = something
        return result
      else      
        return super
      end
    end
    
    def self.cast_array(somethings, count_something = nil)
      
      # Convert Ruby arrays into Struct Arrays.
      if somethings.kind_of? Array 
        count_something = somethings.count if count_something.nil?
        
        raise "count_something > somethings.count" if count_something > somethings.count
        
        pointer = FFI::MemoryPointer.new(self, count_something)
        
        count_something.times do |idx|
          pointer[idx].update_members(somethings[idx])
        end
        
        somethings = pointer
  
        # If it is already a structure, then it is an array of 1, unless
        # someone defined a count, in which case we assume they know what they
        # are doing.
      elsif somethings.kind_of? self
            count_something = 1 if count_something.nil?
            
      else
        raise "#{self} cannot cast array from #{somethings.inspect}"
      end
      
      return somethings, count_something
    end
    
    
  end
end