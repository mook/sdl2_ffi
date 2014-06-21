require_relative 'lazy_foo_helper'
require_relative 'timer'
#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson14/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta

require 'bad_sdl/application'
require 'bad_sdl/engine/block_engine'
require 'sdl2/ttf'

describe "LazyFoo.net: Lesson 15: Advanced Timers" do
  
  before do
    SDL2.init(:EVERYTHING)
    @app = BadSdl::Application.new(title: subject)
    @frame = 0
    @fps = Timer.new
    @update = Timer.new
    @update.start
    @fps.start
    
    @image = Image.load!(img_path('background.png'))
    
    @app.painter do |surface|
      surface.fill_rect(surface.rect, [0, 0, 0])
      @image.blit_out(surface)
      true      
    end
    
    @app.after_loop do 
      @frame += 1
      if @update.get_ticks() > 1000
        
        fps = @frame./(@fps.get_ticks()./(1000.0))
        @app.window.title = "Average Frames Per Second: #{fps}"
      end
    end
  end
  
  after do
    @app.quit
    SDL2.quit
  end
  
  it "works" do
    @app.loop(1)
    skip "don't know how to test this"
  end
end