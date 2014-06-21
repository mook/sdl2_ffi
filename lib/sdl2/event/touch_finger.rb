module SDL2
  class Event
    # Touch finger event structure (event.tfinger.*)
    class TouchFinger < Abstract

      layout *SHARED + [
        :touchId, :touch_id,
        :fingerId, :finger_id,
        :x, :float,
        :y, :float,
        :dx, :float,
        :dy, :float,
        :pressure, :float
      ]
      member_readers *members
      member_writers *members
    end

  end
end