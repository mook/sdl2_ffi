require_relative '../../test_helper'

require 'sdl2/clipboard'

describe SDL2 do
  
  it 'has the SDL_clipboard.h API' do
    [:set_clipboard_text, :get_clipboard_text, :has_clipboard_text].each do|func|
      assert_respond_to SDL2, func
    end
  end
  
end