require_relative '../../test_helper'

require 'sdl2/power'

describe SDL2 do
  
  it 'has the SDL_power.h API' do
    assert_respond_to SDL2, :get_power_info
  end
  
end