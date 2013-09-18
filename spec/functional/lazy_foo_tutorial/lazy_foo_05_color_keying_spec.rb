require_relative 'lazy_foo_helper'

require 'sdl2/image'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson05/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 05: Color Keying" do
  
  before do
    SDL2::init!(:EVERYTHING)
    @window = Window.create(subject, :CENTERED, :CENTERED, 640, 480)
    @screen = @window.surface
    
    @background = @screen.convert(Image.load!(input_file('background.jpg')))
      
    @foo = @screen.convert(Image.load!(input_file('foo.jpg')))
      
    @foo.color_key = @foo.format.map_rgb([0, 0xff, 0xff])
    
    @screen.blit_in(@background)
    @screen.blit_in(@foo)
    
    @window.update_surface
        
      
  end
  
  after do
    @background.free
    @foo.free
    quit()
    
  end
  
  it "draws the sprite using a color key" do
    verify(format: :png) do
      @screen
    end
  end
  
end