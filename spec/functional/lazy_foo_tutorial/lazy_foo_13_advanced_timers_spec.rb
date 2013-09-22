require_relative 'lazy_foo_helper'
require_relative 'timer'

require 'sdl2/application'
require 'sdl2/engine/block_engine'
require 'sdl2/ttf'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson13/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta


describe "LazyFoo.net: Lesson 03: Advanced Timers" do

  before do

    @app = Application.new title: subject
    @engine = Engine::BlockEngine.new
    @app.engines << @engine
      
    TTF::init!

    @font = TTF::Font.open(FONT_PATH, 18)
    @big_font = TTF::Font.open(FONT_PATH, 64)

    @my_timmer = Timer.new
    @msg_start_stop = @font.render_text_blended("Press S to start or stop the timer.")
    @msg_pause = @font.render_text_blended("Press P to pause or unpause the timer")

    @my_timer = Timer.new

    @my_timer.start()

    @app.on({type: :KEYDOWN, key: {keysym: {sym: :S}}}) do
      if @my_timer.started?
        @my_timer.stop
      else
        @my_timer.start
      end
    end

    @app.on({type: :KEYDOWN, key: {keysym: {sym: :P}}}) do
      if @my_timer.paused?
        @my_timer.unpause
      else
        @my_timer.pause
      end
    end
    
    @engine.painter = Proc.new() do |surface|
      time = @my_timer.get_ticks / 1000.0
      @msg_seconds = @big_font.render_text_blended(time.to_s)
      
      surface.fill_rect(surface.rect, [0,0,0])
      
      @msg_seconds.blit_out(surface, {
        x: (surface.w - @msg_seconds.w)/2,
        y: 0
      })
      
      @msg_pause.blit_out(surface, {
        x: 0, y: (surface.h - @msg_pause.h)
      })
      
      @msg_start_stop.blit_out(surface, {
        x: (surface.w - @msg_start_stop.w),
        y: (surface.h - @msg_start_stop.h)
      })
      true
    end

  end

  after do

    @app.quit()

  end

  it "works" do
    pending "Don't know how to test this."
    @app.loop(nil)

  end

end