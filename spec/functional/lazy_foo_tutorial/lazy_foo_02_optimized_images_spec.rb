require_relative '../../spec_helper'

require 'sdl2'

include SDL2

# ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson02/index2.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta

describe "LazyFoo.net: Lesson 02: Optimized Images" do
  WIDTH = 640
  HEIGHT = 480
  # BPP = 32 #  TODO: Is this still needed?
  before do
    @window = Window.create(title: subject, width: WIDTH, height: HEIGHT, flags: :SHOWN)
    @screen = @window.surface
    
    def load_image(file)
      @screen.convert(SDL2.load_bmp!(file))
    end
    
    @background = load_image(img_path('background.bmp'))
    @message = load_image(img_path('hello.bmp'))
    @background.blit_out(@screen, [0, 0])
    @background.blit_out(@screen, [320, 0])
    @background.blit_out(@screen, [0, 240])
    @background.blit_out(@screen, [320, 240])
    @message.blit_out(@screen, [180, 140])
    
    @window.update_surface    
    
  end
  
  after do

    @background.free
    @message.free
    
    quit
    
  end
  
  it "optimized the background and message" do
    expect(@background.format).to eq(@screen.format)
    expect(@message.format).to eq(@screen.format)
  end
  
  it 'draws the message and background' do
    verify(format: :png){@screen}
  end
end