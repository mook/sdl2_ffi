require 'sdl2'

module SDL2
  
  class Display
    class Mode < Struct
      layout :format, :uint32,
        :w, :int,
        :h, :int,
        :refresh_rate, :int,
        :driverdata, :pointer
        
      def self.release(pointer)
        pointer.free # TODO: Is there a better way of doing this?
      end
        
      def self.current(display_index)
        dm = DisplayMode.new      
        get_current_display_mode(display_index, dm)
        return dm
      end
      
      def self.current!(display_index)
        get_current_display_mode!(display_index)
      end
      
      
      def format=(value)
        self[:format] = value
      end
      
      def w=(value)
        self[:w] = value
      end
      
      def h=(value)
        self[:h] = value
      end
      
      def refresh_rate=(value)
        self[:refresh_rate] = value
      end
      
      def driverdata=(value)
        self[:driverdata] = value
      end
      
    end
  end
  
  
end