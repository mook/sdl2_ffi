require 'sdl2/joystick/components'
module SDL2
  ##
  # A Joystick may have many buttons.
  class Joystick
    ##
    # Enumerates buttons on a joystick.
    class Buttons < Components
      ##
      # How many buttons are there?
      def count
        SDL2::joystick_num_buttons(@joystick)
      end
      ##
      # Button accessor via index
      # @returns Integer {0=>RELEASED,1=>PRESSED}
      def [](idx)
        SDL2::joystick_get_button(@joystick,idx)       
      end
    end
  end
end