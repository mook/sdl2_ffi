##
# `SDL2::StructArray` helps pass lists between SDL and Ruby
module SDL2
  ##
  # Helps pass lists of structures between SDL and Ruby
  class StructArray
    
    ##
    # Clones an existing array into a typed StructArray
    # Each instance in the class is cast to the Struct and then cloned.
    def self.clone_from(array, struct_class)
      cloned_array = self.new(struct_class, array.count)
      array.each_with_index do |item, idx|
        cloned_array[idx].update_members(item)
      end
      cloned_array
    end
      
    ##
    # Initialize the memory for an array of specified struct_class with count for length.
    def initialize(struct_class, count)
      @count = count
      @struct_class = struct_class
      # TODO: Make sure this will free the memory when this 
      # struct array is garbage collected.
      @pointer = FFI::MemoryPointer.new(struct_class, @count)
    end
    
    ##
    # Provides access to the count sent for this instance and it's FFI::Pointer
    attr_reader :pointer, :count
    
    ##
    # Helper, constructs an instance of the structure class pointing at this index in memory.
    def [](idx)
      raise "Invalid index #{idx}, count is #{@count}" unless (0 <= idx) and (idx < @count)
      @struct_class.new(pointer + (idx*@struct_class.size))
    end    
    
    ##
    # Returns the very first structure if count is nil, or to all the structures specified
    # if count is not nil.
    def first(count = nil)
      if count.nil?
        self[0]
      else
        count.times.map do |idx|
          self[idx]
        end
      end        
    end
    
    ##
    # Returns the very last structure element
    def last
      self[@count-1]
    end
  end
end