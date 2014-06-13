require 'sdl2'
require 'sdl2/version'
require 'sdl2/rwops'
require 'sdl2/mixer/lib_paths'
require 'sdl2/mixer/chunk'

module SDL2

  # Interface for "SDL_mixer.h"
  module Mixer
    extend FFI::Library
    extend SDL2::Library
    ffi_lib Mixer::LibPaths

    # Good default values for a PC soundcard
    DEFAULT_FREQUENCY   = 22050
    DEFAULT_FORMAT  = Audio::S16LSB
    DEFAULT_CHANNELS = 2
    MAX_VOLUME = 128
    # The default mixer has 8 simultaneous mixing channels
    CHANNELS = 8

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
    ##
    # This function gets the version of the dynamically linked SDL_mixer library.
    # :method: linked_version
    api :Mix_Linked_Version, [], Version.auto_ptr

    enum :init_flags, INIT.flatten_consts

    ##
    # Loads dynamic libraries and prepares them for use.  Flags should be
    # one or more flags from MIX_InitFlags OR'd together.
    # It returns the flags successfully initialized, or 0 on failure.
    # :call-seq:
    #   Mix_Init(flags)
    #   init(flags)
    #   init!(flags)
    api :Mix_Init, [:init_flags], :int, {error: true, filter: OK_WHEN_NOT_ZERO}

    ##
    # Unloads libraries loaded with Mix_Init
    # :call-seq:
    #   Mix_Quit()
    #   quit()
    api :Mix_Quit, [], :void

    module FADING
      include EnumerableConstants
      NO = next_const_value
      OUT = next_const_value
      IN = next_const_value
    end

    enum :fading, FADING.flatten_consts

    class Music < Struct

      module TYPE
        include EnumerableConstants
        NONE = next_const_value
        CMD  = next_const_value
        WAV  = next_const_value
        MOD  = next_const_value
        MID  = next_const_value
        OGG  = next_const_value
        MP3  = next_const_value
        MP3_MAD = next_const_value
        FLAC  = next_const_value
        MODPLUG  = next_const_value
      end
    end
    enum :music_type, Music::TYPE.flatten_consts

    class Music
      layout :type, :music_type,
      :data, :pointer,
      :fading, :fading,
      :fade_step, :int,
      :fade_steps, :int,
      :error, :int

      def self.load(filepath)
        Mixer::load_mus!(filepath)
      end

      def self.playing?
        Mixer::playing_music?
      end
      
      def self.paused?
        Mixer::paused_music?
      end
      
      def self.resume
        Mixer::resume_music
      end
      
      def self.pause
        Mixer::pause_music
      end
      
      def self.release(pointer)
        Mixer::free_music(pointer)
      end
    end

    ##
    # Open the mixer with a certain audio format
    # :call-seq:
    #   open_audio(frequency, format, channels, chunksize)
    #   open_audio!(frequency, format, channels, chunksize)
    #
    api :Mix_OpenAudio, [:int, :uint16, :int, :int], :int, {error: true}

    ##
    # Dynamically change the number of channels managed by the mixer.
    # If decreasing the number of channels, the upper channels are
    # stopped.
    # This function returns the new number of allocated channels.
    # :call-seq:
    #   allocate_channels(numchans)
    api :Mix_AllocateChannels, [:int], :int

    ##
    # Find out what the actual audio device parameters are.
    # This function returns 1 if the audio has been opened, 0 otherwise.
    # :call-seq:
    #   query_spec(freq_ptr, format_ptr, channels_ptr)
    api :Mix_QuerySpec, [:pointer, :pointer, :pointer], :int

    ##
    # Load a wave file
    # :call-seq:
    #   load_wav_rw(src_rwops, freesrc)
    api :Mix_LoadWAV_RW, [RWops.by_ref, :int], Chunk.auto_ptr

    ##
    # Load a wave file or a music (.mod .s3m .it .xm) file
    def self.load_wav(filename)
      Mixer::load_wav_rw(RWops.from_file(filename, "rb"), 1)
    end

    returns_error :load_wav, OK_WHEN_NOT_NULL

    ##
    # Load a wave file or a music (.mod .s3m .it .xm) file
    # :call-seq:
    #   load_mus(filepath)
    api :Mix_LoadMUS, [:string], Music.auto_ptr, {error: true, filter: OK_WHEN_NOT_NULL}

    ##
    # Load a music file from an SDL_RWop object (Ogg and MikMod specific currently)
    # Matt Campbell (matt@campbellhome.dhs.org) April 2000
    api :Mix_LoadMUS_RW, [RWops.by_ref, :int], Music.auto_ptr

    ##
    # Load a music file from an SDL_RWop object assuming a specific format
    api :Mix_LoadMUSType_RW, [RWops.by_ref, :music_type, :int], Music.auto_ptr

    ##
    # Load a wave file of the mixer format from a memory buffer
    api :Mix_QuickLoad_WAV, [:pointer], Chunk.auto_ptr

    ##
    # Load raw audio data of the mixer format from a memory buffer
    api :Mix_QuickLoad_RAW, [:pointer, :uint32], Chunk.auto_ptr

    ##
    # Free an audio chunk previously loaded
    api :Mix_FreeChunk, [Chunk.by_ref], :void

    ##
    # Free music previously loaded
    api :Mix_FreeMusic, [Music.by_ref], :void

    ##
    # Get a list of chunk/music decoders that this build of SDL_mixer provides.
    # This list can change between builds AND runs of the program, if external
    # libraries that add functionality become available.
    # You must successfully call Mix_OpenAudio() before calling these functions.
    # This API is only available in SDL_mixer 1.2.9 and later.
    #
    # // usage...
    # int i;
    # const int total = Mix_GetNumChunkDecoders();
    # for (i = 0; i < total; i++)
    #     printf("Supported chunk decoder: [%s]\n", Mix_GetChunkDecoder(i));
    #
    # Appearing in this list doesn't promise your specific audio file will
    # decode...but it's handy to know if you have, say, a functioning Timidity
    # install.
    #
    # These return values are static, read-only data; do not modify or free it.
    # The pointers remain valid until you call Mix_CloseAudio().
    #
    api :Mix_GetNumChunkDecoders, [], :int
    api :Mix_GetChunkDecoder, [:int], :string
    api :Mix_GetNumMusicDecoders, [], :int
    api :Mix_GetMusicDecoder, [:int], :string

    ##
    # Find out the music format of a mixer music, or the currently playing
    # music, if 'music' is NULL.
    api :Mix_GetMusicType, [Music.by_ref], :music_type

    callback :mix_func, [:pointer, :pointer, :int], :void

    ##
    # Set a function that is called after all mixing is performed.
    # This can be used to provide real-time visual display of the audio stream
    # or add a custom mixer filter for the stream data.
    # :call-seq:
    #   set_post_mix(Proc.new{|user_data_ptr, stream_ptr, length| ... })
    api :Mix_SetPostMix, [:mix_func], :void

    ##
    # Add your own music player or additional mixer function.
    # If 'mix_func' is NULL, the default music player is re-enabled.
    # :call-seq:
    #   set_hook_music(Proc.new{|user_data_ptr, stream_ptr, length| ... })
    api :Mix_HookMusic, [:mix_func], :void

    ##
    # Callback: music_finished
    callback :music_finished, [], :void

    ##
    # Add your own callback when the music has finsihed playing.
    # This callback is only called if the music finishes naturally.
    # :call-seq:
    #   hook_music_finished(Proc.new {|| ...})
    api :Mix_HookMusicFinished, [:music_finished], :void

    ##
    # Get a pointer to the user data for the current music hook
    api :Mix_GetMusicHookData, [], :pointer

    ##
    # Add your own callback when a channel has finished playing. NULL
    # to disable callback. The callback may be called from the mixer's audio
    # callback or it could be called as a result of Mix_HaltChannel(), etc.
    # do not call SDL_LockAudio() from this callback; you will either be
    # inside the audio callback, or SDL_mixer will explicitly lock the audio
    # before calling your callback.
    api :Mix_ChannelFinished, [:pointer, :int], :void

    # Special Effects API by ryan c. gordon.....
    CHANNEL_POST = -2

    ##
    # This is the format of a special effect callback:
    #
    #   myeffect(int chan, void *stream, int len, void *udata);
    #
    # (chan) is the channel number that your effect is affecting. (stream) is
    #  the buffer of data to work upon. (len) is the size of (stream), and
    #  (udata) is a user-defined bit of data, which you pass as the last arg of
    #  Mix_RegisterEffect(), and is passed back unmolested to your callback.
    #  Your effect changes the contents of (stream) based on whatever parameters
    #  are significant, or just leaves it be, if you prefer. You can do whatever
    #  you like to the buffer, though, and it will continue in its changed state
    #  down the mixing pipeline, through any other effect functions, then finally
    #  to be mixed with the rest of the channels and music for the final output
    #  stream.
    #
    # DO NOT EVER call SDL_LockAudio() from your callback function!
    #
    callback :effect_func, [:int, :pointer, :int, :pointer], :void

    ##
    # This is a callback that signifies that a channel has finished all its
    #  loops and has completed playback. This gets called if the buffer
    #  plays out normally, or if you call Mix_HaltChannel(), implicitly stop
    #  a channel via Mix_AllocateChannels(), or unregister a callback while
    #  it's still playing.
    #
    # DO NOT EVER call SDL_LockAudio() from your callback function!
    callback :effect_done, [:int, :pointer], :void

    ##
    # Register a special effect function. At mixing time, the channel data is
    #  copied into a buffer and passed through each registered effect function.
    #  After it passes through all the functions, it is mixed into the final
    #  output stream. The copy to buffer is performed once, then each effect
    #  function performs on the output of the previous effect. Understand that
    #  this extra copy to a buffer is not performed if there are no effects
    #  registered for a given chunk, which saves CPU cycles, and any given
    #  effect will be extra cycles, too, so it is crucial that your code run
    #  fast. Also note that the data that your function is given is in the
    #  format of the sound device, and not the format you gave to Mix_OpenAudio(),
    #  although they may in reality be the same. This is an unfortunate but
    #  necessary speed concern. Use Mix_QuerySpec() to determine if you can
    #  handle the data before you register your effect, and take appropriate
    #  actions.
    # You may also specify a callback (Mix_EffectDone_t) that is called when
    #  the channel finishes playing. This gives you a more fine-grained control
    #  than Mix_ChannelFinished(), in case you need to free effect-specific
    #  resources, etc. If you don't need this, you can specify NULL.
    # You may set the callbacks before or after calling Mix_PlayChannel().
    # Things like Mix_SetPanning() are just internal special effect functions,
    #  so if you are using that, you've already incurred the overhead of a copy
    #  to a separate buffer, and that these effects will be in the queue with
    #  any functions you've registered. The list of registered effects for a
    #  channel is reset when a chunk finishes playing, so you need to explicitly
    #  set them with each call to Mix_PlayChannel*().
    # You may also register a special effect function that is to be run after
    #  final mixing occurs. The rules for these callbacks are identical to those
    #  in Mix_RegisterEffect, but they are run after all the channels and the
    #  music have been mixed into a single stream, whereas channel-specific
    #  effects run on a given channel before any other mixing occurs. These
    #  global effect callbacks are call "posteffects". Posteffects only have
    #  their Mix_EffectDone_t function called when they are unregistered (since
    #  the main output stream is never "done" in the same sense as a channel).
    #  You must unregister them manually when you've had enough. Your callback
    #  will be told that the channel being mixed is (MIX_CHANNEL_POST) if the
    #  processing is considered a posteffect.
    #
    # After all these effects have finished processing, the callback registered
    #  through Mix_SetPostMix() runs, and then the stream goes to the audio
    #  device.
    #
    # DO NOT EVER call SDL_LockAudio() from your callback function!
    #
    # returns zero if error (no such channel), nonzero if added.
    #  Error messages can be retrieved from Mix_GetError().
    api :Mix_RegisterEffect, [:int, :effect_func, :effect_done, :pointer], :int

    ##
    # You may not need to call this explicitly, unless you need to stop an
    #  effect from processing in the middle of a chunk's playback.
    # Posteffects are never implicitly unregistered as they are for channels,
    #  but they may be explicitly unregistered through this function by
    #  specifying MIX_CHANNEL_POST for a channel.
    # returns zero if error (no such channel or effect), nonzero if removed.
    #  Error messages can be retrieved from Mix_GetError().
    api :Mix_UnregisterEffect, [:int, :effect_func], :int

    ##
    # You may not need to call this explicitly, unless you need to stop all
    #  effects from processing in the middle of a chunk's playback. Note that
    #  this will also shut off some internal effect processing, since
    #  Mix_SetPanning() and others may use this API under the hood. This is
    #  called internally when a channel completes playback.
    # Posteffects are never implicitly unregistered as they are for channels,
    #  but they may be explicitly unregistered through this function by
    #  specifying MIX_CHANNEL_POST for a channel.
    # returns zero if error (no such channel), nonzero if all effects removed.
    #  Error messages can be retrieved from Mix_GetError().
    api :Mix_UnregisterAllEffects, [:int], :int

    EFFECTSMAXSPEED = "MIX_EFFECTSMAXSPEED"

    #
    # These are the internally-defined mixing effects. They use the same API that
    #  effects defined in the application use, but are provided here as a
    #  convenience. Some effects can reduce their quality or use more memory in
    #  the name of speed; to enable this, make sure the environment variable
    #  MIX_EFFECTSMAXSPEED (see above) is defined before you call
    #  Mix_OpenAudio().
    #

    ##
    # Set the panning of a channel. The left and right channels are specified
    #  as integers between 0 and 255, quietest to loudest, respectively.
    #
    # Technically, this is just individual volume control for a sample with
    #  two (stereo) channels, so it can be used for more than just panning.
    #  If you want real panning, call it like this:
    #
    #   Mix_SetPanning(channel, left, 255 - left);
    #
    # ...which isn't so hard.
    #
    # Setting (channel) to MIX_CHANNEL_POST registers this as a posteffect, and
    #  the panning will be done to the final mixed stream before passing it on
    #  to the audio device.
    #
    # This uses the Mix_RegisterEffect() API internally, and returns without
    #  registering the effect function if the audio device is not configured
    #  for stereo output. Setting both (left) and (right) to 255 causes this
    #  effect to be unregistered, since that is the data's normal state.
    #
    # returns zero if error (no such channel or Mix_RegisterEffect() fails),
    #  nonzero if panning effect enabled. Note that an audio device in mono
    #  mode is a no-op, but this call will return successful in that case.
    #  Error messages can be retrieved from Mix_GetError().
    #
    api :Mix_SetPanning, [:int, :uint8, :uint8], :int

    ##
    # Set the position of a channel. (angle) is an integer from 0 to 360, that
    #  specifies the location of the sound in relation to the listener. (angle)
    #  will be reduced as neccesary (540 becomes 180 degrees, -100 becomes 260).
    #  Angle 0 is due north, and rotates clockwise as the value increases.
    #  For efficiency, the precision of this effect may be limited (angles 1
    #  through 7 might all produce the same effect, 8 through 15 are equal, etc).
    #  (distance) is an integer between 0 and 255 that specifies the space
    #  between the sound and the listener. The larger the number, the further
    #  away the sound is. Using 255 does not guarantee that the channel will be
    #  culled from the mixing process or be completely silent. For efficiency,
    #  the precision of this effect may be limited (distance 0 through 5 might
    #  all produce the same effect, 6 through 10 are equal, etc). Setting (angle)
    #  and (distance) to 0 unregisters this effect, since the data would be
    #  unchanged.
    #
    # If you need more precise positional audio, consider using OpenAL for
    #  spatialized effects instead of SDL_mixer. This is only meant to be a
    #  basic effect for simple "3D" games.
    #
    # If the audio device is configured for mono output, then you won't get
    #  any effectiveness from the angle; however, distance attenuation on the
    #  channel will still occur. While this effect will function with stereo
    #  voices, it makes more sense to use voices with only one channel of sound,
    #  so when they are mixed through this effect, the positioning will sound
    #  correct. You can convert them to mono through SDL before giving them to
    #  the mixer in the first place if you like.
    #
    # Setting (channel) to MIX_CHANNEL_POST registers this as a posteffect, and
    #  the positioning will be done to the final mixed stream before passing it
    #  on to the audio device.
    #
    # This is a convenience wrapper over Mix_SetDistance() and Mix_SetPanning().
    #
    # returns zero if error (no such channel or Mix_RegisterEffect() fails),
    #  nonzero if position effect is enabled.
    #  Error messages can be retrieved from Mix_GetError().
    #
    api :Mix_SetPosition, [:int, :int16, :uint8], :int

    ##
    # Set the "distance" of a channel. (distance) is an integer from 0 to 255
    #  that specifies the location of the sound in relation to the listener.
    #  Distance 0 is overlapping the listener, and 255 is as far away as possible
    #  A distance of 255 does not guarantee silence; in such a case, you might
    #  want to try changing the chunk's volume, or just cull the sample from the
    #  mixing process with Mix_HaltChannel().
    # For efficiency, the precision of this effect may be limited (distances 1
    #  through 7 might all produce the same effect, 8 through 15 are equal, etc).
    #  (distance) is an integer between 0 and 255 that specifies the space
    #  between the sound and the listener. The larger the number, the further
    #  away the sound is.
    # Setting (distance) to 0 unregisters this effect, since the data would be
    #  unchanged.
    # If you need more precise positional audio, consider using OpenAL for
    #  spatialized effects instead of SDL_mixer. This is only meant to be a
    #  basic effect for simple "3D" games.
    #
    # Setting (channel) to MIX_CHANNEL_POST registers this as a posteffect, and
    #  the distance attenuation will be done to the final mixed stream before
    #  passing it on to the audio device.
    #
    # This uses the Mix_RegisterEffect() API internally.
    #
    # returns zero if error (no such channel or Mix_RegisterEffect() fails),
    #  nonzero if position effect is enabled.
    #  Error messages can be retrieved from Mix_GetError().
    #
    api :Mix_SetDistance, [:int, :uint8], :int

    ##
    # Causes a channel to reverse its stereo. This is handy if the user has his
    #  speakers hooked up backwards, or you would like to have a minor bit of
    #  psychedelia in your sound code.  :)  Calling this function with (flip)
    #  set to non-zero reverses the chunks's usual channels. If (flip) is zero,
    #  the effect is unregistered.
    #
    # This uses the Mix_RegisterEffect() API internally, and thus is probably
    #  more CPU intensive than having the user just plug in his speakers
    #  correctly. Mix_SetReverseStereo() returns without registering the effect
    #  function if the audio device is not configured for stereo output.
    #
    # If you specify MIX_CHANNEL_POST for (channel), then this the effect is used
    #  on the final mixed stream before sending it on to the audio device (a
    #  posteffect).
    #
    # returns zero if error (no such channel or Mix_RegisterEffect() fails),
    #  nonzero if reversing effect is enabled. Note that an audio device in mono
    #  mode is a no-op, but this call will return successful in that case.
    #  Error messages can be retrieved from Mix_GetError().

    api :Mix_SetReverseStereo, [:int, :int], :int

    ##
    # Reserve the first channels (0 -> n-1) for the application, i.e. don't allocate
    # them dynamically to the next sample if requested with a -1 value below.
    # Returns the number of reserved channels.
    api :Mix_ReserveChannels, [:int], :int

    ##
    #  Attach a tag to a channel. A tag can be assigned to several mixer
    # channels, to form groups of channels.
    # If 'tag' is -1, the tag is removed (actually -1 is the tag used to
    # represent the group of all the channels).
    # Returns true if everything was OK.
    api :Mix_GroupChannel, [:int, :int], :int

    ##
    # Assign several consecutive channels to a group
    api :Mix_GroupChannels, [:int, :int, :int], :int

    ##
    # Finds the first available channel in a group of channels,
    # @returns -1 if none are available.
    api :Mix_GroupAvailable, [:int], :int

    ##
    # Returns the number of channels in a group.  This is also a subtle way
    # to get the total number of channels when 'tag' is -1
    api :Mix_GroupCount, [:int], :int

    ##
    # Finds the "oldest" sample playing in a group of channels
    api :Mix_GroupOldest, [:int], :int

    ##
    #  Finds the "most recent" (i.e. last) sample playing in a group of channels
    api :Mix_GroupNewer, [:int], :int

    # Play an audio chunk on a specific channel.
    # If the specified channel is -1, play on the first free channel.
    # If 'loops' is greater than zero, loop the sound that many times.
    # If 'loops' is -1, loop inifinitely (~65000 times).
    # Returns which channel was used to play the sound.
    def self.play_channel(channel,chunk,loops=-1)
      Mixer::play_channel_timed(channel,chunk,loops,-1)
    end

    ##
    # The same as above, but the sound is played at most 'ticks' milliseconds
    api :Mix_PlayChannelTimed, [:int, Chunk.by_ref, :int, :int], :int

    ##
    #
    api :Mix_PlayMusic, [Music.by_ref, :int], :int, {error: true}

    ##
    # Fade in music or a channel over "ms" milliseconds, same semantics as the "Play" functions
    api :Mix_FadeInMusic, [Music.by_ref, :int, :int], :int
    ##
    #
    api :Mix_FadeInMusicPos, [Music.by_ref, :int, :int, :double], :int
    ##
    #
    api :Mix_FadeInChannelTimed, [:int, Chunk.by_ref, :int, :int], :int

    ##
    # Set the volume in the range of 0-128 of a specific channel or chunk.
    # If the specified channel is -1, set volume for all channels.
    # Returns the original volume.
    # If the specified volume is -1, just return the current volume.
    api :Mix_Volume, [:int, :int], :int
    api :Mix_VolumeChunk, [Chunk.by_ref, :int], :int
    api :Mix_VolumeMusic, [:int], :int

    ##
    # Halt the playing of a particular channel
    api :Mix_HaltChannel, [:int], :int, {error: true}
    api :Mix_HaltGroup, [:int], :int, {error: true}
    api :Mix_HaltMusic, [], :int, {error: true}

    ##
    # Change the expiration delay for a particular channel.
    # The sample will stop playing after the 'ticks' milliseconds have elapsed,
    # or remove the expiration if 'ticks' is -1
    api :Mix_ExpireChannel, [:int, :int], :int

    ##
    # Halt a channel, fading it out progressively till it's silent
    # The ms parameter indicates the number of milliseconds the fading
    # will take.
    api :Mix_FadeOutChannel, [:int, :int], :int
    api :Mix_FadeOutGroup, [:int, :int], :int
    api :Mix_FadeOutMusic, [:int], :int

    ##
    # Query the fading status of a channel
    api :Mix_FadingMusic, [], :fading
    api :Mix_FadingChannel, [:int], :fading

    ##
    # Pause/Resume a particular channel
    api :Mix_Pause, [:int], :void
    api :Mix_Resume, [:int], :void
    api :Mix_Paused, [:int], :int

    ##
    # Pause/Resume the music stream
    api :Mix_PauseMusic, [], :void
    api :Mix_ResumeMusic, [], :void
    api :Mix_RewindMusic, [], :void
    api :Mix_PausedMusic, [], :int
    boolean? :paused_music, OK_WHEN_NOT_ZERO
    

    ##
    # Set the current position in the music stream.
    # This returns 0 if successful, or -1 if it failed or isn't implemented.
    # This function is only implemented for MOD music formats (set pattern
    # order number) and for OGG, FLAC, MP3_MAD, and MODPLUG music (set
    # position in seconds), at the moment.
    api :Mix_SetMusicPosition, [:double], :int

    ##
    # Check the status of a specific channel.
    # If the specified channel is -1, check all channels.
    api :Mix_Playing, [:int], :int
    boolean? :playing, OK_WHEN_ONE

    api :Mix_PlayingMusic, [], :int
    boolean? :playing_music, OK_WHEN_ONE

    ##
    # Stop music and set external music playback command
    api :Mix_SetMusicCMD, [:string], :int

    ##
    # Synchro value is set by MikMod from modules while playing
    api :Mix_SetSynchroValue, [:int], :int
    api :Mix_GetSynchroValue, [], :int

    ##
    # Set/Get/Iterate SoundFonts paths to use by supported MIDI backends
    api :Mix_SetSoundFonts, [:string], :int
    api :Mix_GetSoundFonts, [],:string
    callback :each_sound_font, [:string, :pointer], :int
    api :Mix_EachSoundFont, [:each_sound_font], :int

    ##
    # Get the Chunk currently associated with a mixer channel
    api :Mix_GetChunk, [:int], Chunk.by_ref

    ##
    # Close the mixer, halting all playing audio
    api :Mix_CloseAudio, [], :void

  end

  # Alias for constants like, ex: MIX_DEFAULT_FORMAT -> MIX::DEFAULT_FORMAT
  MIX = Mixer
  # Alias for method calls
  Mix = Mixer

end