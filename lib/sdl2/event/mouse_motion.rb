module SDL2
  class Event
    # Mouse motion event structure (event.motion.*)
    class MouseMotion < Abstract

      layout *SHARED + [
        :windowID, :uint32,
        :which, :uint32,
        :state, :uint32,
        :x, :int32,
        :y, :int32,
        :xrel, :int32,
        :yrel, :int32
      ]
      member_readers *members
      member_writers *members
    end
  end
end