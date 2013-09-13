require_relative '../test_helper'

require 'sdl2'
require 'sdl2/video'
require 'sdl2/image'

class TestScratch < MiniTest::Unit::TestCase
  def test_a_game
    window = SDL2::Window.create!("My Window", 0, 0, 300, 300)
    win_surface = window.surface
    
    
    
    color_bars = SDL2::Image.load(File.expand_path('color_bars.jpg', FIXTURE_DIR))
    
       #  binding.pry
    
  end
end