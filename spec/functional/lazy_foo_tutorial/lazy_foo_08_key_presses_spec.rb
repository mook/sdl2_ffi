require_relative 'lazy_foo_helper'

require 'sdl2/ttf'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson08/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 08: Key Presses" do

  before do
    SDL2.init!(:EVERYTHING)
    @window = Window.create(subject, :CENTERED, :CENTERED, 640, 480)
    @screen = @window.surface

    @background = @screen.convert(Image.load!(img_path('background.png')))

    @font = TTF::Font.open(fixture('fonts/GaroaHackerClubeBold.otf'),28)

    @upMessage = @font.render_text_solid("Up was pressed")
    @downMessage = @font.render_text_solid("Down was pressed")
    @leftMessage = @font.render_text_solid("Left was pressed")
    @rightMessage = @font.render_text_solid("Right was pressed")
    @quit = false

    @events = [
      SDL2::KeyboardEvent.cast(
      type: SDL2::EVENTTYPE::KEYDOWN,
      keysym: Keysym.cast(sym: SDL2::KEYCODE::UP)
      ),
      SDL2::KeyboardEvent.cast(
      type: SDL2::EVENTTYPE::KEYDOWN,
      keysym: Keysym.cast(sym: SDL2::KEYCODE::DOWN)
      ),

      SDL2::KeyboardEvent.cast(
      type: SDL2::EVENTTYPE::KEYDOWN,
      keysym: Keysym.cast(sym: SDL2::KEYCODE::LEFT)
      ),

      SDL2::KeyboardEvent.cast(
      type: SDL2::EVENTTYPE::KEYDOWN,
      keysym: Keysym.cast(sym: SDL2::KEYCODE::RIGHT)
      ),
      SDL2::QuitEvent.cast(type: SDL2::EVENTTYPE::QUIT)
    ]

    @background.blit_out(@screen) # Clear screen.

    enum = @events.each
    until @quit do
      @message = nil

      while (event = Event.poll())
        puts event.type

        if event.type == :KEYDOWN
          case event.key.keysym.sym
            when :UP then
              @message = @upMessage
            when :DOWN then
              @message = @downMessage
            when :LEFT then
              @message = @leftMessage
            when :RIGHT then
              @message = @rightMessage
          end
        elsif event.type == :QUIT
          @quit = true
        end
      end

      unless @message.nil? || @message.null?
        @background.blit_out(@screen) # Draw over old message

        @message.blit_out(@screen, {
          x: (@screen.w - @message.w) / 2,
          y: (@screen.h - @message.h) / 2
        })

      end

      # Insert some fake events for testing:
      @window.update_surface()

      # If you want to see it run, uncomment
      #delay(300)

      #binding.pry
      begin
        SDL2.push_event(SDL2::Event.cast(enum.next))
      rescue StopIteration
        puts "NO MORE EVENTS"

      end

    end

  end

  it "rendered the up message" do
    verify(){@upMessage}
  end

  it "rendered the down message" do
    verify(){@downMessage}
  end

  it "rendered the left message" do
    verify(){@leftMessage}
  end

  it "rendered the right message" do
    verify(){@rightMessage}
  end


  after do
    quit()
  end

end