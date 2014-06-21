module SDL2
  class Event
    # OS Specific event
    class OS < Abstract

      layout *SHARED
      member_readers *members
      member_writers *members
    end

  end
end