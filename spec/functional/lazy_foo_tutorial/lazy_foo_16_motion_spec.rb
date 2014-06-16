require_relative 'lazy_foo_helper'
require_relative 'timer'
#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson16/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta

require 'bad_sdl/application'
require 'bad_sdl/engine/block_engine'
require 'sdl2/ttf'

describe "LazyFoo.net: Lesson 16: Motion" do

  class Dot

    def initialize(opts)
      @x = opts[:x] || 0
      @y = opts[:y] || 0
      @xVel = opts[:xVel] || 0
      @yVel = opts[:yVel] || 0
      @sprite = opts[:sprite] || SDL2::Image.load!(img_path('foo.jpg'))
    end

    def handle_input(event)
      case event.key.keysym.sym
        when :UP then @yVel -= @dot.h / 2
        when :DOWN then @yVel += @dot.h / 2
        when :LEFT then @xVel -= @dot.w / 2
        when :RIGHT then @xVel += @dot.w / 2
      end
    end

    def accelerate(x,y)
      @xVel += x
      @yVel += y
      puts "New Vector: #{@xVel},#{@yVel}"
    end

    def move
      @x += @xVel
      @y += @yVel
    end

    def show(surface)
      @sprite.blit_out(surface, [@x,@y])

    end
  end#class Dot

  before do
    SDL2.init!(:EVERYTHING)
    @app = BadSdl::Application.new title: subject
    @dot = Dot.new(
    x: @app.window.surface.w / 2,
    y: @app.window.surface.h / 2,
    sprite: @app.window.surface.convert(SDL2::Image.load!(img_path('foo.jpg')))
    )

    @app.on(key: :KEYUP, key: {keysym: {sym: :UP}}) do
      @dot.accelerate(0,-1)
    end

    @app.on(key: :KEYUP, key: {keysym: {sym: :DOWN}}) do
      @dot.accelerate(0,1)
    end

    @app.on(key: :KEYUP, key: {keysym: {sym: :LEFT}}) do
      @dot.accelerate(-1,0)
    end

    @app.on(key: :KEYUP, key: {keysym: {sym: :RIGHT}}) do
      @dot.accelerate(1,0)
    end

    @app.after_loop do
      @dot.move
      delay(10)
    end

    @app.painter do |surface|
      surface.fill_rect(surface.rect, [0,0,0])
      @dot.show(surface)
      true
    end

  end
  
  after do 
    @app.quit
    SDL2.quit
  end
  
  it "works" do
    pending 'refine later'
    @app.loop()
  end
end