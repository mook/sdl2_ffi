require_relative '../../test_helper'

require 'sdl2/events'

describe SDL2 do
  
  it 'has the SDL_events.h API' do
    [
      :peep_events,
      :has_event,
      :has_events,
      :flush_event,
      :flush_events,
      :poll_event,
      :wait_event,
      :wait_event_timeout,
      :push_event,
      :set_event_filter,
      :get_event_filter,
      :add_event_watch,
      :del_event_watch,
      :filter_events,
      :event_state,
      :register_events    
    ].each do |function|
      assert_respond_to SDL2, function
    end
    
  end
  
end