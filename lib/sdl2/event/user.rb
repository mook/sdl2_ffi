module SDL2
  class Event
    # A user-defined event type (event.user.*)
    class User < Abstract
      layout *SHARED + [
        :windowID, :uint32,
        :code, :int32,
        :data1, :pointer,
        :data2, :pointer
      ]
      member_readers *members
      member_writers *members
    end
  end
end