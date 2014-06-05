require_relative 'lazy_foo_helper'

require 'sdl2/image'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson03/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 03: Extension Libraries" do
  
  before do
    SDL2.init!(:EVERYTHING)
    @window = Window.create(title: subject, width: 640, height: 480)
    
    @screen = @window.surface
    @screen.fill_rect(@screen.rect, [0,0,0,SDL2::ALPHA_OPAQUE])
        
    a_png = @screen.convert(Image.load!(img_path('an_example.png')))
      
    a_png.blit_out(@screen)
    
    @window.update_surface    
    
  end
  
  it 'should blit a_png to screen' do
    verify(format: :png){@screen}
  end
  
  after do
    
  end
  
end