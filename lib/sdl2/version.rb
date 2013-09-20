require 'sdl2'

module SDL2  
  
  # Used to identify linked versions of libraries.
  # Used by SDL2, SDL_Image, SDL_ttf, and etc.
  class Version < FFI::Struct
    layout :major, :uint8,
      :minor, :uint8,
      :patch, :uint8
      
    # Release memory held by a Version struct
    def self.release(pointer)
      pointer.free
    end
      
    # The major X.0.0 part
    def major
      self[:major]
    end
    
    # The minor 0.X.0 part
    def minor
      self[:minor]
    end
    
    # the patch 0.0.X part
    def patch
      self[:patch]
    end
    
    # Human-readable version string
    def to_s
      "v#{major}.#{minor}.#{patch}"
    end
    
  end
  
  ##
	#
	api :SDL_GetRevision, [], :string
  ##
	#
	api :SDL_GetRevisionNumber, [], :int
  ##
	#
	api :SDL_GetVersion, [Version.by_ref], :void
end
