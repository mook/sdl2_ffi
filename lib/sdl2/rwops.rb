require 'sdl2'

module SDL2
  #Forward Declaration for callbacks
  class RWops < Struct 
  end 
  callback :rwops_size, [RWops.by_ref], :int64
  callback :rwops_seek, [RWops.by_ref, :int64, :int], :int64
  callback :rwops_read, [RWops.by_ref, :pointer, :size_t, :size_t], :size_t
  callback :rwops_write, [RWops.by_ref, :pointer, :size_t, :size_t], :size_t
  callback :rwops_close, [RWops.by_ref], :int

  class RWops < Struct
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
    
    
    layout :size, :rwops_size,
      :seek, :rwops_seek,
      :read, :rwops_read,
      :write, :rwops_write,
      :close, :rwops_close,
      :type, :uint32,
      :hidden, Hidden      
      
    def self.release(pointer)
      SDL2.free_rw(pointer)
    end
    
    # CONSTANTS
    SEEK_SET = 0
    SEEK_CUR = 1
    SEEK_END = 2       
    
    def self.from_file(file_name, mode)
      SDL2.rw_from_file!(file_name, mode)
    end
    
    # Read/Write Macros re-implemented: Lines #184~189
    def size
      self[:size].call
    end
    
    def seek(offset, whence)
      self[:seek].call(self, offset, whence)
    end
    
    def tell
      self[:seek].call(self, 0, SEEK_CUR)
    end
    
    def read(pointer, size, n)
      self[:read].call(self, pointer, size, n)
    end
    
    def write(pointer, size, n)
      self[:write].call(self, pointer, size, n)
    end
    
    def close
      self[:close].call(self)
    end
    
  end
  
  ##
	#
	api :SDL_RWFromFile, [:string, :string], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_RWFromFP, [:pointer, :bool], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_RWFromMem, [:pointer, :count], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_RWFromConstMem, [:pointer, :count], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_AllocRW, [], RWops.auto_ptr, {error: true, filter: TRUE_WHEN_NOT_NULL}
  ##
	#
	api :SDL_FreeRW, [RWops.by_ref], :void
  ##
	#
	api :SDL_ReadU8, [RWops.by_ref], :uint8
  ##
	#
	api :SDL_ReadLE16, [RWops.by_ref], :uint16
  ##
	#
	api :SDL_ReadBE16, [RWops.by_ref], :uint16
  ##
	#
	api :SDL_ReadLE32, [RWops.by_ref], :uint32
  ##
	#
	api :SDL_ReadBE32, [RWops.by_ref], :uint32
  ##
	#
	api :SDL_ReadLE64, [RWops.by_ref], :uint64
  ##
	#
	api :SDL_ReadBE64, [RWops.by_ref], :uint64
  
  ##
	#
	api :SDL_WriteU8, [RWops.by_ref, :uint8], :size_t
  ##
	#
	api :SDL_WriteLE16, [RWops.by_ref, :uint16], :size_t
  ##
	#
	api :SDL_WriteBE16, [RWops.by_ref, :uint16], :size_t
  ##
	#
	api :SDL_WriteLE32, [RWops.by_ref, :uint32], :size_t
  ##
	#
	api :SDL_WriteBE32, [RWops.by_ref, :uint32], :size_t
  ##
	#
	api :SDL_WriteLE64, [RWops.by_ref, :uint64], :size_t
  ##
	#
	api :SDL_WriteBE64, [RWops.by_ref, :uint64], :size_t
end