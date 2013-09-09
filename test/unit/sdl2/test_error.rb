require_relative '../../test_helper'

require 'sdl2/error'

describe SDL2 do
  
  it 'deals with errors' do
    
    assert SDL2.respond_to?(:clear_error)
    assert SDL2.respond_to?(:get_error)
    assert SDL2.respond_to?(:set_error)
    
    SDL2.clear_error()
    assert_equal '', SDL2.get_error()
    assert_equal -1, SDL2.set_error('My Error String %d', :int, 6384)
    assert_equal 'My Error String 6384', SDL2.get_error()
    
  end
  
end