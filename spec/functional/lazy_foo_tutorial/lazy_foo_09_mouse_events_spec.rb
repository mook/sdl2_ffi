require_relative 'lazy_foo_helper'

require 'bad_sdl/application'
require 'bad_sdl/engine'

class ButtonEngine < BadSdl::Engine
  OVER = 0
  OUT = 1
  DOWN = 2
  UP = 3

  def initialize(opts)
    super(opts)
    @box = Rect.cast(opts)
    @button_sheet = Image.load!(img_path('button_sheet.png'))
    @clips = Array.new(4) do |idx|
      Rect.cast(x: (idx % 2) * 320,y: (idx / 2) * 240,w: 320, h: 240)
    end#@clip

    #initial clip state:
    @clip = @clips[OUT]

    on({type: :MOUSEMOTION}) do |event|

      offset = Point.cast([event.motion.x, event.motion.y])
      if @box.enclose_points(offset)
        SDL2::Debug.log(self){"Mouse OVER"}
        @clip = @clips[OVER]
      else
        SDL2::Debug.log(self){"Mouse OUT"}
        @clip = @clips[OUT]
      end
    end#on :MOUSEMOTION

    on(
    {type: :MOUSEBUTTONDOWN, button: {button: Mouse::BUTTON::LEFT}},
    {type: :MOUSEBUTTONUP,   button: {button: Mouse::BUTTON::LEFT}}
    ) do |event|
      offset = Point.cast([event.button.x, event.button.y])
      if @box.enclose_points(offset)
        if event.type == :MOUSEBUTTONDOWN
          @clip = @clips[DOWN]
        elsif event.type == :MOUSEBUTTONUP
          @clip = @clips[UP]
        else
          raise "UNKOWN EVENT TYPE: #{event.type}"
        end
      end
    end#on :MOUSEBUTTON*

  end# initialize

  def paint_to(surface)
    if @clip
      SDL2::Debug.log(self){"Painting"}

      @button_sheet.blit_out(surface, @box, @clip) if @clip
      @clip = nil
      true # signal painting
    else
      false # signal no painting
    end
  end

  attr_reader :button_sheet
end#ButtonEngine

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson09/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 09: Mouse Events" do

  before do
    SDL2.init!(:EVERYTHING)
    @application = BadSdl::Application.new()
    @application.window.title = subject
    @button = ButtonEngine.new(x: 170, y: 120, w: 320, h: 240)
    @application.engines << @button
    @application.loop(5) #Prime it
  end

  after do
    @application.quit()
    SDL2.quit
  end

  it 'has a button sheet' do
    verify(){@button.button_sheet}
  end

  it 'shows mouse out' do
    Event.push({type: :MOUSEMOTION, motion: {x: 10, y: 10}})
    #delay(1000)
    @application.loop(1)
    verify(){@application.window.surface}
    
  end

  it 'shows mouse in' do
    Event.push({type: :MOUSEMOTION, motion: {x: 177, y: 122}})
    @application.loop(1)
    verify(){@application.window.surface}
  end

  it 'shows mouse down' do
    Event.push({type: :MOUSEBUTTONDOWN, button: {button: Mouse::BUTTON::LEFT, x: 177, y: 122}})
    @application.loop(1)
    verify(){@application.window.surface}
  end

  it 'shows mouse up' do
    Event.push({type: :MOUSEBUTTONUP, button: {button: Mouse::BUTTON::LEFT, x: 177, y: 122}})
    @application.loop(1)
    verify(){@application.window.surface}
  end

  it 'defaults to mouse out' do
    verify(){@application.window.surface}
  end

  # If you want to play with it, uncomment this:
  #it 'works' do
  #  @application.loop()
  #end
end