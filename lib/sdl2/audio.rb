require 'sdl2'
require 'sdl2/rwops'


module SDL2

  typedef :uint16, :audio_format

  module Audio
    module MASK
      include EnumerableConstants
      
      BITSIZE= (0xFF)
      DATATYPE= (1<<8)
      ENDIAN= (1<<12)
      SIGNED= (1<<15)
    end

    def self.bitsize(x)
      x & Mask.BITSIZE
    end

    def self.is_float?(x)
      (x & Mask.DATATYPE) != 0
    end

    def self.is_big_endian?(x)
      x & mask.ENDIAN
    end

    def self.is_signed?(x)
      x & mask.SIGNED
    end

    def self.is_int?(x)
      !is_float?(x)
    end

    def self.is_little_endian?(x)
      !is_big_endian?(x)
    end

    def self.is_unsigned?(x)
      !is_signed?(x)
    end

    
    U8 = 0x0008
    S8 = 0x8008
    U16LSB = 0x0010
    S16LSB = 0x8010
    U16MSB = 0x1010
    S16MSB = 0x9010
    U16 = U16LSB
    S16 = S16LSB
    S32LSB = 0x8020
    S32MSB = 0x9020
    S32 = S32LSB
    F32LSB = 0x8120
    F32MSB = 0x9120
    F32= F32LSB

    ALLOW_FREQUENCY_CHANGE    =0x00000001
    ALLOW_FORMAT_CHANGE       =0x00000002
    ALLOW_CHANNELS_CHANGE     =0x00000004
    ALLOW_ANY_CHANGE          =(ALLOW_FREQUENCY_CHANGE|ALLOW_FORMAT_CHANGE|ALLOW_CHANNELS_CHANGE)

    

    class Spec < Struct
      layout :freq, :int,
      :format, :uint16,
      :channels, :uint8,
      :silence, :uint8,
      :samples, :uint16,
      :padding, :uint16,
      :size, :uint32,
      :callback, :pointer, #:audio_callback,
      :userdata, :pointer
    end  

    class CVT < Struct
      layout :needed, :int,
      :src_format, :uint16,
      :dst_format, :uint16,
      :rate_incr, :double,
      :buf, :pointer,
      :len, :int,
      :len_cvt, :int,
      :len_mult, :int,
      :len_ratio, :double,
      :filters, [:pointer, 10], # :audio_filter callback
      :filter_index, :int
    end

  end#module Audio
  
  callback :audio_callback, [:pointer, :pointer, :int], :void
  callback :audio_filter, [Audio::CVT.by_ref, :audio_format], :void

  ##
	#
	api :SDL_GetNumAudioDrivers, [], :int
  ##
	#
	api :SDL_GetAudioDriver, [:int], :string
  ##
	#
	api :SDL_AudioInit, [:string], :int
  ##
	#
	api :SDL_AudioQuit, [], :void
  ##
	#
	api :SDL_GetCurrentAudioDriver, [], :string
  ##
	#
	api :SDL_OpenAudio, [Audio::Spec.by_ref, Audio::Spec.by_ref], :int

  typedef :uint32, :audio_device_id

  ##
	#
	api :SDL_GetNumAudioDevices, [:int], :int
  ##
	#
	api :SDL_GetAudioDeviceName, [:int, :int], :string
  ##
	#
	api :SDL_OpenAudioDevice, [:string, :int, Audio::Spec.by_ref, Audio::Spec.by_ref, :int], :audio_device_id

  enum :audio_status, [:STOPPED, 0, :PLAYING, :PAUSED]

  ##
	#
	api :SDL_GetAudioStatus, [], :audio_status
  ##
	#
	api :SDL_PauseAudio, [:int], :void
  ##
	#
	api :SDL_PauseAudioDevice, [:audio_device_id, :int], :void
  ##
	#
	api :SDL_LoadWAV_RW, [RWops.by_ref, :int, Audio::Spec.by_ref, :pointer, :pointer], Audio::Spec.by_ref

  def self.load_wav(file, spec, audio_buf, audio_len)
    load_wav_rw(rw_from_file)
  end
  
  ##
	#
	api :SDL_FreeWAV, [:pointer], :void
  ##
	#
	api :SDL_BuildAudioCVT, [Audio::CVT.by_ref, :audio_format, :uint8, :int, :audio_format, :uint8, :int], :int
  ##
	#
	api :SDL_ConvertAudio, [Audio::CVT.by_ref], :int
  
  MIX_MAXVOLUME = 128
  
  ##
	#
	api :SDL_MixAudio, [:pointer, :pointer, :uint32, :int], :void
  ##
	#
	api :SDL_MixAudioFormat, [:pointer, :pointer, :audio_format, :uint32, :int], :void
  ##
	#
	api :SDL_LockAudio, [], :void
  ##
	#
	api :SDL_LockAudioDevice, [:audio_device_id], :void
  ##
	#
	api :SDL_UnlockAudio, [], :void
  ##
	#
	api :SDL_UnlockAudioDevice, [:audio_device_id], :void
    
  ##
	#
	api :SDL_CloseAudio, [], :void
  ##
	#
	api :SDL_CloseAudioDevice, [:audio_device_id], :void
  

end