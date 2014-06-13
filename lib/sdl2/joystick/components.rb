module SDL2
  ##
  # A Joystick has all kinds of components, such as
  class Joystick
    ##
    # Abstract component enumerator
    # Requires :count and :[] to be defined
    class Components
      ##
      # Initialize an enumeration
      def initialize(for_joystick)
        @joystick = for_joystick
        raise "Must be an SDL2::Joystick, not a #{@joystick.class.to_s}" unless @joystick.kind_of?(SDL2::Joystick)
      end
      
      ##
      # Generate enumerator, captures all at call time
      def each(&block)
        count.times.map{|idx|self[idx]}.each(&block)
      end
    end
  end
end