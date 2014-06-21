module SDL2
  class Event
    # The "quit requested" event
    class Quit < Abstract

      layout *SHARED
      member_readers *members
      member_writers *members
    end

  end
end