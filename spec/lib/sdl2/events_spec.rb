require_relative '../../spec_helper'

describe SDL2 do
  it 'should have the SDL_events.h API' do
    [
      :event_state?,

    ].each do |function|
      SDL2.should respond_to(function)  
    end
  end
end
