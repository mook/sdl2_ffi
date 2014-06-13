require 'sdl2/joystick/components'
module SDL2
  ##
  # A Joystick may have many buttons.
  class Joystick
    ##
    # Enumerates hats on a joystick.
    class Hats < Components
      ##
      # How many hats are there?
      def count
        SDL2::joystick_num_hats(@joystick)
      end
      ##
      # Hat accessor via index
      # @returns Integer (See: SDL2::HAT constants)
      def [](idx)
        SDL2::joystick_get_hat(@joystick,idx)       
      end
    end
  end
end