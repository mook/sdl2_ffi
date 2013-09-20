require_relative 'lazy_foo_helper'

require 'sdl2/image'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson04/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 04: Event Driven Programming" do
  
  before do
    SDL2.init!(:EVERYTHING)
    
    @window = Window.create(subject, :CENTERED, :CENTERED, 640, 480)
    
    @screen = @window.surface
    
    @image = @screen.convert(Image.load!(img_path('x.png')))
      
    @image.blit_out(@screen, [0, 0])
    
    @window.update_surface()
    
    until @quit do
      
      while event = Event.poll()
        puts "GOT EVENT TYPE: #{event.type_symbol}"
        if (event.type == SDL2::EVENTTYPE::QUIT)
          @quit = true
        end
      end
      
      my_quit_event = SDL2::Event.new
      my_quit_event.type = SDL2::EVENTTYPE::QUIT
      
      
      SDL2.push_event!(my_quit_event)
      
    end
    
  end
  
  
  it 'Draws something to the screen' do
    verify(format: :png) do 
      @screen
    end
  end
  
  it 'set the quit flag' do
    expect(@quit).to be_true
  end
  
  
  

  after do
    @image.free
    quit()
  end
  
end