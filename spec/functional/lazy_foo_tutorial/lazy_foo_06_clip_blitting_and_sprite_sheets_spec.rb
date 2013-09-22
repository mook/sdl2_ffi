require_relative 'lazy_foo_helper'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson04/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta
describe "LazyFoo.net: Lesson 06: Clip Blitting and Sprite Sheets" do
  before do
    SDL2.init!(:EVERYTHING)
    @window = Window.create(subject, :CENTERED, :CENTERED, 640, 480)
    @screen = @window.surface
    @screen.fill_rect(@screen.rect, [0,0,0,ALPHA_OPAQUE])

    @sprites = Array.new(4) do |idx|
      SDL2::Rect.cast(
      x: (idx % 2) * 100,
      y: (idx / 2) * 100,
      w: 100, h: 100
      )
    end

    @dots = @screen.convert(Image.load(img_path('sprites.jpg')))
    @dots.color_key = {r: 0, g: 0xFF, b: 0xFF}

    @screen.fill_rect(@screen.rect, {r: 0xFF, g: 0xFF, b: 0xFF, a: ALPHA_OPAQUE})

    @screen.blit_in(@dots, @sprites[0], {x: 0,   y: 0})
    @screen.blit_in(@dots, @sprites[1], {x: 540, y: 0})
    @screen.blit_in(@dots, @sprites[2], {x: 0,   y: 380})
    @screen.blit_in(@dots, @sprites[3], {x: 540, y: 380})

    @window.update_surface
  end

  after do
    @dots.free

    quit()
  end

  it "draws the clipped sprites to the screen" do
    verify(){@screen}
  end
end