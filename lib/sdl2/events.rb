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

    APP_TERMINATING = next_const_value
    APP_LOWMEMORY = next_const_value
    APP_WILLENTERBACKGROUND = next_const_value
    APP_DIDENTERBACKGROUND = next_const_value
    APP_WILLENTERFOREGROUND = next_const_value
    APP_DIDENTERFOREGROUND = next_const_value

    WINDOWEVENT    = 0x200
    SYSWMEVENT = next_const_value

    KEYDOWN        = 0x300
    KEYUP = next_const_value
    TEXTEDITING = next_const_value
    TEXTINPUT = next_const_value

    MOUSEMOTION    = 0x400
    MOUSEBUTTONDOWN = next_const_value
    MOUSEBUTTONUP = next_const_value
    MOUSEWHEEL = next_const_value

    JOYAXISMOTION  = 0x600
    JOYBALLMOTION = next_const_value
    JOYHATMOTION = next_const_value
    JOYBUTTONDOWN = next_const_value
    JOYBUTTONUP = next_const_value
    JOYDEVICEADDED = next_const_value
    JOYDEVICEREMOVED = next_const_value

    CONTROLLERAXISMOTION  = 0x650
    CONTROLLERBUTTONDOWN = next_const_value
    CONTROLLERBUTTONUP = next_const_value
    CONTROLLERDEVICEADDED = next_const_value
    CONTROLLERDEVICEREMOVED = next_const_value
    CONTROLLERDEVICEREMAPPED = next_const_value

    FINGERDOWN      = 0x700
    FINGERUP = next_const_value
    FINGERMOTION = next_const_value

    DOLLARGESTURE   = 0x800
    DOLLARRECORD = next_const_value
    MULTIGESTURE = next_const_value

    CLIPBOARDUPDATE = 0x900

    DROPFILE        = 0x1000

    USEREVENT    = 0x8000

    LASTEVENT    = 0xFFFF
  end

  enum :event_type, EVENTTYPE.flatten_consts

  # Fields shared by every event
  class CommonEvent < Struct
    LAYOUT = [:type, :uint32, :timestamp, :uint32]
    layout *LAYOUT

  end

  # Window state change event data (event.window.*)
  class WindowEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :event, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :data1, :int32,
      :data2, :int32
    ]
  end

  # Keyboard button event structure (event.key.*)
  class KeyboardEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :state, :uint8,
      :repeat, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :keysym, Keysym
    ]
  end

  # Keyboard text editing event structure (event.edit.*)
  class TextEditingEvent < Struct
    TEXT_SIZE = 32 # Line 188
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :char, [:char, TEXT_SIZE],
      :start, :int32,
      :length, :int32
    ]
  end

  # Keyboard text input event structure (event.text.*)
  class TextInputEvent < Struct
    TEXT_SIZE = 32 # Line 203
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :char, [:char, TEXT_SIZE]
    ]
  end

  # Mouse motion event structure (event.motion.*)
  class MouseMotionEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :which, :uint32,
      :state, :uint32,
      :x, :int32,
      :y, :int32,
      :xrel, :int32,
      :yrel, :int32
    ]
  end

  # Mouse button event structure (event.button.*)
  class MouseButtonEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :which, :uint32,
      :button, :uint8,
      :state, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :x, :int32,
      :y, :int32
    ]
  end

  # Mouse wheel event structure (event.wheel.*)
  class MouseWheelEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :which, :uint32,
      :x, :int32,
      :y, :int32
    ]
  end

  # Joystick axis motion event structure (event.jaxis.*)
  class JoyAxisEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id,
      :axis, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :value, :int16,
      :padding4, :uint16
    ]
  end

  # Joystick trackball motion event structure (event.jball.*)
  class JoyBallEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id,
      :ball, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :xrel, :int16,
      :yrel, :int16
    ]
  end

  # Joystick hat position change event structure (event.jhat.*)
  class JoyHatEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id,
      :hat, :uint8,
      :value, :uint8,
      :padding1, :uint8,
      :padding2, :uint8
    ]
  end

  # Joystick button event structure (event.jbutton.*)
  class JoyButtonEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id,
      :button, :uint8,
      :state, :uint8,
      :padding1, :uint8,
      :padding2, :uint8
    ]
  end

  # Joystick device event structure (event.jdevice.*)
  class JoyDeviceEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id
    ]
  end

  # Game controller axis motion event structure (event.caxis.*)
  class ControllerAxisEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id,
      :axis, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :value, :int16,
      :padding4, :uint16
    ]
  end

  # Game controller button event structure (event.cbutton.*)
  class ControllerButtonEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id,
      :button, :uint8,
      :state, :uint8,
      :padding1, :uint8,
      :padding2, :uint8
    ]
  end

  # Controller device event structure (event.cdevice.*)
  class ControllerDeviceEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :which, :joystick_id
    ]
  end

  # Touch finger event structure (event.tfinger.*)
  class TouchFingerEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :touchId, :touch_id,
      :fingerId, :finger_id,
      :x, :float,
      :y, :float,
      :dx, :float,
      :dy, :float,
      :pressure, :float
    ]
  end

  # Multiple Finger Gesture Event (event.mgesture.*)
  class MultiGestureEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :touchId, :touch_id,
      :dTheta, :float,
      :dDist, :float,
      :x, :float,
      :y, :float,
      :numFingers, :uint16,
      :padding, :uint16
    ]
  end

  # Dollar Gesture Event (event.dgesture.*)
  class DollarGestureEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :touchId, :touch_id,
      :gestureId, :gesture_id,
      :numFingers, :uint32,
      :error, :float,
      :x, :float,
      :y, :float
    ]
  end

  # @brief An event used to request a file open by the system (event.drop.*)
  #        This event is disabled by default, you can enable it with
  # SDL_EventState()
  # @note If you enable this event, you must free the filename in the event.
  #
  class DropEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :file, :string
    ]
  end

  # The "quit requested" event
  class QuitEvent < Struct
    layout *CommonEvent::LAYOUT
  end

  # OS Specific event
  class OSEvent < Struct
    layout *CommonEvent::LAYOUT
  end

  # A user-defined event type (event.user.*)
  class UserEvent < Struct
    layout *CommonEvent::LAYOUT + [
      :windowID, :uint32,
      :code, :int32,
      :data1, :pointer,
      :data2, :pointer
    ]
  end

  #  @brief A video driver dependent system event (event.syswm.*)
  #         This event is disabled by default, you can enable it with
  # SDL_EventState()
  #
  #  @note If you want to use this event, you should include SDL_syswm.h.
  class SysWMEvent < Struct
    layout *CommonEvent::LAYOUT + [
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
      
    # Polls for currently pending events
    # @returns SDL2::Event or nil if there are no events.
    def self.poll()
      tmp_event = SDL2::Event.new
      unless SDL2.poll_event?(tmp_event)
        tmp_event.free
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
    ADD = next_const_value
    PEEK = next_const_value
    GET = next_const_value
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
  api :SDL_PushEvent, [Event.by_ref, :count], :int

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