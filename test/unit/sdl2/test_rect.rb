require_relative '../../test_helper'

require 'sdl2/rect'

describe SDL2 do
  
  it 'has the SDL_rect.h API' do
    [
      :has_intersection,
      :intersect_rect,    
      :enclose_points,
      :intersect_rect_and_line
    ].each do |function|
      assert_respond_to SDL2, function
    end
    
  end
  
end