require 'sdl2'
require 'sdl2/display/modes'
require 'sdl2/display/mode'

module SDL2

  # Abstract representation of what SDL calls a "Display"
  class Display

    attr_reader :id   
       
    def initialize(display_id)
      @id = display_id.to_i # It should be an integer.
      
    end

        
    def modes
      @modes ||= Modes.new(self)
    end

    def self.[](display_id)
      if (idx = display_id.to_i) < count
        return Display.new(display_id)
      else
        return nil
      end
    end

    def self.count
      SDL2.get_num_video_displays()
    end

    def self.count!
      total = count
      SDL2.raise_error_if total < 0
      return total
    end

    def self.first
      self[0]
    end

    def closest_display_mode(wanted)
      closest = SDL2::Display::Mode.new # Make a new structure.
      return SDL2.get_closest_display_mode(@id, wanted, closest)
    end

    def closest_display_mode!(wanted)
      found = closest_display_mode(wanted)
      SDL2.raise_error_if(found.nil?)
      return found
    end

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

