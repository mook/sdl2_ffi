require 'sdl2'

module SDL2
  
  
    
  attach_function :get_num_video_displays, :SDL_GetNumVideoDisplays, [], :int
    
  attach_function :get_num_video_drivers, :SDL_GetNumVideoDrivers, [], :int
    
  attach_function :get_video_driver, :SDL_GetVideoDriver, [:int], :string
    
  attach_function :get_current_video_driver, :SDL_GetCurrentVideoDriver, [], :string
    
  attach_function :video_init, :SDL_VideoInit, [:string], :int
  attach_function :video_quit, :SDL_VideoQuit, [], :void
    
  
end