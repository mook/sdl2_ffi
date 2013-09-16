require_relative '../../test_helper'

describe "Hello World example translated from: http://lazyfoo.net/SDL_tutorials/lesson01/index2.php" do

  BMP = Hash.new(){ | bmps, key |  bmps[key] = File.expand_path("#{key}.bmp", FIXTURE_DIR) }
  PNG = Hash.new(){ | bmps, key |  bmps[key] = File.expand_path("#{key}.png", FIXTURE_DIR) }
  
  
  # Functional Translated from: 
  # http://lazyfoo.net/SDL_tutorials/lesson01/index2.php
  it "runs LazyFoo.net's Hello World example" do
    
    require 'sdl2'
    
    hello = nil
    window = nil
    screen = nil
    
    # BANG(!) versions of methods Raise RuntimeErrors if needed.
    SDL2.init!(:EVERYTHING) 
    
    window = SDL2::Window.create('Hello World', :UNDEFINED, :UNDEFINED, 640, 480, :SHOWN)
    
    
    screen = window.surface
    
    #binding.pry
    hello = SDL2::Surface.load_bmp(BMP[:hello])
    
    screen.blit_in(hello) 
    
    window.update_surface
    
    #SDL2::delay(2000)
        
    SDL2::quit() # Since the Quit function can't fail, there is no BANG(!) version.
            
  end
  
  # Functional Example Translated from:
  # http://lazyfoo.net/SDL_tutorials/lesson02/index.php
  it "runs LazyFoo.net's Optimized Surface Loading and Blitting " do
    
    width = 640
    height = 480
    
    message = nil
    background = nil
    SDL2.init!(:EVERYTHING)
    
    window = SDL2::Window.create("Optimized Images!", :CENTERED, :CENTERED, width, height)
    @screen = window.surface
   
    
    def load_image(filename)      
      loadedImage = SDL2.load_bmp!(filename)            
      optimizedImage = @screen.convert(loadedImage)
      loadedImage.free
      return optimizedImage
    end
    
    def apply_surface(x, y, source, dest)
      offset = SDL2::Rect.new
      offset.x, offset.y = x,y
      offset.w, offset.h = source.w, source.h
      source.blit_out(dest, offset)
    end
    
    
    
    message = load_image(BMP[:hello])    
    background = load_image(BMP[:background])
      
    apply_surface(0,0, background, @screen)
    apply_surface(320,0, background, @screen)
    apply_surface(0,240, background, @screen)
    apply_surface(320,240, background, @screen)
    
    apply_surface(180, 140, message, @screen)
    
    
    window.update_surface
    
    # SDL2.delay(2000) # Watch it for a sec.
    
    message.free
    background.free
    
    SDL2.quit()
    
  end
  
  it "runs LazyFoo.net's SDL Extension Libraries" do
    require 'sdl2/image'
    
    SDL2.init! :EVERYTHING
    
    @window = SDL2::Window.create("Extension Libraries", :CENTERED, :CENTERED, 640, 480)
    @screen = @window.surface
    
    # We can load more now, not just BMPs!
    def load_image(filename)
      loadedImage = SDL2::Image.load!(filename)
      optimizedImage = @screen.convert(loadedImage)
      loadedImage.free
      return optimizedImage
    end
    
    a_png = load_image(PNG[:an_example])
      
    a_png.blit_out(@screen)
    
    @window.update_surface
    
    SDL2.delay(2000) # sleep 1
    
    a_png.free
    
    SDL2.quit()
    
  end
    
end