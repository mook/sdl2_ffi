module SDL2
  class Event
    # Multiple Finger Gesture Event (event.mgesture.*)
    class MultiGesture < Abstract

      layout *SHARED + [
        :touchId, :touch_id,
        :dTheta, :float,
        :dDist, :float,
        :x, :float,
        :y, :float,
        :numFingers, :uint16,
        :padding, :uint16
      ]
      member_readers *members
      member_writers *members
    end

  end
end