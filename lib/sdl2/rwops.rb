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

  class RWops 
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
  
  attach_function :rw_from_file, :SDL_RWFromFile, [:string, :string], RWops.auto_ptr
  attach_function :rw_from_fp, :SDL_RWFromFP, [:pointer, :bool], RWops.auto_ptr
  attach_function :rw_from_mem, :SDL_RWFromMem, [:pointer, :count], RWops.auto_ptr
  attach_function :rw_from_const_mem, :SDL_RWFromConstMem, [:pointer, :count], RWops.auto_ptr
  attach_function :alloc_rw, :SDL_AllocRW, [], RWops.auto_ptr
  attach_function :free_rw, :SDL_FreeRW, [RWops.by_ref], :void
  attach_function :read_u8, :SDL_ReadU8, [RWops.by_ref], :uint8
  attach_function :read_le16, :SDL_ReadLE16, [RWops.by_ref], :uint16
  attach_function :read_be16, :SDL_ReadBE16, [RWops.by_ref], :uint16
  attach_function :read_le32, :SDL_ReadLE32, [RWops.by_ref], :uint32
  attach_function :read_be32, :SDL_ReadBE32, [RWops.by_ref], :uint32
  attach_function :read_le64, :SDL_ReadLE64, [RWops.by_ref], :uint64
  attach_function :read_be64, :SDL_ReadBE64, [RWops.by_ref], :uint64
  
  attach_function :write_u8, :SDL_WriteU8, [RWops.by_ref, :uint8], :size_t
  attach_function :write_le16, :SDL_WriteLE16, [RWops.by_ref, :uint16], :size_t
  attach_function :write_be16, :SDL_WriteBE16, [RWops.by_ref, :uint16], :size_t
  attach_function :write_le32, :SDL_WriteLE32, [RWops.by_ref, :uint32], :size_t
  attach_function :write_be32, :SDL_WriteBE32, [RWops.by_ref, :uint32], :size_t
  attach_function :write_le64, :SDL_WriteLE64, [RWops.by_ref, :uint64], :size_t
  attach_function :write_be64, :SDL_WriteBE64, [RWops.by_ref, :uint64], :size_t
end