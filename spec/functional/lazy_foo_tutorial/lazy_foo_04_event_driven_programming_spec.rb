require_relative 'lazy_foo_helper'

require 'sdl2/image'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson04/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 04: Event Driven Programming" do

  before do
    SDL2.init!(:EVERYTHING)

    @window = Window.create(title: subject, width: 640, height: 480)

    @screen = @window.surface
    @screen.fill_rect(@screen.rect, [0,0,0,SDL2::ALPHA_OPAQUE])

    @image = @screen.convert(Image.load!(img_path('x.png')))

    @image.blit_out(@screen, [0, 0])

    @window.update_surface()

    until @quit do

      while event = Event.poll()
        #puts "GOT EVENT TYPE: #{event.type}" if SDL2::PrintDebug
        if (event.type == :QUIT)
          @quit = true
        end
      end

      my_quit_event = Event.cast(Event::Quit.cast(type: :QUIT))
      

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