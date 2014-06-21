require_relative 'lazy_foo_helper'

require 'sdl2/ttf'


# ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson01/index2.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 01: Hello World" do

  before do
    expect(init(:EVERYTHING)).to eq(0)

    @window = Window.create(title: subject, width: 640, height: 480, flags: :SHOWN)

    @screen = @window.surface
    @screen.fill_rect(@screen.rect, [0,0,0,SDL2::ALPHA_OPAQUE])
    @hello = @screen.convert(SDL2::Image.load!(img_path('hello.bmp')))
    @screen.blit_in(@hello)
    @hello.blit_out(@screen)
    @window.update_surface
    # If you want to see it, uncomment the following:
    #delay(2000)
  end

  it 'loaded and optimizes hello bitmap' do
    #binding.pry
    verify(format: :png){@hello}
  end

  it 'created a window surface' do
    expect(@window).to be_a(Window)
    expect(@window.null?).to be_false
  end

  it 'draws hello to the window surface' do
    #binding.pry
    verify(format: :png){@screen}
  end

  after do
    quit()
  end

end