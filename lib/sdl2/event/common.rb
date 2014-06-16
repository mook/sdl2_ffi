
module SDL2
  class Event
    ##
    # Fields shared by every event
    class Common < Abstract
      layout *SHARED
    end
  end
end