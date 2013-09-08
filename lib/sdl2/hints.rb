require 'sdl2'

module SDL2

  HINT_FRAMEBUFFER_ACCELERATION     = "SDL_FRAMEBUFFER_ACCELERATION"
  HINT_RENDER_DRIVER                = "SDL_RENDER_DRIVER"
  HINT_RENDER_OPENGL_SHADERS        = "SDL_RENDER_OPENGL_SHADERS"
  HINT_RENDER_SCALE_QUALITY         = "SDL_RENDER_SCALE_QUALITY"
  HINT_RENDER_VSYNC                 = "SDL_RENDER_VSYNC"
  HINT_VIDEO_X11_XVIDMODE           = "SDL_VIDEO_X11_XVIDMODE"
  HINT_VIDEO_X11_XINERAMA           = "SDL_VIDEO_X11_XINERAMA"
  HINT_VIDEO_X11_XRANDR             = "SDL_VIDEO_X11_XRANDR"
  HINT_GRAB_KEYBOARD                = "SDL_GRAB_KEYBOARD"
  HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS"
  HINT_IDLE_TIMER_DISABLED          = "SDL_IOS_IDLE_TIMER_DISABLED"
  HINT_ORIENTATIONS                 = "SDL_IOS_ORIENTATIONS"
  HINT_XINPUT_ENABLED               = "SDL_XINPUT_ENABLED"

  HINT_GAMECONTROLLERCONFIG         = "SDL_GAMECONTROLLERCONFIG"

  HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS = "SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS"
  HINT_ALLOW_TOPMOST                    = "SDL_ALLOW_TOPMOST"
  HINT_TIMER_RESOLUTION                 = "SDL_TIMER_RESOLUTION"
  
  enum :hint_priority, [:default, :normal, :override]
    
  class Hint
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

  attach_function :clear_hints, :SDL_ClearHints, [], :void
  attach_function :get_hint, :SDL_GetHint, [:string], :string
  attach_function :set_hint, :SDL_SetHint, [:string, :string], :bool
  attach_function :set_hint_with_priority, :SDL_SetHintWithPriority, [:string, :string, :hint_priority], :bool

end