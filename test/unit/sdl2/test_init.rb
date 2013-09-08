require_relative '../../test_helper'

require 'sdl2/init'

describe SDL2 do
  
  after do
    SDL2.quit()
  end
  
  it 'can initialize everything' do
    assert_equal SDL2.init(SDL2::INIT_EVERYTHING), 0
  end
  
  it 'can initialize, check, and quit subsystems' do
    assert_equal SDL2.init(SDL2::INIT_VIDEO), 0 # Only turn on video.
    assert SDL2.was_init(SDL2::INIT_VIDEO) != 0, 'Video is initialized.'
    refute SDL2.was_init(SDL2::INIT_AUDIO) != 0, 'Audio is not initialized'
    assert_equal SDL2.init_sub_system(SDL2::INIT_AUDIO), 0 #Then turn on audio.
    assert SDL2.was_init(SDL2::INIT_AUDIO) != 0, 'Audio is initialized.'
    SDL2.quit_sub_system(SDL2::INIT_VIDEO)
    refute SDL2.was_init(SDL2::INIT_VIDEO) != 0, 'Video is not initialized'    
  end
    
  it 'can quit' do
    assert SDL2.respond_to?(:quit)
  end
    
end