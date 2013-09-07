module Sdl2Ffi
  GEM_VERSION = "0.0.1"
  
  class Version < FFI::Struct
    layout :major, :uint8,
      :minor, :uint8,
      :patch, :uint8
      
    def major
      self[:major]
    end
    
    def minor
      self[:minor]
    end
    
    def patch
      self[:patch]
    end
    
    def to_s
      "SDL v#{major}.#{minor}.#{patch}"
    end
  end
  
  attach_function :SDL_GetRevision, [], :string
  attach_function :SDL_GetRevisionNumber, [], :int
  attach_function :SDL_GetVersion, [Version.by_ref], :void
end
