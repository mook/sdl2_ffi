require_relative 'lazy_foo_helper'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson13/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta

class Timer

  def initialize
    @start_ticks = 0
    @paused_ticks = 0
    @paused = false
    @started = false
  end

  def start
    @started = true
    @paused = false
    @start_ticks = SDL2::get_ticks()
  end

  def stop
    @started = false
    @paused = false
  end

  def pause
    if started? and not paused?
      @paused = true
      @paused_ticks = SDL2::get_ticks() - @start_ticks
    end
  end

  def unpause
    if paused?
      @paused = false
      @start_ticks = SDL2::get_ticks() - @paused_ticks
      @paused_ticks = 0
    end
  end

  def get_ticks
    if started?
      if paused?
        return @paused_ticks
      else
        return SDL2::get_ticks() - @start_ticks
      end
    end
    return 0
  end

  def paused?
    @paused
  end

  def started?
    @started
  end
end

require 'sdl2/application'
require 'sdl2/engine/block_engine'
require 'sdl2/ttf'

describe "LazyFoo.net: Lesson 03: Advanced Timers" do

  before do

    @app = Application.new title: subject
    @engine = Engine::BlockEngine.new
    @app.engines << @engine
      
    TTF::init!

    @font = TTF::Font.open(FONT_PATH, 32)

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
      @msg_seconds = @font.render_text_blended(time.to_s)
      
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
    @app.loop(nil,delay: 1000)

  end

end