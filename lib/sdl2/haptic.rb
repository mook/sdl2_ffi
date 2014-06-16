require 'sdl2'
require 'sdl2/joystick'

module SDL2

  class Haptic < Struct

    # Different haptic features a device can have
    module FEATURES
      include EnumerableConstants
      # Constant haptic effect
      CONSTANT=  (1<<0)
      # Periodic haptic effect that simulates sine waves.
      SINE= (1<<1)
      # Haptic effect for direct control over high/low frequency motors.
      LEFTRIGHT= (1<<2)
      # Peridodic haptic effect that simulates triangular waves.
      TRIANGLE= (1<<3)
      # Periodic haptic effect that simulates saw tooth up waves.
      SAWTOOTHUP= (1<<4)
      # Periodic haptic effect that simulates saw tooth down waves.
      SAWTOOTHDOWN= (1<<5)
      # Ramp haptic effect
      RAMP= (1<<6)
      # Condition haptic effect that simulates a spring. Effect is based on axes
      # position.
      SPRING= (1<<7)
      # Condition haptic effect that simulates dampening.  Effect is based on the
      # axes velocity.
      DAMPER= (1<<8)
      # Condition haptic effect that simulates inertia.  Effect is based on the
      # axes acceleration.
      INERTIA= (1<<9)
      # Condition haptic effect that simulates friction.  Effect is based on the
      # axes movement.
      FRICTION= (1<<10)
      # Custom effect is supported.
      CUSTOM= (1<<11)
      # Device supports setting the global gain.
      GAIN= (1<<12)
      # Device supports setting autocenter
      AUTOCENTER= (1<<13)
      # Device can be queried for effect status
      STATUS= (1<<14)
      # Device can be paused
      PAUSE= (1<<15)
    end

    # Direction encodings
    module DIRECTION
      include EnumerableConstants
      # Uses polar coordinates for the direction.
      POLAR= 0
      # Uses cartesian coordinates for the direction.
      CARTESIAN= 1
      # Uses spherical coordinates for the direction.
      SPHERICAL= 2
    end

    # So that they can be accessed by: SDL2::Haptic::XXXXX, emulating
    # SDL_HAPTIC_XXXX
    include FEATURES
    include DIRECTION

    # Used to play a device an infinite number of times.
    # TODO: Review if this works.
    INFINITY = 4294967295

    # Structure that represents a haptic direction.
    # The following was copied directly from SDL_haptic.h, v2.0.0 and
    # translated by BadQuanta into Ruby code using sdl2_ffi.    
    #       Directions can be specified by:
    #        - SDL2::Haptic::POLAR : Specified by polar coordinates.
    #        - SDL2::Haptic::CARTESIAN : Specified by cartesian coordinates.
    #        - SDL2::Haptic::SPHERICAL : Specified by spherical coordinates.
    #
    #       Cardinal directions of the haptic device are relative to the positioning
    #       of the device.  North is considered to be away from the user.
    #
    #       The following diagram represents the cardinal directions:
    #       \verbatim
    #                    .--.
    #                    |__| .-------.
    #                    |=.| |.-----.|
    #                    |--| ||     ||
    #                    |  | |'-----'|
    #                    |__|~')_____('
    #                      [ COMPUTER ]
    #
    #
    #                        North (0,-1)
    #                            ^
    #                            |
    #                            |
    #       (1,0)  West <----[ HAPTIC ]----> East (-1,0)
    #                            |
    #                            |
    #                            v
    #                         South (0,1)
    #
    #
    #                         [ USER ]
    #                           \|||/
    #                           (o o)
    #                     ---ooO-(_)-Ooo---
    #       \endverbatim
    #
    #       If type is SDL::Haptic::POLAR, direction is encoded by hundredths of a
    #       degree starting north and turning clockwise.  SDL::Haptic::POLAR only uses
    #       the first \c dir parameter.  The cardinal directions would be:
    #        - North: 0 (0 degrees)
    #        - East: 9000 (90 degrees)
    #        - South: 18000 (180 degrees)
    #        - West: 27000 (270 degrees)
    #
    #       If type is SDL::Haptic::CARTESIAN, direction is encoded by three positions
    #       (X axis, Y axis and Z axis (with 3 axes)).  SDL::Haptic::CARTESIAN uses
    #       the first three \c dir parameters.  The cardinal directions would be:
    #        - North:  0,-1, 0
    #        - East:  -1, 0, 0
    #        - South:  0, 1, 0
    #        - West:   1, 0, 0
    #
    #       The Z axis represents the height of the effect if supported, otherwise
    #       it's unused.  In cartesian encoding (1, 2) would be the same as (2, 4), you
    #       can use any multiple you want, only the direction matters.
    #
    #       If type is SDL::Haptic::SPHERICAL, direction is encoded by two rotations.
    #       The first two \c dir parameters are used.  The \c dir parameters are as
    #       follows (all values are in hundredths of degrees):
    #        - Degrees from (1, 0) rotated towards (0, 1).
    #        - Degrees towards (0, 0, 1) (device needs at least 3 axes).
    #
    #
    #       Example of force coming from the south with all encodings (force coming
    #       from the south means the user will have to pull the stick to counteract):
    #
    #       @code
    #
    #       direction = SDL2::Haptic::Direction.new
    #
    #        # Cartesian directions
    #        direction.type = SDL2::Haptic::CARTESIAN # Using cartesian direction encoding.
    #        direction.dir[0] = 0 # X position
    #        direction.dir[1] = 1 # Y position
    #
    #        # Polar directions
    #        direction.type = SDL2::Haptic::POLAR #We'll be using polar direction encoding.
    #        direction.dir[0] = 18000 # Polar only uses first parameter
    #
    #        # Spherical coordinates
    #        direction.type = SDL2::Haptic::SPHERICAL # Spherical encoding
    #        direction.dir[0] = 9000 # Since we only have two axes we don't need more parameters
    #
    #       @code
    #
    #
    #       \sa SDL_HAPTIC_POLAR
    #       \sa SDL_HAPTIC_CARTESIAN
    #       \sa SDL_HAPTIC_SPHERICAL
    #       \sa SDL_HapticEffect
    #       \sa SDL_HapticNumAxes
    # END OF SOMETHING COPIED AND PASTED FROM SDL_haptic.h !!!!!!!!!!!!!!!!!
    class Direction < Struct
      layout :type, :uint8,
      :dir, [:int32, 3] # Magic #3 form line 442
        
      member_readers *members # Read all      
      member_writers *members # Write all
    end

    # Identical starting elements shared between structures.
    # You can ignore this constant.
    COMMON_LAYOUT = [:type, :uint16,
      :direction, Direction,

      :length, :uint32,
      :delay, :uint16,

      :button, :uint16,
      :interval, :uint16
    ]

    # Identical ending elements shared between structures.
    # You can ignore this constant.
    COMMON_ENVELOPE = [
      :attack_length, :uint16,
      :attack_level, :uint16,
      :fade_length, :uint16,
      :fade_level, :uint16
    ]
    #  The struct is exclusive to the CONSTANT effect.
    #
    #  A constant effect applies a constant force in the specified direction
    #  to the joystick.
    class Constant < Struct
      layout *COMMON_LAYOUT+[
        :level, :int16
      ] + COMMON_ENVELOPE
    end

