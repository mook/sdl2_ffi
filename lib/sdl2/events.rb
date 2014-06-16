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
  require 'sdl2/event'
  
  
  api :SDL_PeepEvents, [Event.by_ref, :count, :eventaction, :uint32, :uint32], :int
  api :SDL_HasEvent, [:uint32], :bool
  api :SDL_HasEvents, [:uint32, :uint32], :bool
  api :SDL_FlushEvent, [:uint32], :void
  api :SDL_FlushEvents, [:uint32, :uint32], :void
  api :SDL_PumpEvents, [], :void
  api :SDL_PollEvent, [Event.by_ref], :int
  boolean? :poll_event, OK_WHEN_ONE
  api :SDL_WaitEvent, [Event.by_ref], :int
  api :SDL_WaitEventTimeout, [Event.by_ref, :count], :int
  api :SDL_PushEvent, [Event.by_ref], :int, {error: true, filter: OK_WHEN_ONE}

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



  enum :event_state, Event::STATE.flatten_consts

  api :SDL_EventState, [:event_type, :event_state], :bool

  def get_event_state(type)
    event_state(type, EVENTSTATE::QUERY)
  end

  api :SDL_RegisterEvents, [:count], :uint32
end