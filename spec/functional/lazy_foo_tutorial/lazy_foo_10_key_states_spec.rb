require_relative 'lazy_foo_helper'

require 'bad_sdl/application'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson10/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta

describe "LazyFoo.net: Lesson 10: Key States" do
  
  before do
    SDL2.init!(:EVERYTHING)
    @application = BadSdl::Application.new
    
    
    #binding.pry
  end
  
  after do
    @application.quit
    SDL2.quit()
  end
  
  it "can get the key states" do
    skip "TODO: SDL2::Keyboard#get_state"
    @state = Keyboard.get_state
    expect(@state.count).to eq(512)    
  end
  
  
  
end