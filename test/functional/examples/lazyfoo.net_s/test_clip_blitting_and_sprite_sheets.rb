require_relative '../../../test_helper'

describe "LazyFoo.net's Examples" do

  it "runs the clip blitting and sprite sheets example" do

    require 'sdl2'
    require 'sdl2/image'
    SDL2.init(:EVERYTHING)

    @window = SDL2::Window.create('Clip blitting and sprite sheets',
    :CENTERED,:CENTERED,640,480)

    @screen = @window.surface

    clip = Array.new{SDL2::Rect.new}

    sprite_rect = Array.new(4)do |idx|
      s = SDL2::Rect.new
      s.x= (idx % 2)* 100
      s.y= (idx / 2) *100
      s.w= 100
      s.h= 100
      s
    end

    puts sprite_rect[0]
    puts sprite_rect[1]
    puts sprite_rect[2]
    puts sprite_rect[3]
    
    dots = @screen.convert(SDL2::Image.load(fixture('sprites.jpg')))
    
    @screen.fill_rect(@screen.clip_rect, [0xFF, 0xFF, 0xFF])
    
    #binding.pry
    @screen.blit_in(dots, [0,0], sprite_rect[0])
    @screen.blit_in(dots, [540,0], sprite_rect[1])
    @screen.blit_in(dots, [0, 380], sprite_rect[2])
    @screen.blit_in(dots, [540, 380], sprite_rect[3])
    
    @window.update_surface
    
    Approvals.verify(@screen, format: :bmp, name: "clip blitting and sprite sheets")
    
    SDL2.quit()

  end

end