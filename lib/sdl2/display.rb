require 'sdl2'
require 'sdl2/display/modes'
require 'sdl2/display/mode'

module SDL2
  ##
  # Abstract representation of what SDL calls a "Display"
  class Display
    ##
    # Every display has an id, an index.
    attr_reader :id       
    ##
    # Initialize a new display for index display_id
    def initialize(display_id)
      @id = display_id.to_i # It should be an integer.
    end
    ##
    # Every display has many modes        
    def modes
      @modes ||= Modes.new(self)
    end
    ##
    # Get the display instance for index display_id
    def self.[](display_id)
      if (idx = display_id.to_i) < count
        return Display.new(display_id)
      else
        return nil
      end
    end
    ##
    # Get the number of displays
    def self.count
      SDL2.get_num_video_displays!()
    end
    ##
    # An alias for count, the number of displays
    def self.num
      self.count
    end
    ##
    # Return the first display
    def self.first
      self[0]
    end
    ##
    # Retrieve a display mode closest to a requested ideal.
    # May return nil
    def closest_display_mode(wanted)
      closest = SDL2::Display::Mode.new # Make a new structure.
      return SDL2.get_closest_display_mode(@id, wanted, closest)
    end
    ##
    # Get the current display mode
    def current_display_mode
      display_mode = SDL2::Display::Mode.new
      SDL2.get_current_display_mode!(@id, display_mode)
      display_mode
    end
    ##
    # Returns the bounds
    def bounds
      rect = SDL2::Rect.new
      if SDL2.get_display_bounds(@id, rect) == 0
        return rect
      else
        rect.pointer.free
        return nil
      end
    end

    def bounds!
      rect = bounds()
      SDL2.raise_error_if rect.nil?
      return rect
    end

  end

end

