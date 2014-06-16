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

end