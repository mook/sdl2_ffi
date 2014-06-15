module SDL2
  ##
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
end