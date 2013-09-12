require 'sdl2'
require 'sdl2/error'
require 'sdl2/video'
require 'sdl2/keyboard'
require 'sdl2/mouse'
require 'sdl2/joystick'
require 'sdl2/gamecontroller'
require 'sdl2/gesture'
require 'sdl2/touch'

module SDL2
  
  RELEASED = 0
  PRESSED = 1
  
  enum :event_type, [
    :firstEvent, 0,
      
    :quit, 0x100,
    :app_terminating,
    :app_lowMemory,
    :app_willEnterBackground,
    :app_didEnterBackground,
    :app_willEnterForeground,
    :app_didEnterForeground,
    
    :windowEvent, 0x200,
    :syswmEvent,
    
    :keyDown, 0x300,
    :keyUp,
    :textEditing,
    :textInput,
    
    :mouseMotion, 0x400,
    :mouseButtonDown,
    :mouseButtonUp, 
    :mouseWheel,
    
    :joyAxisMotion, 0x600,
    :joyBallMotion,
    :joyHatMotion,
    :joyButtonDown,
    :joyButtonUp,
    :joyDeviceAdded,
    :joyDeviceRemoved,
    
    :controllerAxisMotion, 0x650,
    :controllerButtonDown, 
    :controllerButtonUp,
    :controllerDeviceAdded,
    :controllerDeviceRemoved,
    :controllerDeviceRemapped,
    
    :fingerDown, 0x700,
    :fingerUp, 
    :fingerMotion,
    
    :dollarGesture, 0x800,
    :dollarRecord, 
    :dollarMultigesture,
    
    :clipboardUpdate, 0x900,
      
    :dropFile, 0x1000,
      
    :userEvent, 0x8000,
      
    :lastEvent, 0xFFFF
    
    ]
  
  COMMON_EVENT_LAYOUT = [:type, :uint32, :timestamp, :uint32]
  
  class CommonEvent < Struct
    layout *COMMON_EVENT_LAYOUT
    
  end
  
  class WindowEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :windowID, :uint32,
      :event, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :data1, :int32,
      :data2, :int32
    ]
  end
  
  class KeyboardEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :windowID, :uint32,
      :state, :uint8,
      :repeat, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :keysym, Keysym
    ]
  end
  
  class TextEditingEvent < Struct
    TEXT_SIZE = 32 # Line 188
    layout *COMMON_EVENT_LAYOUT + [
      :windowID, :uint32,
      :char, [:char, TEXT_SIZE],
      :start, :int32,
      :length, :int32
    ]
  end
  
  class TextInputEvent < Struct
    TEXT_SIZE = 32 # Line 203
    layout *COMMON_EVENT_LAYOUT + [
      :windowID, :uint32,
      :char, [:char, TEXT_SIZE]      
    ]
  end
  
  class MouseMotionEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :windowID, :uint32,
      :which, :uint32,
      :state, :uint32,
      :x, :int32,
      :y, :int32,
      :xrel, :int32,
      :yrel, :int32
    ]
  end
  
  class MouseButtonEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
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
   
  class MouseWheelEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :windowID, :uint32,
      :which, :uint32,
      :x, :int32,
      :y, :int32
    ]  
  end
  
  class JoyAxisEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id,
      :axis, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :value, :int16,
      :padding4, :uint16
    ]
  end
  
  class JoyBallEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id,
      :ball, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :xrel, :int16,
      :yrel, :int16
    ]
  end
  
  class JoyHatEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id,
      :hat, :uint8,
      :value, :uint8,
      :padding1, :uint8,
      :padding2, :uint8
    ]    
  end
  
  class JoyButtonEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id,
      :button, :uint8,
      :state, :uint8,
      :padding1, :uint8,
      :padding2, :uint8
    ]
  end
  
  class JoyDeviceEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id
    ]    
  end
  
  class ControllerAxisEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id,
      :axis, :uint8,
      :padding1, :uint8,
      :padding2, :uint8,
      :padding3, :uint8,
      :value, :int16,
      :padding4, :uint16
    ]
  end
  
  class ControllerButtonEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id,
      :button, :uint8,
      :state, :uint8,
      :padding1, :uint8,
      :padding2, :uint8
    ]    
  end
  
  class ControllerDeviceEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :which, :joystick_id
    ]
  end
  
  class TouchFingerEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :touchId, :touch_id,
      :fingerId, :finger_id,
      :x, :float,
      :y, :float,
      :dx, :float,
      :dy, :float,
      :pressure, :float
    ]
  end
  
  class MultiGestureEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :touchId, :touch_id,
      :dTheta, :float,
      :dDist, :float,
      :x, :float,
      :y, :float,
      :numFingers, :uint16,
      :padding, :uint16
    ]
  end
  
  class DollarGestureEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :touchId, :touch_id,
      :gestureId, :gesture_id,
      :numFingers, :uint32,
      :error, :float,
      :x, :float,
      :y, :float
    ]    
  end
  
  class DropEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :file, :string
    ]    
  end
  
  class QuitEvent < Struct
    layout *COMMON_EVENT_LAYOUT
  end
  
  class OSEvent < Struct
    layout *COMMON_EVENT_LAYOUT
  end
  
  
  class UserEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :windowID, :uint32,
      :code, :int32,
      :data1, :pointer,
      :data2, :pointer
    ]
  end

  class SysWMEvent < Struct
    layout *COMMON_EVENT_LAYOUT + [
      :msg, SDL2::SysWM::Msg.by_ref
    ]
  end  
  
  class Event < FFI::Union
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
  end
  
  enum :eventaction, [:add, :peek, :get]
    
  attach_function :peep_events, :SDL_PeepEvents, [Event.by_ref, :count, :eventaction, :uint32, :uint32], :int
  attach_function :has_event, :SDL_HasEvent, [:uint32], :bool
  attach_function :has_events, :SDL_HasEvents, [:uint32, :uint32], :bool
  attach_function :flush_event, :SDL_FlushEvent, [:uint32], :void
  attach_function :flush_events, :SDL_FlushEvents, [:uint32, :uint32], :void
  attach_function :poll_event, :SDL_PollEvent, [Event.by_ref], :int
  attach_function :wait_event, :SDL_WaitEvent, [Event.by_ref], :int
  attach_function :wait_event_timeout, :SDL_WaitEventTimeout, [Event.by_ref, :count], :int
  attach_function :push_event, :SDL_PushEvent, [Event.by_ref, :count], :int
  
  callback :event_filter, [:pointer, Event.by_ref], :int
  class EventFilterStruct < Struct
    layout :callback, :event_filter
  end
  
  attach_function :set_event_filter, :SDL_SetEventFilter, [:event_filter, :pointer], :void
  attach_function :get_event_filter, :SDL_GetEventFilter, [:pointer, :pointer], :bool
  attach_function :add_event_watch, :SDL_AddEventWatch, [:event_filter, :pointer], :void
  attach_function :del_event_watch, :SDL_DelEventWatch, [:event_filter, :pointer], :void
  attach_function :filter_events, :SDL_FilterEvents, [:event_filter, :pointer], :void
  
  QUERY = -1
  IGNORE = 0
  DISABLE = 0
  ENABLE = 1
  
  attach_function :event_state, :SDL_EventState, [:uint32, :int], :uint8
  def get_event_state(type)
    event_state(type, QUERY)
  end
  
  attach_function :register_events, :SDL_RegisterEvents, [:count], :uint32  
end