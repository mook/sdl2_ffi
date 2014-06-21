require_relative '../../spec_helper'

describe SDL2::Keyboard do
  before :each do
    SDL2.init(:VIDEO)
    @window = SDL2::Window.create()
    SDL2.pump_events
  end
  
  it 'should return a focused window' do    
    SDL2::Keyboard.get_focus.should be_a(SDL2::Window)
  end
  
  it 'should return an array of integers' do
    skip 'TODO: Keyboard#get_state'
    #binding.pry
  end
  
  after :each do
    SDL2.quit
  end
end