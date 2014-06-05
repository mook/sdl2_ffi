require 'sdl2'

module SDL2

  # Joystick structure used to internally identify a joystick
  class Joystick < Struct

    # TODO: Review if the Joystick layout should be hidden.
    layout :hidden, :uint8

    def self.release(pointer)
      SDL2.joystick_close(pointer)
    end

  end

  # A structure that encodes the stable unique id for a joystick device
  class JoystickGUID < Struct
    layout :data, [:uint8, 16] #line 69
  end

  typedef :int32, :joystick_id
  typedef :int32, :joystick_index # Dunno

  ##
	#
	api :SDL_NumJoysticks, [], :int
  ##
	#
	api :SDL_JoystickNameForIndex, [:int], :string
  ##
	#
	api :SDL_JoystickOpen, [:int], Joystick.auto_ptr
  ##
	#
	api :SDL_JoystickName, [Joystick.by_ref], :string
  ##
	#
	api :SDL_JoystickGetDeviceGUID, [:int], JoystickGUID
  ##
	#
	api :SDL_JoystickGetGUID, [Joystick.by_ref], JoystickGUID
  ##
	#
	api :SDL_JoystickGetGUIDString, [JoystickGUID.by_value, :pointer, :int], :void
  ##
	#
	api :SDL_JoystickGetGUIDFromString, [:string], JoystickGUID
  ##
	#
	api :SDL_JoystickGetAttached, [Joystick.by_ref], :bool
  ##
	#
	api :SDL_JoystickInstanceID, [Joystick.by_ref], :joystick_id
  ##
	#
	api :SDL_JoystickNumAxes, [Joystick.by_ref], :int
  ##
	#
	api :SDL_JoystickNumBalls, [Joystick.by_ref], :int
  ##
	#
	api :SDL_JoystickNumHats, [Joystick.by_ref], :int
  ##
	#
	api :SDL_JoystickNumButtons, [Joystick.by_ref], :int
  ##
	#
	api :SDL_JoystickUpdate, [], :void
  ##
	#
	api :SDL_JoystickEventState, [:int], :int
  ##
	#
	api :SDL_JoystickGetAxis, [Joystick.by_ref, :int], :int16

  # Hat positions
  module HAT
    include EnumerableConstants
    CENTERED = 0x00
    UP = 0x01
    RIGHT =  0x02
    DOWN = 0x04
    LEFT = 0x08
    RIGHTUP = RIGHT | UP
    RIGHTDOWN = RIGHT | DOWN
    LEFTUP = LEFT | UP
    LEFTDOWN = LEFT | DOWN
  end

  ##
	#
	api :SDL_JoystickGetHat, [Joystick.by_ref, :int], :uint8
  ##
	#
	api :SDL_JoystickGetBall, [Joystick.by_ref, :int, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :int
  ##
	#
	api :SDL_JoystickGetButton, [Joystick.by_ref, :int], :uint8
  ##
	#
	api :SDL_JoystickClose, [Joystick.by_ref], :void
end