require 'sdl2'
require 'sdl2/error'

#require 'sdl2/video'
require 'sdl2/surface'
require 'sdl2/display/mode'

module SDL2


  # Used to indicate that you don't care what the window position is.
  module WINDOWPOS
    include EnumerableConstants
    UNEDFINED_MASK = 0x1FFF0000

    # Used to generate the UNDEFINED constant,
    # which if I understand correctly is just UNDEFINED_MASK anyways.
    # I think this is to encourage divers/applications to write specific
    # undefined codes? `</ramble>`
    def self.undefined_display(x)
      self::UNEDFINED_MASK|x
    end

    UNDEFINED = undefined_display(0)

    # SDL_video.h doesn't have much documentation on this,
    # I think it is used internally, but may be useful for applications.
    def self.is_undefined(x)
      (((x)&0xFFFFF00000) == self::UNDEFINED_MASK)
    end

    CENTERED_MASK = 0x2FFF0000

    def self.centered_display(x)
      self::CENTERED_MASK | x
    end

    CENTERED = centered_display(0)

    def self.is_centered(x)
      (((x)&0xFFFF0000) == self::CENTERED_MASK)
    end
  end

  # Event subtype for window events
  module WINDOWEVENT
    include EnumerableConstants
    NONE    = next_const_value
    SHOWN   = next_const_value
    HIDDEN  = next_const_value
    EXPOSED = next_const_value
    MOVED   = next_const_value
    RESIZED = next_const_value
    SIZE_CHANGED  = next_const_value
    MINIMIZED     = next_const_value
    MAXIMIZED     = next_const_value
    RESTORED      = next_const_value
    ENTER         = next_const_value
    LEAVE         = next_const_value
    FOCUS_GAINED  = next_const_value
    FOCUS_LOST    = next_const_value
    CLOSE         = next_const_value
  end

  # System Window
  # A rectangular area you can blit into.
  class Window < Struct
    ##
    # Window Flags Constants
    module FLAGS
      include EnumerableConstants
      FULLSCREEN         = 0x00000001
      OPENGL             = 0x00000002
      SHOWN              = 0x00000004
      HIDDEN             = 0x00000008
      BORDERLESS         = 0x00000010
      RESIZABLE          = 0x00000020
      MINIMIZED          = 0x00000040
      MAXIMIZED          = 0x00000080
      INPUT_GRABBED      = 0x00000100
      INPUT_FOCUS        = 0x00000200
      MOUSE_FOCUS        = 0x00000400
      FULLSCREEN_DESKTOP = ( FULLSCREEN | 0x00001000 )
      FOREIGN            = 0x00000800
    end
    
    layout :magic, :pointer,
    :id, :uint32,
    :title, :string,
    :icon, Surface.by_ref,
    :x, :int,
    :y, :int,
    :w, :int,
    :h, :int,
    :min_w, :int,
    :min_h, :int,
    :max_w, :int,
    :max_h, :int,
    :flags, :uint32,
    :windowed, Rect,
    :fullscreen_mode, Display::Mode,
    :brightness, :float,
    :gamma, :pointer,
    :saved_gamma, :pointer,
    :surface, Surface.by_ref,
    :surface_valid, :bool,
    :shaper, :pointer, # TODO: WindowShaper.by_ref,
    :data, :pointer,
    :driverdata, :pointer,
    :prev, :pointer,
    :next, :pointer
    ##
    # A simple wrapper for data objects associated with a window.
    class Data
      ##
      # Create a data object manager for a given window
      def initialize(for_window)
        @for_window = for_window
      end
      ##
      # Return the data named
      def named(name)
        SDL2.get_window_data(@for_window, name.to_s)
      end
      ##
      #
      alias_method :[], :named
      ##
      # Set the data named to value specified.
      def named=(name, value)
        SDL2.set_window_data(@for_window, name.to_s, value.to_s)
      end
      ##
      #
      alias_method :[]=, :named=
    end
    ##
    # The Window's data manager.
    def data
      @data ||= Data.new(self)
    end
    ##
    # Construct a new window.
    def initialize(*args, &block)
      super(*args, &block)
    end
    ##
    # These are the defaults a Window is created with unless overridden
    DEFAULT = {
     title: "SDL2::Window",
     x: :CENTERED,
     y: :CENTERED,
     width: 320,
     height: 240,
     flags: 0
    }
    ##
    # Construct a new window with given:
    #   *  title: The caption to use for the window
    #   *  x: The x-position of the window
    #   *  y: The y-position of the window
    #   *  w: The width of the window
    #   *  h: The height of the window
    #   *  flags: Window Flags to use in construction
    def self.create(options = {})            
      o = DEFAULT.merge(options)
      Debug.log(self){"Creating with options: #{o.inspect}"}
      # TODO: Log unused option keys      
      SDL2.create_window!(o[:title], o[:x], o[:y], o[:width], o[:height], o[:flags])
    end
    ##
    # Constructs a new window from arbitrary system-specific structure
    #   *  data: Some system-specific pointer
    # See SDL Documentation
    def self.create_from(data)
      Debug.log(self){"Creating from data: #{data.inspect}"}
      create_window_from!(data)
    end
    ##
    # Returns the identified window already created
    #   *  id: The window identifier to retrieve
    def self.from_id(id)
      get_window_from_id!(id)
    end
    ##
    # Constructs both a window and a renderer
    #   *  w: The Width of the pair to create
    #   *  h: The Height of the pair to create
    #   *  flags: Window flags to utilize in creation
    def self.create_with_renderer(w, h, flags)
      
      window = Window.new
      renderer = Renderer.new
      if SDL2.create_window_and_renderer(w,h,flags,window,renderer) == 0
        [window, renderer]
      else
        nil
      end
    end
    ##
    # Release memory utilized by structure
    def self.release(pointer)
      fc = caller.first      
      Debug.log(self){"Release ignored from #{fc}"}
    end
    ##
    # Tell SDL we are done with the window.  Any further use could result in a crash.   
    def destroy
      unless self.null?
        SDL2.destroy_window(self)        
      else
        Debug.log(self){"Destruction of window null window requested."}
      end
    end
    

    ##
    # Return the brightness level
    def brightness
      SDL2.get_window_brightness(self)
    end

    # Set the brightness level
    def brightness=(level)
      Debug.log(self){"Setting brightness to: #{level}"}
      SDL2.set_window_brightness(self, level.to_f)
    end

    # Get a copy of the DisplayMode structure
    def display_mode
      dm = SDL2::Display::Mode.new
      SDL2.get_window_display_mode!(self, dm)
      dm
    end

    # Get the display index associated with this window
    def display_index
      SDL2.get_window_display_index(self)
    end

    # Get the display associated with this window
    def display
      Display[display_index]
    end

    # Get the window flags
    def flags
      SDL2.get_window_flags(self)
    end

    # The window's input grab mode
    def grab?
      SDL2.get_window_grab?(self)
    end

    # Set the input grab mode
    def grab=(value)
      SDL2.set_window_grab(self, value)
    end

    # Get the window identifier
    def id
      SDL2.get_window_id(self)
    end

    # Get the window pixel format
    def pixel_format
      SDL2.get_window_pixel_format(self)
    end

    # Get the window title caption
    def title
      SDL2.get_window_title(self)
    end

    # Set the window title caption
    def title=(value)
      SDL2.set_window_title(self, value)
    end

    # Hide the window
    def hide
      SDL2.hide_window(self)
    end

    # Maximize the window
    def maximize
      SDL2.maximize_window(self)
    end

    # Minimize the window
    def minimize
      SDL2.minimize_window(self)
    end

    # Raise the window
    def raise_above
      SDL2.raise_window(self)
    end

    # Restore the window
    def restore
      SDL2.restore_window(self)
    end

    # Show the window
    def show
      SDL2.show_window(self)
    end

    # Set the window's icon from a surface
    def icon=(surface)
      set_window_icon(self, surface)
    end

    # Update the window's surface
    def update_surface()
      SDL2.update_window_surface!(self)      
    end

    # Get the window's current size
    # @return Array => [<width>, <height>]
    def current_size()
      size = 2.times.map{TypedPointer::Int.new}
      SDL2::get_window_size(self, *size)
      size.map(&:value)    
    end
    
    def width
      current_size[0]
    end
    
    def height
      current_size[1]
    end


    # Set the window's current size
    #   *  size: A array containing the [width,height]
    def current_size=(size)
      SDL2.set_window_size(self, size[0], size[1])
    end

    # Get the window's maximum_size
    # @return Array => [<width>, <height>]
    def maximum_size
      size = 2.times.map{TypedPointer::Int.new}
      SDL2::get_window_maximum_size(self, *size)
      size.map(&:value)
    end

    # Set the window's maximum size
    #   *  size: A array containing the [width,height]
    def maximum_size=(size)
      SDL2.set_window_maximum_size(self, size[0], size[1])
    end

    # Get the window's minimum size
    # @return Array => [<width>, <height>]
    def minimum_size
      size = 2.times.map{TypedPointer::Int.new}
      SDL2::get_window_minimum_size(self, *size)
      size.map(&:value)
    end

    # Set the window's minimum size
    #   *  size: A array containing the [width,height]
    def minimum_size=(size)
      SDL2.set_window_minimum_size(self, size[0], size[1])
    end

    # Get the window's position
    # @return Array => [<x>, <y>]
    def position
      position = [TypedPointer::Int.new, TypedPointer::Int.new]
      SDL2::get_window_position(self, position[0], position[1])
      x, y = position[0][:value], position[1][:value]
      position.each(&:free)
      [x, y]
    end

    # Set the window's position
    #   *  size: A array containing the [x,y]
    def position=(location)
      SDL2::set_window_position(self, location[0],location[1])
    end

    # Return the surface associated with the window
    def surface
      SDL2.get_window_surface(self)
    end

    # Set the window's FULLSCREEN mode flags.
    def fullscreen=(flags)
      SDL2.set_window_fullscreen(self, flags)
    end
    ##
    
    ##
    # Returns the renderer associated with this window
    def renderer
      SDL2.get_renderer(self)
    end
    # Utility function that returns an SDL2::Surface of a given render.
    # Defaults to the renderer returned by SDL_GetRenderer(window=self)
    # Added by BadQuanta originally for approval testing.
    def renderer_to_surface(renderer = renderer)
      w, h = renderer.output_size
      fmt = surface.format
      surface = SDL2::Surface.create_rgb(0,w,h,
        fmt.bits_per_pixel,
        fmt.r_mask,
        fmt.g_mask,
        fmt.b_mask,
        fmt.a_mask
      )
      SDL2.render_read_pixels!(renderer, nil, fmt.format, surface.pixels, surface.pitch)
      surface
    end
  end

end
