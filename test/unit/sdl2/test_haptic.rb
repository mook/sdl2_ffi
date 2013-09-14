require_relative '../../test_helper'
require 'sdl2/haptic'

describe 'SDL2' do
  
  it 'has the SDL_haptic.h API' do
    skip 'Not yet implemented'
  end
  
  it 'can run the documented example: Haptic Direction' do
    direction = SDL2::Haptic::Direction.new
    
    # Cartesian directions
    direction.type = SDL2::Haptic::CARTESIAN # Using cartesian direction encoding.
    direction.dir[0] = 0 # X position
    direction.dir[1] = 1 # Y position
    
    # Polar directions
    direction.type = SDL2::Haptic::POLAR #We'll be using polar direction encoding.
    direction.dir[0] = 18000 # Polar only uses first parameter
    
    # Spherical coordinates
    direction.type = SDL2::Haptic::SPHERICAL # Spherical encoding
    direction.dir[0] = 9000 # Since we only have two axes we don't need more parameters
  end
  
end