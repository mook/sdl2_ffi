require 'sdl2'

module SDL2

  module Mixer
    # Values to be combined and used with Mixer::init()
    module INIT

      include EnumerableConstants

      FLAC        = 0x00000001
      MOD         = 0x00000002
      MODPLUG     = 0x00000004
      MP3         = 0x00000008
      OGG         = 0x00000010
      FLUIDSYNTH  = 0x00000020

    end

  end

end