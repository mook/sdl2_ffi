require 'sdl2'

module SDL2  
  
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
  
  attach_function :get_revision, :SDL_GetRevision, [], :string
  attach_function :get_revision_number, :SDL_GetRevisionNumber, [], :int
  attach_function :get_version, :SDL_GetVersion, [Version.by_ref], :void
end
