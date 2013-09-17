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

  RELEASED = 0
  PRESSED = 1

  # The types of events that can be delivered
  module EVENTTYPE
    include EnumerableConstants
    FIRSTEVENT     = 0

    QUIT           = 0x100

    APP_TERMINATING
    APP_LOWMEMORY
    APP_WILLENTERBACKGROUND
    APP_DIDENTERBACKGROUND
    APP_WILLENTERFOREGROUND
    APP_DIDENTERFOREGROUND

    WINDOWEVENT    = 0x200
    SYSWMEVENT

    KEYDOWN        = 0x300
    KEYUP
    TEXTEDITING
    TEXTINPUT

    MOUSEMOTION    = 0x400
    MOUSEBUTTONDOWN
    MOUSEBUTTONUP
    MOUSEWHEEL

    JOYAXISMOTION  = 0x600
    JOYBALLMOTION
    JOYHATMOTION
    JOYBUTTONDOWN
    JOYBUTTONUP
    JOYDEVICEADDED
    JOYDEVICEREMOVED

    CONTROLLERAXISMOTION  = 0x650
    CONTROLLERBUTTONDOWN
    CONTROLLERBUTTONUP
    CONTROLLERDEVICEADDED
    CONTROLLERDEVICEREMOVED
    CONTROLLERDEVICEREMAPPED

    FINGERDOWN      = 0x700
    FINGERUP
    FINGERMOTION

    DOLLARGESTURE   = 0x800
    DOLLARRECORD
    MULTIGESTURE

    CLIPBOARDUPDATE = 0x900

    DROPFILE        = 0x1000

    USEREVENT    = 0x8000

    LASTEVENT    = 0xFFFF
  end

  enum :event_type, EVENTTYPE.flatten_consts

  class AbstractEvent < Struct
    SHARED = [:type, :uint32, :timestamp, :uint32]
  end

  # Fields shared by every event
  class CommonEvent < AbstractEvent

    layout *SHARED
  end

  # Window state change event data (event.window.*)
  class WindowEvent < AbstractEvent

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
  class KeyboardEvent < AbstractEvent

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
  class TextEditingEvent < AbstractEvent

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
  class TextInputEvent < AbstractEvent

    TEXT_SIZE = 32 # Line 203
    layout *SHARED + [
      :windowID, :uint32,
      :char, [:char, TEXT_SIZE]
    ]
    member_readers *members
    member_writers *members
  end

  # Mouse motion event structure (event.motion.*)
  class MouseMotionEvent < AbstractEvent

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
  class MouseButtonEvent < AbstractEvent

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
  class MouseWheelEvent < AbstractEvent

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
  class JoyAxisEvent < AbstractEvent

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
  class JoyBallEvent < AbstractEvent

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
  class JoyHatEvent < AbstractEvent

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
  class JoyButtonEvent < AbstractEvent

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
  class JoyDeviceEvent < AbstractEvent

    layout *SHARED + [
      :which, :joystick_id
    ]
    member_readers *members
    member_writers *members
  end

  # Game controller axis motion event structure (event.caxis.*)
  class ControllerAxisEvent < AbstractEvent

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
  class ControllerButtonEvent < AbstractEvent

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
  class ControllerDeviceEvent < AbstractEvent

    layout *SHARED + [
      :which, :joystick_id
    ]
    member_readers *members
    member_writers *members
  end

  # Touch finger event structure (event.tfinger.*)
  class TouchFingerEvent < AbstractEvent

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
  class MultiGestureEvent < AbstractEvent

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
  class DollarGestureEvent < AbstractEvent

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
  class DropEvent < AbstractEvent

    layout *SHARED + [
      :file, :string
    ]
    member_readers *members
    member_writers *members
  end

  # The "quit requested" event
  class QuitEvent < AbstractEvent

    layout *SHARED
    member_readers *members
    member_writers *members
  end

  # OS Specific event
  class OSEvent < AbstractEvent

    layout *SHARED
    member_readers *members
    member_writers *members
  end

  # A user-defined event type (event.user.*)
  class UserEvent < AbstractEvent
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
  class SysWMEvent < AbstractEvent
    layout *SHARED + [
      :msg, SDL2::SysWM::Msg.by_ref
    ]
  end

  # General event UNION (structure)
  # Remember that this is a union, all other structures not related to #type are
  # garbage
  class Event < Union
    layout :type, :uint32,
    :common, CommonEvent,
    :window, WindowEvent,
    :key, KeyboardEvent,
    :edit, TextEditingEvent,
    :text, TextInputEvent,
    :motion, MouseMotionEvent,
    :button, MouseButtonEvent,
    :wheel, MouseWheelEvent,
    :jaxis, JoyAxisEvent,
    :jball, JoyBallEvent,
    :jbutton, JoyButtonEvent,
    :jdevice, JoyDeviceEvent,
    :caxis, ControllerAxisEvent,
    :cbutton, ControllerButtonEvent,
    :cdevice, ControllerDeviceEvent,
    :quit, QuitEvent,
    :user, UserEvent,
    :syswm, SysWMEvent,
    :tfinger, TouchFingerEvent,
    :mgesture, MultiGestureEvent,
    :drop, DropEvent,
    :padding, [:uint8, 56] # From SDL_events.h:529

    member_readers *members
    member_writers *members

    # Polls for currently pending events
    # @returns SDL2::Event or nil if there are no events.
    def self.poll()
      tmp_event = SDL2::Event.new
      unless SDL2.poll_event?(tmp_event)
        tmp_event.pointer.free
        tmp_event = nil
      end
      return tmp_event # May be nil if SDL2.poll_event fails.
    end

    # Converts SDL's type integer into a EVENTTYPE symbol
    # Returns :UNKOWN on failure.
    def type_symbol
      sym = EVENTTYPE.by_value[self.type]
      sym.nil? ? :UNKOWN : sym
    end

  end

  module EVENTACTION
    include EnumerableConstants
    ADD
    PEEK
    GET
  end

  enum :eventaction, EVENTACTION.flatten_consts

  ##
  # :class-method: peep_events
  api :SDL_PeepEvents, [Event.by_ref, :count, :eventaction, :uint32, :uint32], :int
  api :SDL_HasEvent, [:uint32], :bool
  api :SDL_HasEvents, [:uint32, :uint32], :bool
  api :SDL_FlushEvent, [:uint32], :void
  api :SDL_FlushEvents, [:uint32, :uint32], :void
  api :SDL_PollEvent, [Event.by_ref], :int
  boolean? :poll_event, TRUE_WHEN_ONE
  api :SDL_WaitEvent, [Event.by_ref], :int
  api :SDL_WaitEventTimeout, [Event.by_ref, :count], :int
  api :SDL_PushEvent, [Event.by_ref], :int, {error: true, filter: TRUE_WHEN_ONE}

  ##
  # callback event_filter #=> Proc.new do |pointer, event|; return int; end
  callback :event_filter, [:pointer, Event.by_ref], :int

  # This simple structure is used for getting the event filter
  class EventFilterStruct < Struct
    layout :callback, :event_filter
  end

  api :SDL_SetEventFilter, [:event_filter, :pointer], :void
  api :SDL_GetEventFilter, [:pointer, :pointer], :bool
  api :SDL_AddEventWatch, [:event_filter, :pointer], :void
  api :SDL_DelEventWatch, [:event_filter, :pointer], :void
  api :SDL_FilterEvents, [:event_filter, :pointer], :void

  # Enumeration of event_state query
  module EVENTSTATE
    include EnumerableConstants
    QUERY = -1
    IGNORE = 0
    DISABLE = 0
    ENABLE = 1
  end

  enum :event_state, EVENTSTATE.flatten_consts

  ##
  #
  api :SDL_EventState, [:uint32, :event_state], :uint8

  def get_event_state(type)
    event_state(type, EVENTSTATE::QUERY)
  end

  api :SDL_RegisterEvents, [:count], :uint32
end