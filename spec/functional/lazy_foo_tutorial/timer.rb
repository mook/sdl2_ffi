require 'sdl2'
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