require 'sdl2'

module SDL2
  attach_function :disable_screen_saver, :SDL_DisableScreenSaver, [], :void
  attach_function :enable_screen_saver, :SDL_EnableScreenSaver, [], :void
  attach_function :is_screen_saver_enabled, :SDL_IsScreenSaverEnabled, [], :bool
  
  def screen_saver?
    is_screen_saver_enabled == :true
  end
end