require_relative '../test_helper'

require 'sdl2'

require 'pry'

describe SDL2 do
  it 'loads at all' do
    assert true # if we got this far without exceptions.
  end
  
  it 'has TypedPointer::Float for float typed pointers' do
    assert defined?(SDL2::TypedPointer::Float)
  end
    
end
