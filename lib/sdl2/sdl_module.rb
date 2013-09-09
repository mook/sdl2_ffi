
module SDL2
  # Default load-path.  To modify what library this RubyGem loads:
  # 1) require 'sdl2/sdl_module' before anything else.  
  # 2) Modify the SDL2::SDL_MODULE array. 
  # 3) require any of the rest of the SDL2 module: require 'sdl2/video', etc
  SDL_MODULE = ['libSDL2','/usr/local/lib/libSDL2.so']
end