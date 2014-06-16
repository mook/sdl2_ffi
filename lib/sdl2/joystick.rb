require 'sdl2'

module SDL2
  ##
  # TODO: == Joystick Overview ==
  class Joystick < Struct    
    # TODO: Review if the Joystick layout should be hidden.
    layout :hidden, :uint8
    def self.release(pointer)
      SDL2.joystick_close(pointer)
    end    
    ##
    # Returns the number of attached joysticks on success or a
    # exception on failure
    def self.num
      SDL2.num_joysticks!
    end    
    ##
    # Returns a joystick identifier or raises exception on error    
    def self.open(idx)      
      SDL2.joystick_open!(idx)
    end
    ##
    # Returns the name of a joystick
    def self.name(idx)
      SDL2.joystick_name_for_index!(idx)
    end    
    ##
    # update the current state of open joysticks
    def self.update()
      SDL2.joystick_update()
    end    
    ##
    # Returns the name of the joystick
    def name()
      SDL2.joystick_name(self)
    end        
    ##
    # Enumerator for Axes
    def axes
      @axes ||= Axes.new(self)
    end
    autoload(:Axes, 'sdl2/joystick/axes')    
    ##
    # Enumerator for balls
    def balls
      @balls ||= Balls.new(self)
    end
    autoload(:Balls, 'sdl2/joystick/balls')    
    ##
    # Enumerator for buttons
    def buttons
      @buttons ||= Buttons.new(self)
    end
    autoload(:Buttons, 'sdl2/joystick/buttons')    
    ##
    # Enumerator for hats
    def hats
      @hats ||= Hats.new(self)
    end
    autoload(:Hats, 'sdl2/joystick/hats')
    ##
    # Get the device index of an opened joystick
    def instance_id()
      SDL2.joystick_instance_id!(self)
    end    
    ##
    # Get the GUID
    def get_guid()
      SDL2.joystick_get_guid!(self)
    end
    ##
    # Event state
    # @param - state 
    #   == SDL2::Event::STATE::QUERY [default]: Returns current state
    #   == SDL2::Event::STATE::IGNORE : Disables event dispatching
    #   == SDL2::Event::STATE::ENABLE : Enables event dispatching
    # @returns - true if events enabled
    def event_state(state = SDL2::Event::STATE::QUERY)
      SDL2.joystick_event_state(state)
    end    
    
  end

  # A structure that encodes the stable unique id for a joystick device
  class JoystickGUID < Struct
    layout :data, [:uint8, 16] #line 69
  end

  typedef :int32, :joystick_id
  typedef :int32, :joystick_index # Dunno

  api :SDL_NumJoysticks, [], :int, {error: true, filter: OK_WHEN_GTE_ZERO}
  api :SDL_JoystickNameForIndex, [:int], :string, {error: true, filter: OK_WHEN_NOT_NULL}
  api :SDL_JoystickOpen, [:int], Joystick.ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  api :SDL_JoystickName, [Joystick.by_ref], :string
  api :SDL_JoystickGetDeviceGUID, [:int], JoystickGUID.ptr
  api :SDL_JoystickGetGUID, [Joystick.by_ref], JoystickGUID.ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  api :SDL_JoystickGetGUIDString, [JoystickGUID.by_value, :pointer, :int], :void
  api :SDL_JoystickGetGUIDFromString, [:string], JoystickGUID.ptr
  api :SDL_JoystickGetAttached, [Joystick.by_ref], :bool
  api :SDL_JoystickInstanceID, [Joystick.by_ref], :joystick_id, {error: true, filter: OK_WHEN_GTE_ZERO}
  api :SDL_JoystickNumAxes, [Joystick.by_ref], :int, {error: true, filter: OK_WHEN_GTE_ZERO}
  api :SDL_JoystickNumBalls, [Joystick.by_ref], :int, {error: true, filter: OK_WHEN_GTE_ZERO}
  api :SDL_JoystickNumHats, [Joystick.by_ref], :int, {error: true, filter: OK_WHEN_GTE_ZERO}
  api :SDL_JoystickNumButtons, [Joystick.by_ref], :int, {error: true, filter: OK_WHEN_GTE_ZERO}
  api :SDL_JoystickUpdate, [], :void
  api :SDL_JoystickEventState, [:int], :bool
  api :SDL_JoystickGetAxis, [Joystick.by_ref, :int], :int16, {error: true, filter: OK_WHEN_NOT_ZERO}

  # Hat positions
  module HAT
    include EnumerableConstants
    CENTERED    = 0x00
    UP          = 0x01
    RIGHT       = 0x02
    DOWN        = 0x04
    LEFT        = 0x08
    RIGHTUP     = RIGHT |  UP
    RIGHTDOWN   = RIGHT | DOWN
    LEFTUP      = LEFT  |  UP
    LEFTDOWN    = LEFT  | DOWN
  end

  api :SDL_JoystickGetHat, [Joystick.by_ref, :int], :uint8
  api :SDL_JoystickGetBall, [Joystick.by_ref, :int, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  api :SDL_JoystickGetButton, [Joystick.by_ref, :int], :uint8
  api :SDL_JoystickClose, [Joystick.by_ref], :void
end