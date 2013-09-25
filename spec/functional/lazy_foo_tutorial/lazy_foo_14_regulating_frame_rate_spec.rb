require_relative 'lazy_foo_helper'
require_relative 'timer'
#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson14/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta

require 'sdl2/application'
require 'sdl2/engine/block_engine'
require 'sdl2/ttf'

FRAMES_PER_SECOND = 20

describe "LazyFoo.net: Lesson 14: Advanced Timers" do
  before do
    @app = Application.new
    @frame = 0
    @cap = true
    @fps = Timer.new

    TTF::init!
    @font = TTF::Font.open(FONT_PATH, 32)
    @message = @font.render_text_blended("Testing Frame Rate")

    @app.before_loop do
      puts "before loop"
      @fps.start()
    end

    @app.on({type: :KEYDOWN, key: {keysym: {sym: :RETURN}}}) do |event|
      print "CAP IS: "
      @cap = !@cap
      puts @cap ? "ON" : "OFF"
    end

    @app.after_loop do
      puts "after loop"
      @frame += 1
      if @cap and (@fps.get_ticks() < 1000 / FRAMES_PER_SECOND)
        SDL2::delay((1000 / FRAMES_PER_SECOND) - @fps.get_ticks() )
      end
    end

    @app.painter do |surface|
      puts "painter"
      surface.fill_rect(surface.rect, [0,0,0])

      @message.blit_out(surface, {
        x: (surface.w - @message.w) / 2,
        y: ((surface.h + @message.h * 2) / FRAMES_PER_SECOND) * ( @frame % FRAMES_PER_SECOND) - @message.h
      })

      @app.window().update_surface
      true
    end

  end

  after do
    @app.quit
  end

  it "works" do
    pending "Don't know how to test this"
    @app.loop nil #, #delay: 100
  end
end