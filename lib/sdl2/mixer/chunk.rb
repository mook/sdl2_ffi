require 'sdl2'

module SDL2
  
  module Mixer
    
    ##
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
      
      ##
      # Load a chunk from a wave file path (string)
      def self.load_wav(filepath)
        Mixer.load_wav!(filepath)
      end
      
      ##
      # Plays chunk
      #   opts[:channel]: defaults to -1
      #   opts[:loop]: defaults to 0
      #   opts[:ms]: defaults to -1
      def play(opts = {})
        channel = opts[:channel] || -1
        loop = opts[:loop] || 0
        ms = opts[:ms] || -1
        Mixer::play_channel_timed(channel, self, loop, ms)
      end
      
      ##
      # Check if anything is playing?
      def self.playing?
        Mixer::playing?(-1)
      end
      
      ## 
      # Release this structure with Mixer::free_chunk
      def self.release(pointer)
        Mixer::free_chunk(pointer)
      end
      
    end
    
  end
  
end