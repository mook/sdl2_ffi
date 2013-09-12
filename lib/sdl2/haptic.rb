require 'sdl2'
require 'sdl2/joystick'
require 'yinum'

module SDL2

  class Haptic < Struct
    Features = Enum.new(:HapticFeatures, {
      CONSTANT:  (1<<0),
      SINE: (1<<1),
      LEFTRIGHT: (1<<2),
      TRIANGLE: (1<<3),
      SAWTOOTHUP: (1<<4),
      SAWTOOTHDOWN: (1<<5),
      RAMP: (1<<6),
      SPRING: (1<<7),
      DAMPER: (1<<8),
      INERTIA: (1<<9),
      FRICTION: (1<<10),
      CUSTOM: (1<<11),
      GAIN: (1<<12),
      AUTOCENTER: (1<<13),
      STATUS: (1<<14),
      PAUSE: (1<<15)
    })

    DirectionType = Enum.new(:HapticDirectionType, {
      POLAR: 0,
      CARTESIAN: 1,
      SPHERICAL: 2
    })
        

    RunEffect = Enum.new(:HapticRunEffect, {
      INFINITY: 4294967295
    })

    class Direction < Struct
      layout :type, :uint8,
      :dir, [:int32, 3] # Magic #3 form line 442
    end

    COMMON_LAYOUT = [:type, :uint16,
      :direction, Direction,

      :length, :uint32,
      :delay, :uint16,

      :button, :uint16,
      :interval, :uint16
    ]

    COMMON_ENVELOPE = [
      :attack_length, :uint16,
      :attack_level, :uint16,
      :fade_length, :uint16,
      :fade_level, :uint16
    ]

    class Constant < Struct
      layout *COMMON_EVENT_LAYOUT+[
        :level, :int16
      ] + COMMON_ENVELOPE
    end

    class Periodic < Struct
      layout *COMMON_EVENT_LAYOUT+[
        :period, :uint16,
        :magnitude, :int16,
        :offset, :int16,
        :phase, :uint16,
      ]+COMMON_ENVELOPE
    end

    class Condition < Struct
      layout *COMMON_EVENT_LAYOUT+[
        :right_sat, [:uint16, 3],
        :left_sat, [:uint16, 3],
        :right_coeff, [:int16, 3],
        :left_coeff, [:int16, 3],
        :deadband, [:uint16, 3],
        :center, [:int16, 3]
      ]
    end

    class Ramp < Struct
      layout *COMMON_EVENT_LAYOUT+[
        :start, :int16,
        :'end', :int16,        
      ]+COMMON_ENVELOPE
    end
    
    class LeftRight < Struct
      layout :type, :uint16,
        :length, :uint32,        
        :large_magnitude, :uint16,
        :small_magnitude, :uint16
    end
    
    class Custom < Struct
      layout *COMMON_EVENT_LAYOUT+[
        :channels, :uint8,
        :period, :uint16,
        :samples, :uint16,
        :data, :pointer,        
      ]+COMMON_ENVELOPE
    end
    
    class Effect < FFI::Union
      layout :type, :uint16,
        :constant, Constant,
        :periodic, Periodic,
        :condition, Condition,
        :ramp, Ramp,
        :leftright, LeftRight,
        :custom, Custom
    end
    
    # Haptic
    def self.release(pointer)
      SDL2.haptic_close(pointer)
    end

  end
  
  

  api :SDL_NumHaptics, [], :int
  api :SDL_HapticName, [:int], :string
  api :SDL_HapticOpen, [:int], Haptic.auto_ptr
  api :SDL_HapticOpened, [:int], :int
  api :SDL_HapticIndex, [Haptic.by_ref], :int
  api :SDL_MouseIsHaptic, [], :int
  api :SDL_HapticOpenFromMouse, [], Haptic.auto_ptr
  api :SDL_JoystickIsHaptic, [Joystick.by_ref], :int
  api :SDL_HapticOpenFromJoystick, [Joystick.by_ref], Haptic.auto_ptr
  api :SDL_HapticClose, [Haptic.by_ref], :void
  api :SDL_HapticNumEffects, [Haptic.by_ref], :int
  api :SDL_HapticNumEffectsPlaying, [Haptic.by_ref], :int
  api :SDL_HapticQuery, [Haptic.by_ref], :int
  api :SDL_HapticNumAxes, [Haptic.by_ref], :int
  api :SDL_HapticEffectSupported, [Haptic.by_ref, Haptic::Effect.by_ref], :int
  api :SDL_HapticNewEffect, [Haptic.by_ref, Haptic::Effect.by_ref], :int
  api :SDL_HapticUpdateEffect, [Haptic.by_ref, :int, Haptic::Effect.by_ref], :int
  api :SDL_HapticRunEffect, [Haptic.by_ref, :int, :uint32], :int
  api :SDL_HapticStopEffect, [Haptic.by_ref, :int], :int
  api :SDL_HapticDestroyEffect, [Haptic.by_ref, :int], :int
  api :SDL_HapticGetEffectStatus, [Haptic.by_ref, :int], :int
  api :SDL_HapticSetGain, [Haptic.by_ref, :int], :int
  api :SDL_HapticSetAutocenter, [Haptic.by_ref, :int], :int
  api :SDL_HapticPause, [Haptic.by_ref], :int
  api :SDL_HapticUnpause, [Haptic.by_ref], :int
  api :SDL_HapticStopAll, [Haptic.by_ref], :int
  api :SDL_HapticRumbleSupported, [Haptic.by_ref], :int
  api :SDL_HapticRumbleInit, [Haptic.by_ref], :int
  api :SDL_HapticRumblePlay, [Haptic.by_ref], :int
  api :SDL_HapticRumbleStop, [Haptic.by_ref], :int
  
end