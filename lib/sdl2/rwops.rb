require 'sdl2'

##
# SDL_rwops.h => sdl2/rwops.rb
# - RWops Structs
module SDL2
  #NOTE: This is just a forward declaration for the callbacks
  class RWops < Struct 
  end 
  
  #NOTE: The aforementioned callbacks
  callback :rwops_size, [RWops.by_ref], :int64
  callback :rwops_seek, [RWops.by_ref, :int64, :int], :int64
  callback :rwops_read, [RWops.by_ref, :pointer, :size_t, :size_t], :size_t
  callback :rwops_write, [RWops.by_ref, :pointer, :size_t, :size_t], :size_t
  callback :rwops_close, [RWops.by_ref], :int

  ##
  # "This is the read/write operation structure -- very basic"
  #   size    - " Return the size of the file in this rwops, or -1 if unkown
  #   seek    - "Seek to \c offset relative to \c whence, one of stdio's whence values:
  #               RW_SEEK_SET, RW_SEEK_CUR, RW_SEEK_END
  #               return the final offset in the data stream, or -1 on error.
  #   read    - "Read up to \c maxnum objects each of size \c size from the data
  #               stream to the area pointed at by \c ptr.
  #               Return the number of objects read, or 0 at error or end of file.
  #   write   - "Write eactly \c num objects each of size \c size from the area
  #               pointed at by \c ptr to data stream.
  #               Return the number of objects written, or 0 at error or end of file.
  #   close   - "Close and free an allocated SDL_RWops structure.
  #               Return 0 if successful or -1 on write error when flushing data.
  class RWops < Struct
    private
    class AndroidIO < Struct
      layout :fileNameRef, :pointer,
        :inputSteramRef, :pointer,
        :readableByteChannelRef, :pointer,
        :readMethod, :pointer,
        :assetFileDescriptorRef, :pointer,
        :position, :long,
        :size, :long,
        :offset, :long,
        :fd, :int
    end
    
    class WindowsIO < Struct
      class Buffer < Struct
        layout :data, :pointer,
          :size, :size_t,
          :left, :size_t
      end      
      layout :append, :bool,
        :h, :pointer,
        :buffer, Buffer
    end
    
    class STDIO < Struct
      layout :autoclose, :bool,
        :fp, :pointer
    end
    
    class Mem <Struct
      layout :base, UInt8Struct.by_ref,
        :here, UInt8Struct.by_ref,
        :stop, UInt8Struct.by_ref
    end
    
    class Unkown < Struct
      layout :data1, :pointer,
        :data2, :pointer
    end
    
    class Hidden < FFI::Union
      layout :androidio, AndroidIO,
        :windowsio, WindowsIO,
        :stdio, STDIO,
        :mem, Mem,
        :unkown, Unkown
    end
    
    public 
    
    layout :size, :rwops_size,
      :seek, :rwops_seek,
      :read, :rwops_read,
      :write, :rwops_write,
      :close, :rwops_close,
      :type, :uint32,
      :hidden, Hidden      
      
    ##
    # Release this structure using SDL_FreeRW
    def self.release(pointer)
      SDL2.free_rw(pointer)
    end
    
    ##
    # "Seek from the beginning of data"
    SEEK_SET = 0
    ##
    # "Seek relative to current read point"
    SEEK_CUR = 1
    ##
    # "Seek relative to the end of data"
    SEEK_END = 2       
    
    ##
    # Create RWOps from file name
    def self.from_file(file_name, mode)
      SDL2.rw_from_file!(file_name, mode)
    end
    
    # Read/Write Macros re-implemented: Lines #184~189
    
    ##
    # "Return the size of the file in this rwops, or -1 if unkown"
    def size
      self[:size].call
    end
    
    ##
    # "Seek to \c offset in the data stream, or -1 on error."
    # "\return the number of objects read, or 0 at error or end of file"
    def seek(offset, whence)
      self[:seek].call(self, offset, whence)
    end
    
    ##
    # BadQuanta: "I suppose this returns the current position"
    # SDL_rwops.h:186.
    def tell
      self[:seek].call(self, 0, SEEK_CUR)
    end
    
    ##
    # "Read up to \c maxnum objects each of size \c size from the data
    #  stream to the area pointed at by \c ptr."
    #  "\return the number of objects read, or 0 at error or end of file." 
    def read(pointer, size, n)
      self[:read].call(self, pointer, size, n)
    end
    
    ##
    #  "Write exactly \c num objects each of size \c size from the area
    #  pointed at by \c ptr to data stream."
    #
    #  "\return the number of objects written, or 0 at error or end of file."    
    def write(pointer, size, n)
      self[:write].call(self, pointer, size, n)
    end
    
    ##
    # "Close and free an allocated SDL_RWops structure."
    #  "\return 0 if successful or -1 on write error when flushing data."
    def close
      self[:close].call(self)
    end
    
  end
  
  ##
	# Load from a file
  #   *  file - filename string (existing)
  #   *  mode - mode string
	api :SDL_RWFromFile, [:string, :string], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	# Load from a file pointer
	#   *  fp - a file pointer
  #   *  autoclose - boolean
	api :SDL_RWFromFP, [:pointer, :bool], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	# Load from any pointer in memory
	#   *  mem - pointer
	#   *  size - integer
	api :SDL_RWFromMem, [:pointer, :count], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	# Load from "constant" memory
	#   *  mem - constant pointer
	#   *  size - integer
	api :SDL_RWFromConstMem, [:pointer, :count], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	# Allocate a RWops structure
	api :SDL_AllocRW, [], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	# Release a RWops structure
	api :SDL_FreeRW, [RWops.by_ref], :void
  ##
	# Read 8 bytes
	api :SDL_ReadU8, [RWops.by_ref], :uint8
  ##
	# Read 16 bytes little endian
	api :SDL_ReadLE16, [RWops.by_ref], :uint16
  ##
	# Read 16 bytes big endian
	api :SDL_ReadBE16, [RWops.by_ref], :uint16
  ##
	# Read 32 bytes little endian
	api :SDL_ReadLE32, [RWops.by_ref], :uint32
  ##
	# Read 32 bytes big endian
	api :SDL_ReadBE32, [RWops.by_ref], :uint32
  ##
	# Read 64 bytes little endian
	api :SDL_ReadLE64, [RWops.by_ref], :uint64
  ##
	# Read 32 bytes big endian
	api :SDL_ReadBE64, [RWops.by_ref], :uint64
  
  ##
	# Write 8 bytes
	api :SDL_WriteU8, [RWops.by_ref, :uint8], :size_t
  ##
	# Write 16 bytes little endian
	api :SDL_WriteLE16, [RWops.by_ref, :uint16], :size_t
  ##
	# Write 16 bytes big endian
	api :SDL_WriteBE16, [RWops.by_ref, :uint16], :size_t
  ##
	# Write 32 bytes little endian
	api :SDL_WriteLE32, [RWops.by_ref, :uint32], :size_t
  ##
	# Write 32 bytes big endian
	api :SDL_WriteBE32, [RWops.by_ref, :uint32], :size_t
  ##
	# Write 64 bytes little endian
	api :SDL_WriteLE64, [RWops.by_ref, :uint64], :size_t
  ##
	# Write 64 bytes big endian
	api :SDL_WriteBE64, [RWops.by_ref, :uint64], :size_t
end