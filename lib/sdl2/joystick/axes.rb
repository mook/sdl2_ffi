require 'sdl2/joystick/components'
module SDL2
  ##
  # A joystick may have many Axes
  class Joystick
    ##
    # Enumerates axes on a joystick.
    class Axes < Components
      ##
      # How many Axes are there?
      def count
        SDL2::joystick_num_axes(@joystick)
      end
      ##
      # Axis accessor via index
      # @returns Integer -32768...32767
      def [](idx)
        SDL2::joystick_get_axis(@joystick,idx)       
      end            
    end
  end
end