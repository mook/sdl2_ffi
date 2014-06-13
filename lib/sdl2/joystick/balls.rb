require 'sdl2/joystick/components'
module SDL2
  ##
  # A Joystick may have many buttons.
  class Joystick
    ##
    # Enumerates buttons on a joystick.
    class Balls < Components
      ##
      # How many buttons are there?
      def count
        SDL2::joystick_num_balls(@joystick)
      end
      ##
      # Button accessor via index
      # @returns [DeltaX, DeltaY] integers
      def [](idx)
        dx, dy = SDL2::TypedPointer::Int.new, SDL2::TypedPointer::Int.new                
        SDL2::joystick_get_ball(@joystick,idx, dx, dy)
        [dx.value, dy.value]       
      end
    end
  end
end