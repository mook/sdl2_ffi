module SDL2
  class Event
    ##
    #
    # Constants for use with SDL2::peep_events() as eventaction
    module ACTION
      include EnumerableConstants
      ##
      # Causes the creation of messages
      ADD = next_const_value
      ##
      # Retrieves events without removing them
      PEEK = next_const_value
      ##
      # Retrieves events and removes them
      GET = next_const_value
    end
  end
end