require_relative 'lazy_foo_helper'

require 'sdl2/ttf'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson07/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 07: True Type Fonts" do
  
  before :all do
    
    #binding.pry
    SDL2.init!(:EVERYTHING)
    @window = Window.create(subject, :CENTERED, :CENTERED, 640, 480)
    @screen = @window.surface
    TTF.init!
    
    @background = @screen.convert(Image.load(img_path('background.png')))
    
    font_path = fixture('fonts/GaroaHackerClubeBold.otf')
    
    @font = TTF::Font.open(font_path, 64)
    
    #@textColor = Color.cast({r: 255,g: 255,b: 255,a: 255})
    @textColor = Color.cast(r: 255, g: 0, b: 0, a: 255)    
        
    @message = @font.render_text_blended_wrapped("The quick brown fox jumps over the lazy dog", 480, @textColor)
    #@message = @screen.convert(@message)
    
    @background.blit_out(@screen, @screen.rect)
    @message.blit_out(@screen, x: 0, y: 150)
    
    @window.update_surface
    
    #delay(1000)
  end
  
  after :all do
    @background.free
    @message.free
    @font.free
    quit()
  end

  it "loads a true type font" do
    expect(@font).to be_a SDL2::TTF::Font
  end
    
  it "writes a message to a surface" do
    verify(){@message}
  end
  
  it "draws the message to the screen" do
    verify(){@screen}
  end

end