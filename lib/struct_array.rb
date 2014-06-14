module SDL2
  class StructArray
    
    def self.clone_from(array, struct_class)
      cloned_array = self.new(struct_class, array.count)
      array.each_with_index do |item, idx|
        cloned_array[idx].update_members(item)
      end
      cloned_array
    end
      
    
    def initialize(struct_class, count)
      @count = count
      @struct_class = struct_class
      # TODO: Make sure this will free the memory when this 
      # struct array is garbage collected.
      @pointer = FFI::MemoryPointer.new(struct_class, @count)
      ObjectSpace.define_finalizer(self,lambda{@pointer.free})
    end
    
    attr_reader :pointer, :count
    
    def [](idx)
      raise "Invalid index #{idx}, count is #{@count}" unless (0 <= idx) and (idx < @count)
      @struct_class.new(pointer + (idx*@struct_class.size))
    end    
    
    def first
      self[0]
    end
    
    def last
      self[@count-1]
    end
  end
end