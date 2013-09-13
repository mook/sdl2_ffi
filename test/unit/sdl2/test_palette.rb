require_relative '../../test_helper'

require 'sdl2/pixels' #defines SDL_Palette

describe SDL2::Palette do
  
  before do
    @palette = SDL2::Palette.create(32)
  end
  
  after do
    SDL2::Palette.release(@palette)
  end
  
  it 'can be created' do
    refute @palette.null?
  end
  
  it 'can set colors from a ruby array of arrays' do    
    @palette.set_colors([[255,0,0],[0,255,0],[0,0,255]])
  end
  
  
  
  
end