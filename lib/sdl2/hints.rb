require 'sdl2'

module SDL2
  
  module HINT
    include EnumerableConstants
    FRAMEBUFFER_ACCELERATION     = "SDL_FRAMEBUFFER_ACCELERATION"
    RENDER_DRIVER                = "SDL_RENDER_DRIVER"
    RENDER_OPENGL_SHADERS        = "SDL_RENDER_OPENGL_SHADERS"
    RENDER_SCALE_QUALITY         = "SDL_RENDER_SCALE_QUALITY"
    RENDER_VSYNC                 = "SDL_RENDER_VSYNC"
    VIDEO_X11_XVIDMODE           = "SDL_VIDEO_X11_XVIDMODE"
    VIDEO_X11_XINERAMA           = "SDL_VIDEO_X11_XINERAMA"
    VIDEO_X11_XRANDR             = "SDL_VIDEO_X11_XRANDR"
    GRAB_KEYBOARD                = "SDL_GRAB_KEYBOARD"
    VIDEO_MINIMIZE_ON_FOCUS_LOSS = "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS"
    IDLE_TIMER_DISABLED          = "SDL_IOS_IDLE_TIMER_DISABLED"
    ORIENTATIONS                 = "SDL_IOS_ORIENTATIONS"
    XINPUT_ENABLED               = "SDL_XINPUT_ENABLED"
  
    GAMECONTROLLERCONFIG         = "SDL_GAMECONTROLLERCONFIG"
  
    JOYSTICK_ALLOW_BACKGROUND_EVENTS = "SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS"
    ALLOW_TOPMOST                    = "SDL_ALLOW_TOPMOST"
    TIMER_RESOLUTION                 = "SDL_TIMER_RESOLUTION"
  end
  
  enum :hint_priority, [:default, :normal, :override]
    
  class Hint
    include HINT
    def self.[](name)
      SDL2.get_hint(name)
    end
    
    # Sets the named Hint to Value.  Returns new value on success or existing value on failure
    def self.[]=(name, value)
      return SDL2.set_hint(name, value) == :true ? value : self[name]
    end
    
    def self.set_with_priority(name, value, hint_priority)
      return SDL2.set_hint_with_priority(name, value, hint_priority) == :true ? value : self[name]
    end
  end

  api :SDL_ClearHints, [], :void
  api :SDL_GetHint, [:string], :string
  api :SDL_SetHint, [:string, :string], :bool
  api :SDL_SetHintWithPriority, [:string, :string, :hint_priority], :bool

end