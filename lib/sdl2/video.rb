require 'sdl2'

module SDL2
  
  attach_function :get_current_video_driver, :SDL_GetCurrentVideoDriver, [], :string
    
  
  
end