require_relative '../../test_helper'

describe "README.md" do
  
  it "'How to start:' Example" do
    
    require 'sdl2'
    
    SDL2.init! :EVERYTHING

    assert SDL2.was_init?(:VIDEO)
    
  end
  
end