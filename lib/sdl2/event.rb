module SDL2
  ##
  # # Object oriented representation of SDL_Event union
  class Event < Union
  end
  ##
  # ## Event Enumerations/Constants:
  # - TYPE
  # - ACTION
  # - STATE
  class Event 
    autoload(:TYPE, 'sdl2/event/type')
    autoload(:ACTION, 'sdl2/event/action')
    autoload(:STATE, 'sdl2/event/state')
  end
  enum :event_type, Event::TYPE.flatten_consts
  enum :eventaction, Event::ACTION.flatten_consts

  ##
  # Sub-Structures
  class Event
    autoload(:Abstract, 'sdl2/event/abstract')
    autoload(:Common, 'sdl2/event/common')
    autoload(:Window, 'sdl2/event/window')
    autoload(:Keyboard, 'sdl2/event/keyboard')
    autoload(:TextEditing,'sdl2/event/text_editing')
    autoload(:TextInput,'sdl2/event/text_input')
    autoload(:MouseMotion,'sdl2/event/mouse_motion')
    autoload(:MouseButton,'sdl2/event/mouse_button')
    autoload(:MouseWheel,'sdl2/event/mouse_wheel')
    autoload(:JoyAxis, 'sdl2/event/joy_axis')
    autoload(:JoyBall, 'sdl2/event/joy_ball')
    autoload(:JoyHat, 'sdl2/event/joy_hat')
    autoload(:JoyButton, 'sdl2/event/joy_button')
    autoload(:JoyDevice, 'sdl2/event/joy_device')
    autoload(:ControllerAxis, 'sdl2/event/controller_axis')
    autoload(:ControllerButton, 'sdl2/event/controller_button')
    autoload(:ControllerDevice, 'sdl2/event/controller_device')
    autoload(:TouchFinger, 'sdl2/event/touch_finger')
    autoload(:MultiGesture, 'sdl2/event/multi_gesture')
    autoload(:DollarGesture, 'sdl2/event/dollar_gesture')
    autoload(:Drop,'sdl2/event/drop')
    autoload(:Quit,'sdl2/event/quit')
    autoload(:OS, 'sdl2/event/os')
    autoload(:User, 'sdl2/event/user')
    autoload(:SysWM, 'sdl2/event/sys_wm')
  end
  ##
  # Union Layout
  class Event
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
    # Set the state of processing event types:
    def self.state(type,state=:QUERY)
      SDL2.event_state(type,state)
    end
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
    ##
    # Use this function to filter events on current event Que
    # removing any events for which this filter returns 0 (Zero)
    # If called without arguments, it will check and return any
    # currently defined global filters and associated user data
    # as: [filter, data]
    def self.filter(user_data = nil, &event_filter)
      if event_filter
        SDL2.filter_events(event_filter, user_data)
      else
        event_filter = SDL2::TypedPointer::EventFilter.new
        user_data = SDL2::TypedPointer::Pointer.new
        if SDL2.get_event_filter?(event_filter, user_data)
          [event_filter.value, user_data.value]
        else
          false
        end
      end
    end
    ##
    # This routine sets the global event filter, it expects
    # either a single lambda parameter or an array with
    # or paired with a user_data_pointer
    def self.filter=(filter_lambda, user_data_pointer = nil)
      SDL2.set_event_filter(filter_lambda, user_data_pointer)    
    end  
    ##
    # Check if this event type, or a range of event types exist
    def self.has?(type, type_end = nil)
      unless type_end
        SDL2.has_event?(type)
      else
        SDL2.has_events?(type, type_end)
      end
    end
    ##
    # Flush this kind of event (or this range of event types) from the que
    def self.flush(type, type_end = nil)
      unless type_end
        SDL2.flush_event(type)
      else
        SDL2.flush_events(type, type_end)
      end
    end
    ##
    # Add an event to the que
    def self.push(event)
      event = Event.cast(event) unless event.kind_of? Event
      SDL2.push_event!(event)
    end
    ##
    # General Utility for Peek/Get/Del/Add many events
    def self.peep(events = nil, num_events = nil, action = :PEEK, first_event = :FIRSTEVENT, last_event = :LASTEVENT)
      if events.is_a?(Array)
        events = SDL2::StructArray.clone_from(events, SDL2::Event)
      end
      num_events ||= events.try(:count)
      raise 'num_events must be specified unless events responds to count' if num_events.nil?
      events ||= SDL2::StructArray.new(SDL2::Event, num_events) unless num_events == 0     
      returned = SDL2.peep_events!(events.nil? ? nil : events.first, num_events, action, first_event, last_event)
      events.nil? ? Array.new(returned, nil) : events.first(returned)      
    end
    ##
    # Peek at events, default maximum to return at once is 10
    def self.peek(count = 10, f = :FIRSTEVENT, l = :LASTEVENT)
      self.peep(nil, count, :PEEK, f, l)
    end
    ##
    # Add a bunch of events, expects them as arguments so
    # make sure you add that astrik/star: `SDL2::Event.add(*array)`
    def self.add(*events)
      self.peep(events, nil, :ADD, f, l)
    end
    ##
    # Get a bunch of events, defaults to 10 at once
    def self.get(count = 10, f = :FIRSTEVENT, l = :LASTEVENT)
      self.peep(nil, count, :GET, f, l)
    end
    ##
    # Pump the events.
    def self.pump
      SDL2.pump_events()
    end
    ##
    # Indicates if a Quit event is waiting in the que.
    def self.quit_requested?
      self.pump()
      # Peek into the event que and return the count of quit events.
      # Return true if that is greater than zero.
      self.peep(nil,0,:PEEK,:QUIT,:QUIT).count > 0
    end
    ##
    # Coerce some value into an Event
    def self.cast(something)
      SDL2::Debug.log(self){"Casting Something: #{something.inspect}"}
      if something.kind_of? Abstract
        return something.to_event
      elsif something.kind_of? Hash
        raise "Must have type : #{something.inspect}" unless something.has_key? :type
        tmp = self.new
        fields = members & something.keys
        SDL2::Debug.log(self){"Using fields: #{fields.inspect}"}
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

end