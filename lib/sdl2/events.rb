require 'sdl2'
require 'sdl2/error'
require 'sdl2/video'
require 'sdl2/keyboard'
require 'sdl2/mouse'
require 'sdl2/joystick'
require 'sdl2/gamecontroller'
require 'sdl2/gesture'
require 'sdl2/touch'
require 'sdl2/syswm/msg'

module SDL2
  ##
  # General keyboard/mouse released state
  RELEASED = 0
  ##
  # General keyboard/mouse pressed state
  PRESSED = 1
  ##
  # General Event UNION 
  class Event < Union; end
    
  ##
  # Enumerations:
  # - TYPE
  # - ACTION
  # - STATE
  class Event

    # The types of events that can be delivered
    module TYPE
      include EnumerableConstants
      FIRSTEVENT     = 0

      QUIT           = 0x100

      APP_TERMINATING           = next_const_value       
      APP_LOWMEMORY             = next_const_value
      APP_WILLENTERBACKGROUND   = next_const_value
      APP_DIDENTERBACKGROUND    = next_const_value
      APP_WILLENTERFOREGROUND   = next_const_value
      APP_DIDENTERFOREGROUND    = next_const_value

      WINDOWEVENT    = 0x200
      SYSWMEVENT     = next_const_value 

      KEYDOWN        = 0x300
      KEYUP          = next_const_value
      TEXTEDITING    = next_const_value
      TEXTINPUT      = next_const_value

      MOUSEMOTION    = 0x400
      MOUSEBUTTONDOWN= next_const_value
      MOUSEBUTTONUP  = next_const_value
      MOUSEWHEEL     = next_const_value

      JOYAXISMOTION  = 0x600
      JOYBALLMOTION  = next_const_value
      JOYHATMOTION   = next_const_value
      JOYBUTTONDOWN  = next_const_value
      JOYBUTTONUP    = next_const_value
      JOYDEVICEADDED = next_const_value
      JOYDEVICEREMOVED= next_const_value

      CONTROLLERAXISMOTION  = 0x650
      CONTROLLERBUTTONDOWN= next_const_value
      CONTROLLERBUTTONUP= next_const_value
      CONTROLLERDEVICEADDED= next_const_value
      CONTROLLERDEVICEREMOVED= next_const_value
      CONTROLLERDEVICEREMAPPED= next_const_value

      FINGERDOWN      = 0x700
      FINGERUP= next_const_value
      FINGERMOTION= next_const_value

      DOLLARGESTURE   = 0x800
      DOLLARRECORD= next_const_value
      MULTIGESTURE= next_const_value

      CLIPBOARDUPDATE = 0x900

      DROPFILE        = 0x1000

      USEREVENT    = 0x8000

      LASTEVENT    = 0xFFFF
    end

    ##
    #
    # Constants for use with SDL2::peep_events() as eventaction
    module ACTION
      include EnumerableConstants
      ##
      # Causes the creation of messages
      ADD = next_const_value
      ##
      # Retrieves events without removing them
      PEEK = next_const_value
      ##
      # Retrieves events and removes them
      GET = next_const_value
    end
    
    # Enumeration of event_state query
    module STATE
      include EnumerableConstants
      QUERY = -1
      IGNORE = 0
      DISABLE = 0
      ENABLE = 1
    end

  end
  
  enum :event_type, Event::TYPE.flatten_consts
  enum :eventaction, Event::ACTION.flatten_consts  
  ##
  # Structures
  # - Abstract
  #   - Common
  #   - Window
  #   - Keyboard
  #   - TextEditing
  #   - TextInput
  #   - MouseMotion
  #   - MouseButton
  #   - MouseWheel
  #   - JoyAxis--
  class Event
    class Abstract < Struct
      SHARED = [:type, :event_type, :timestamp, :uint32]

    end

    # Fields shared by every event
    class Common < Abstract

      layout *SHARED

    end

    # Window state change event data (event.window.*)
    class Window < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :event, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :data1, :int32,
        :data2, :int32
      ]
      member_readers *members
      member_writers *members
    end

    # Keyboard button event structure (event.key.*)
    class Keyboard < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :state, :uint8,
        :repeat, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :keysym, Keysym
      ]
      member_readers *members
      member_writers *members
    end

    # Keyboard text editing event structure (event.edit.*)
    class TextEditing < Abstract

      TEXT_SIZE = 32 # Line 188
      layout *SHARED + [
        :windowID, :uint32,
        :char, [:char, TEXT_SIZE],
        :start, :int32,
        :length, :int32
      ]
      member_readers *members
      member_writers *members
    end

    # Keyboard text input event structure (event.text.*)
    class TextInput < Abstract

      TEXT_SIZE = 32 # Line 203
      layout *SHARED + [
        :windowID, :uint32,
        :char, [:char, TEXT_SIZE]
      ]
      member_readers *members
      member_writers *members
    end

    # Mouse motion event structure (event.motion.*)
    class MouseMotion < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :which, :uint32,
        :state, :uint32,
        :x, :int32,
        :y, :int32,
        :xrel, :int32,
        :yrel, :int32
      ]
      member_readers *members
      member_writers *members
    end

    # Mouse button event structure (event.button.*)
    class MouseButton < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :which, :uint32,
        :button, :uint8,
        :state, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :x, :int32,
        :y, :int32
      ]
      member_readers *members
      member_writers *members
    end

    # Mouse wheel event structure (event.wheel.*)
    class MouseWheel < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :which, :uint32,
        :x, :int32,
        :y, :int32
      ]
      member_readers *members
      member_writers *members
    end

    # Joystick axis motion event structure (event.jaxis.*)
    class JoyAxis < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :axis, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :value, :int16,
        :padding4, :uint16
      ]
      member_readers *members
      member_writers *members
    end

    # Joystick trackball motion event structure (event.jball.*)
    class JoyBall < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :ball, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :xrel, :int16,
        :yrel, :int16
      ]
      member_readers *members
      member_writers *members
    end

    # Joystick hat position change event structure (event.jhat.*)
    class JoyHat < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :hat, :uint8,
        :value, :uint8,
        :padding1, :uint8,
        :padding2, :uint8
      ]
      member_readers *members
      member_writers *members
    end

    # Joystick button event structure (event.jbutton.*)
    class JoyButton < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :button, :uint8,
        :state, :uint8,
        :padding1, :uint8,
        :padding2, :uint8
      ]
      member_readers *members
      member_writers *members
    end

    # Joystick device event structure (event.jdevice.*)
    class JoyDevice < Abstract

      layout *SHARED + [
        :which, :joystick_id
      ]
      member_readers *members
      member_writers *members
    end

    # Game controller axis motion event structure (event.caxis.*)
    class ControllerAxis < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :axis, :uint8,
        :padding1, :uint8,
        :padding2, :uint8,
        :padding3, :uint8,
        :value, :int16,
        :padding4, :uint16
      ]
      member_readers *members
      member_writers *members
    end

    # Game controller button event structure (event.cbutton.*)
    class ControllerButton < Abstract

      layout *SHARED + [
        :which, :joystick_id,
        :button, :uint8,
        :state, :uint8,
        :padding1, :uint8,
        :padding2, :uint8
      ]
      member_readers *members
      member_writers *members
    end

    # Controller device event structure (event.cdevice.*)
    class ControllerDevice < Abstract

      layout *SHARED + [
        :which, :joystick_id
      ]
      member_readers *members
      member_writers *members
    end

    # Touch finger event structure (event.tfinger.*)
    class TouchFinger < Abstract

      layout *SHARED + [
        :touchId, :touch_id,
        :fingerId, :finger_id,
        :x, :float,
        :y, :float,
        :dx, :float,
        :dy, :float,
        :pressure, :float
      ]
      member_readers *members
      member_writers *members
    end

    # Multiple Finger Gesture Event (event.mgesture.*)
    class MultiGesture < Abstract

      layout *SHARED + [
        :touchId, :touch_id,
        :dTheta, :float,
        :dDist, :float,
        :x, :float,
        :y, :float,
        :numFingers, :uint16,
        :padding, :uint16
      ]
      member_readers *members
      member_writers *members
    end

    # Dollar Gesture Event (event.dgesture.*)
    class DollarGesture < Abstract

      layout *SHARED + [
        :touchId, :touch_id,
        :gestureId, :gesture_id,
        :numFingers, :uint32,
        :error, :float,
        :x, :float,
        :y, :float
      ]
      member_readers *members
      member_writers *members
    end

    # @brief An event used to request a file open by the system (event.drop.*)
    #        This event is disabled by default, you can enable it with
    # SDL_EventState()
    # @note If you enable this event, you must free the filename in the event.
    #
    class Drop < Abstract

      layout *SHARED + [
        :file, :string
      ]
      member_readers *members
      member_writers *members
    end

    # The "quit requested" event
    class Quit < Abstract

      layout *SHARED
      member_readers *members
      member_writers *members
    end

    # OS Specific event
    class OS < Abstract

      layout *SHARED
      member_readers *members
      member_writers *members
    end

    # A user-defined event type (event.user.*)
    class User < Abstract
      layout *SHARED + [
        :windowID, :uint32,
        :code, :int32,
        :data1, :pointer,
        :data2, :pointer
      ]
      member_readers *members
      member_writers *members
    end

    #  @brief A video driver dependent system event (event.syswm.*)
    #         This event is disabled by default, you can enable it with
    # SDL_EventState()
    #
    #  @note If you want to use this event, you should include SDL_syswm.h.
    class SysWM < Abstract
      layout *SHARED + [
        :msg, SDL2::SysWM::Msg.by_ref
      ]
    end

    layout :type, :event_type,
    :common, Common,
    :window, Window,
    :key, Keyboard,
    :edit, TextEditing,
    :text, TextInput,
    :motion, MouseMotion,
    :button, MouseButton,
    :wheel, MouseWheel,
    :jaxis, JoyAxis,
    :jball, JoyBall,
    :jbutton, JoyButton,
    :jdevice, JoyDevice,
    :caxis, ControllerAxis,
    :cbutton, ControllerButton,
    :cdevice, ControllerDevice,
    :quit, Quit,
    :user, User,
    :syswm, SysWM,
    :tfinger, TouchFinger,
    :mgesture, MultiGesture,
    :drop, Drop,
    :padding, [:uint8, 56] # From SDL_events.h:529

    member_readers *members
    member_writers *members
    
    ##
    # Polls for currently pending events.
    # @returns SDL2::Event or nil if there are no events.
    def self.poll()
      tmp_event = SDL2::Event.new
      unless SDL2.poll_event?(tmp_event)
        tmp_event.pointer.free
        tmp_event = nil
      end
      return tmp_event # May be nil if SDL2.poll_event fails.
    end

    
    def self.push(event)
      event = Event.cast(event) unless event.kind_of? Event
      SDL2.push_event!(event)
    end

    def self.cast(something)
      if something.kind_of? Abstract
        return self.new(something.pointer)
      elsif something.kind_of? Hash
        raise "Must have type : #{something.inspect}" unless something.has_key? :type
        tmp = self.new
        fields = members & something.keys
        fields.each do |field|
          if tmp[field].kind_of? Struct and something[field].kind_of? Hash
            tmp[field].update_members(something[field])
          else
            tmp[field] = something[field]
          end
        end
        return tmp
      else
        raise "Is not an Abstract!: #{something.inspect}"
      end
    end

    def ==(other)
      if other.kind_of?(Hash)
        # False if there are fields that do not exist
        return false unless (other.keys - members).empty?

        (other.keys & members).each do |field|
          return false unless self[field] == other[field]
        end

        return true #if we get this far

      else

        return super(other)

      end
    end

  end



  ##
  # :class-method: peep_events
  ##
  #
  api :SDL_PeepEvents, [Event.by_ref, :count, :eventaction, :uint32, :uint32], :int
  ##
  #
  api :SDL_HasEvent, [:uint32], :bool
  ##
  #
  api :SDL_HasEvents, [:uint32, :uint32], :bool
  ##
  #
  api :SDL_FlushEvent, [:uint32], :void
  ##
  #
  api :SDL_FlushEvents, [:uint32, :uint32], :void
  ##
  #
  api :SDL_PollEvent, [Event.by_ref], :int
  boolean? :poll_event, TRUE_WHEN_ONE
  ##
  #
  api :SDL_WaitEvent, [Event.by_ref], :int
  ##
  #
  api :SDL_WaitEventTimeout, [Event.by_ref, :count], :int
  ##
  #
  api :SDL_PushEvent, [Event.by_ref], :int, {error: true, filter: TRUE_WHEN_ONE}

  ##
  # callback event_filter #=> Proc.new do |pointer, event|; return int; end
  callback :event_filter, [:pointer, Event.by_ref], :int

  # This simple structure is used for getting the event filter
  class EventFilterStruct < Struct
    layout :callback, :event_filter
  end

  ##
  #
  api :SDL_SetEventFilter, [:event_filter, :pointer], :void
  ##
  #
  api :SDL_GetEventFilter, [:pointer, :pointer], :bool
  ##
  #
  api :SDL_AddEventWatch, [:event_filter, :pointer], :void
  ##
  #
  api :SDL_DelEventWatch, [:event_filter, :pointer], :void
  ##
  #
  api :SDL_FilterEvents, [:event_filter, :pointer], :void



  enum :event_state, Event::STATE.flatten_consts

  ##
  #
  ##
  #
  api :SDL_EventState, [:uint32, :event_state], :uint8

  def get_event_state(type)
    event_state(type, EVENTSTATE::QUERY)
  end

  ##
  #
  api :SDL_RegisterEvents, [:count], :uint32
end