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
  
  api :SDL_GetRevision, [], :string
  api :SDL_GetRevisionNumber, [], :int
  api :SDL_GetVersion, [Version.by_ref], :void
end
