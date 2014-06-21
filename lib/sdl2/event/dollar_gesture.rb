module SDL2
  class Event
    # Dollar Gesture Event (event.dgesture.*)
    class DollarGesture < Abstract

      layout *SHARED + [
        :touchId, :touch_id,
        :gestureId, :gesture_id,
        :numFingers, :uint32,
        :error, :float,
        :x, :float,
        :y, :float
      ]
      member_readers *members
      member_writers *members
    end

  end
end