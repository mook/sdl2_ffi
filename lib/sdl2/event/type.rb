module SDL2
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
  end
end