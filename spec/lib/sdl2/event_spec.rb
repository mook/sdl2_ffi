require_relative '../../spec_helper'

describe SDL2::Event do
  it 'should provide event states' do
    SDL2::Event.should respond_to(:state)
    SDL2::Event.state(:KEYDOWN).should == true
    SDL2::Event.state(:KEYDOWN, :IGNORE).should == true # Because it was true
    SDL2::Event.state(:KEYDOWN).should == false # Because now it's disabled.
    SDL2::Event.state(:KEYDOWN, :ENABLE).should == false #getting it?
    SDL2::Event.state(:KEYDOWN).should == true
  end
end