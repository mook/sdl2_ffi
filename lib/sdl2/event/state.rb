module SDL2
  class Event
    # Enumeration of event_state query
    module STATE
      include EnumerableConstants
      QUERY = -1
      IGNORE = 0
      DISABLE = 0
      ENABLE = 1
    end

  end
end