require_relative '../../test_helper'

describe "Hello World example translated from: http://lazyfoo.net/SDL_tutorials/lesson01/index2.php" do

  HELLO_BMP_FILE = File.expand_path('/hello.bmp')
  
  # Functional Example from: 
  # http://lazyfoo.net/SDL_tutorials/lesson01/index2.php
  it "should run the example from LazyFoo.net" do
    
    require 'sdl2'
    
    hello = nil
    window = nil
    screen = nil
    
    # BANG(!) versions of methods Raise RuntimeErrors if needed.
    SDL2.init!(:EVERYTHING) 
    
    window = SDL2::Window.create('Hello World', 0, 0, 640, 480, :SHOWN)
    
    screen = window.surface
    
    hello = SDL2::Surface.load_bmp(HELLO_BMP_FILE)
    
    screen.blit_from(hello)
    
    hello.free
    
    SDL2::quit() # Since the Quit function can't fail, there is no BANG(!) version.
            
  end
    
end