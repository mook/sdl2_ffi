require_relative 'lazy_foo_helper'

# ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson01/index2.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 01: Hello World" do

  before do
    expect(init(:EVERYTHING)).to eq(0)

    @window = Window.create(subject, :CENTERED, :CENTERED, 640, 480, :SHOWN)

    @screen = @window.surface

    @hello = @screen.convert(SDL2.load_bmp!(img_path('hello.bmp')))
    @screen.blit_in(@hello)
    @window.update_surface
    # If you want to see it, uncomment the following:
    #delay(2000)
  end

  it 'loaded and optimizes hello bitmap' do
    verify(){@hello}
  end

  it 'created a window surface' do
    expect(@window).to be_a(Window)
    expect(@window.null?).to be_false
  end

  it 'draws hello to the window surface' do
    verify(format: :png){@screen}
  end

  after do
    @hello.free
    quit()
  end

end