# A structure containing a template for a Periodic effect.
#     
# The struct handles the following effects:
#  -  SDL2::Haptic::SINE
#  -  SDL2::Haptic::LEFTRIGHT
#  -  SDL2::Haptic::TRIANGLE
#  -  SDL2::Haptic::SAWTOOTHUP
#  -  SDL2::Haptic::SAWTOOTHDOWN
# 
# A periodic effect consists in a wave-shaped effect that repeats itself
# over time.  The type determines the shape of the wave and the parameters
# determine the dimensions of the wave.
# 
# Phase is given by hundredth of a cycle meaning that giving the phase a value
# of 9000 will displace it 25% of its period.  Here are sample values:
#  -     0: No phase displacement.
#  -  9000: Displaced 25% of its period.
#  - 18000: Displaced 50% of its period.
#  - 27000: Displaced 75% of its period.
#  - 36000: Displaced 100% of its period, same as 0, but 0 is preferred.
# 
# Examples:
#
#       SDL_HAPTIC_SINE
#         __      __      __      __
#        /  \    /  \    /  \    /
#       /    \__/    \__/    \__/
#   
#       SDL_HAPTIC_SQUARE
#        __    __    __    __    __
#       |  |  |  |  |  |  |  |  |  |
#       |  |__|  |__|  |__|  |__|  |
#   
#       SDL_HAPTIC_TRIANGLE
#         /\    /\    /\    /\    /\
#        /  \  /  \  /  \  /  \  /
#       /    \/    \/    \/    \/
#   
#       SDL_HAPTIC_SAWTOOTHUP
#         /|  /|  /|  /|  /|  /|  /|
#        / | / | / | / | / | / | / |
#       /  |/  |/  |/  |/  |/  |/  |
#   
#       SDL_HAPTIC_SAWTOOTHDOWN
#       \  |\  |\  |\  |\  |\  |\  |
#        \ | \ | \ | \ | \ | \ | \ |
#         \|  \|  \|  \|  \|  \|  \|
#     
# @sa SDL_HAPTIC_SINE
# @sa SDL_HAPTIC_LEFTRIGHT
# @sa SDL_HAPTIC_TRIANGLE
# @sa SDL_HAPTIC_SAWTOOTHUP
# @sa SDL_HAPTIC_SAWTOOTHDOWN
# @sa SDL_HapticEffect
    class Periodic < Struct
      layout *COMMON_LAYOUT+[
        :period, :uint16,
        :magnitude, :int16,
        :offset, :int16,
        :phase, :uint16,
      ]+COMMON_ENVELOPE
    end
    #  \brief A structure containing a template for a Condition effect.
    #
    #  The struct handles the following effects:
    #   - SDL2::Haptic::SPRING: Effect based on axes position.
    #   - SDL2::Haptic::DAMPER: Effect based on axes velocity.
    #   - SDL2::Haptic::INERTIA: Effect based on axes acceleration.
    #   - SDL2::Haptic::FRICTION: Effect based on axes movement.
    #
    #  Direction is handled by condition internals instead of a direction member.
    #  The condition effect specific members have three parameters.  The first
    #  refers to the X axis, the second refers to the Y axis and the third
    #  refers to the Z axis.  The right terms refer to the positive side of the
    #  axis and the left terms refer to the negative side of the axis.  Please
    #  refer to the ::SDL2::Haptic::Direction diagram for which side is positive and
    #  which is negative.
    #
    #  \sa SDL2::Haptic::Direction
    #  \sa SDL_HAPTIC_SPRING
    #  \sa SDL_HAPTIC_DAMPER
    #  \sa SDL_HAPTIC_INERTIA
    #  \sa SDL_HAPTIC_FRICTION
    #  \sa SDL_HapticEffect
    class Condition < Struct
      layout *COMMON_LAYOUT+[
        :right_sat, [:uint16, 3],
        :left_sat, [:uint16, 3],
        :right_coeff, [:int16, 3],
        :left_coeff, [:int16, 3],
        :deadband, [:uint16, 3],
        :center, [:int16, 3]
      ]
    end
    
    #  \brief A structure containing a template for a Ramp effect.
    #
    #  This struct is exclusively for the ::SDL_HAPTIC_RAMP effect.
    #
    #  The ramp effect starts at start strength and ends at end strength.
    #  It augments in linear fashion.  If you use attack and fade with a ramp
    #  the effects get added to the ramp effect making the effect become
    #  quadratic instead of linear.
    #
    #  \sa SDL_HAPTIC_RAMP
    #  \sa SDL_HapticEffect
    class Ramp < Struct
      layout *COMMON_LAYOUT+[
        :start, :int16,
        :'end', :int16,
      ]+COMMON_ENVELOPE
    end

    # \brief A structure containing a template for a Left/Right effect.
    #
    # This struct is exclusively for the ::SDL_HAPTIC_LEFTRIGHT effect.
    #
    # The Left/Right effect is used to explicitly control the large and small
    # motors, commonly found in modern game controllers. One motor is high
    # frequency, the other is low frequency.
    #
    # \sa SDL_HAPTIC_LEFTRIGHT
    # \sa SDL_HapticEffect
    class LeftRight < Struct
      layout :type, :uint16,
      :length, :uint32,
      :large_magnitude, :uint16,
      :small_magnitude, :uint16
    end
    #  \brief A structure containing a template for the ::SDL_HAPTIC_CUSTOM effect.
    #
    #  A custom force feedback effect is much like a periodic effect, where the
    #  application can define its exact shape.  You will have to allocate the
    #  data yourself.  Data should consist of channels # samples Uint16 samples.
    #
    #  If channels is one, the effect is rotated using the defined direction.
    #  Otherwise it uses the samples in data for the different axes.
    #
    #  \sa SDL_HAPTIC_CUSTOM
    #  \sa SDL_HapticEffect
    class Custom < Struct
      layout *COMMON_LAYOUT+[
        :channels, :uint8,
        :period, :uint16,
        :samples, :uint16,
        :data, :pointer,
      ]+COMMON_ENVELOPE
    end

    #  \brief The generic template for any haptic effect.
    #
    #  All values max at 32767 (0x7FFF).  Signed values also can be negative.
    #  Time values unless specified otherwise are in milliseconds.
    #
    #  You can also pass ::SDL_HAPTIC_INFINITY to length instead of a 0-32767
    #  value.  Neither delay, interval, attack_length nor fade_length support
    #  ::SDL_HAPTIC_INFINITY.  Fade will also not be used since effect never ends.
    #
    #  Additionally, the ::SDL_HAPTIC_RAMP effect does not support a duration of
    #  ::SDL_HAPTIC_INFINITY.
    #
    #  Button triggers may not be supported on all devices, it is advised to not
    #  use them if possible.  Buttons start at index 1 instead of index 0 like
    #  the joystick.
    #
    #  If both attack_length and fade_level are 0, the envelope is not used,
    #  otherwise both values are used.
    #
    #  Common parts:
    #  \code
    #  // Replay - All effects have this
    #  Uint32 length;        // Duration of effect (ms).
    #  Uint16 delay;         // Delay before starting effect.
    #
    #  // Trigger - All effects have this
    #  Uint16 button;        // Button that triggers effect.
    #  Uint16 interval;      // How soon before effect can be triggered again.
    #
    #  // Envelope - All effects except condition effects have this
    #  Uint16 attack_length; // Duration of the attack (ms).
    #  Uint16 attack_level;  // Level at the start of the attack.
    #  Uint16 fade_length;   // Duration of the fade out (ms).
    #  Uint16 fade_level;    // Level at the end of the fade.
    #  \endcode
    #
    #
    #  Here we have an example of a constant effect evolution in time:
    #  \verbatim
    #       Strength
    #       ^
    #       |
    #       |    effect level -->  _________________
    #       |                     /                 \
    #       |                    /                   \
    #       |                   /                     \
    #       |                  /                       \
    #       | attack_level --> |                        \
    #       |                  |                        |  <---  fade_level
    #       |
    #       +--------------------------------------------------> Time
    #                          [--]                 [---]
    #                          attack_length        fade_length
    #
    #       [------------------][-----------------------]
    #       delay               length
    #       \endverbatim
    #
    #  Note either the attack_level or the fade_level may be above the actual
    #  effect level.
    #
    #  \sa SDL_HapticConstant
    #  \sa SDL_HapticPeriodic
    #  \sa SDL_HapticCondition
    #  \sa SDL_HapticRamp
    #  \sa SDL_HapticLeftRight
    #  \sa SDL_HapticCustom
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
    
    # Free pointer associated with a haptic structure
    def self.release(pointer)
      SDL2.haptic_close(pointer)
    end

  end

  ##
  # Get the number of haptics?
  ##
	#
	api :SDL_NumHaptics, [], :int
  ##
	#
	api :SDL_HapticName, [:int], :string
  ##
	#
	api :SDL_HapticOpen, [:int], Haptic.ptr
  ##
	#
	api :SDL_HapticOpened, [:int], :int
  ##
	#
	api :SDL_HapticIndex, [Haptic.by_ref], :int
  ##
	#
	api :SDL_MouseIsHaptic, [], :int
  ##
	#
	api :SDL_HapticOpenFromMouse, [], Haptic.ptr
  ##
	#
	api :SDL_JoystickIsHaptic, [Joystick.by_ref], :int
  ##
	#
	api :SDL_HapticOpenFromJoystick, [Joystick.by_ref], Haptic.ptr
  ##
	#
	api :SDL_HapticClose, [Haptic.by_ref], :void
  ##
	#
	api :SDL_HapticNumEffects, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticNumEffectsPlaying, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticQuery, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticNumAxes, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticEffectSupported, [Haptic.by_ref, Haptic::Effect.by_ref], :int
  ##
	#
	api :SDL_HapticNewEffect, [Haptic.by_ref, Haptic::Effect.by_ref], :int
  ##
	#
	api :SDL_HapticUpdateEffect, [Haptic.by_ref, :int, Haptic::Effect.by_ref], :int
  ##
	#
	api :SDL_HapticRunEffect, [Haptic.by_ref, :int, :uint32], :int
  ##
	#
	api :SDL_HapticStopEffect, [Haptic.by_ref, :int], :int
  ##
	#
	api :SDL_HapticDestroyEffect, [Haptic.by_ref, :int], :int
  ##
	#
	api :SDL_HapticGetEffectStatus, [Haptic.by_ref, :int], :int
  ##
	#
	api :SDL_HapticSetGain, [Haptic.by_ref, :int], :int
  ##
	#
	api :SDL_HapticSetAutocenter, [Haptic.by_ref, :int], :int
  ##
	#
	api :SDL_HapticPause, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticUnpause, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticStopAll, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticRumbleSupported, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticRumbleInit, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticRumblePlay, [Haptic.by_ref], :int
  ##
	#
	api :SDL_HapticRumbleStop, [Haptic.by_ref], :int

end