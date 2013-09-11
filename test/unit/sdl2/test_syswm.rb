require_relative '../../test_helper'

require 'sdl2/syswm'

describe SDL2 do
  
  it 'has the SDL_syswm.h API' do
    assert_respond_to SDL2, :get_window_wm_info
  end
  
end