require 'sdl2'

module SDL2
  
  module Mixer
    
    # The internal format for an audio chunk
    #
    #  * allocated - :int
    #  * abuf - :pointer of :uint8
    #  * alen - :uint32
    #  * volume - :uint8 "Per-sample volume, 0-128"
    class Chunk < SDL2::Struct
      
      layout :allocated, :int,
        :abuf, :pointer, #of :uint8
        :alen, :uint32,
        :volume, :uint8
       
      member_readers *members
      member_writers *members
    end
    
  end
  
end