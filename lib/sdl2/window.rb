require 'sdl2'
require 'sdl2/error'

#require 'sdl2/video'
require 'sdl2/surface'
require 'sdl2/display/mode'

module SDL2

  # System Window
  # A rectangular area you can blit into.
  class Window < Struct
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
    :prev, Window.by_ref,
    :next, Window.by_ref

    class Data

      def initialize(for_window)
        @for_window = for_window
      end

      def [](name)
        named(name)
      end

      def named(name)
        SDL2.get_window_data(@for_window, name.to_s)
      end

      def named=(name, value)
        SDL2.set_window_data(@for_window, name.to_s, value.to_s)
      end
    end

    attr_reader :data

    def initialize(*args, &block)
      super(*args, &block)
      @data = Data.new(self)
    end

    def self.create(title ='', x = 0, y = 0, w = 100, h = 100, flags = 0)
      SDL2.create_window(title, x, y, w, h, flags)
    end

    def self.create_from(data)
      create_window_from(data)
    end

    def self.from_id(id)
      get_window_from_id(id)
    end

    def self.create!(*args)
      creation = create(*args)
      get_error() if creation.null?
      return creation
    end

    def self.create_with_renderer(w, h, flags)
      window = Window.new
      renderer = Renderer.new
      if SDL2.create_window_and_renderer(w,h,flags,window,renderer) == 0
        [window, renderer]
      else
        nil
      end
    end

    def self.release(pointer)
      destroy_window(pointer)
    end

    def brightness
      SDL2.get_window_brightness(self)
    end

    def brightness=(level)
      SDL2.set_window_brightness(self, level.to_f)
    end

    def display_mode
      dm = SDL2::Display::Mode.new
      if SDL2.get_window_display_mode(self, dm) == 0
        return dm
      else
        dm.pointer.free
        return nil
      end
    end

    def display_index
      SDL2.get_window_display_index(self)
    end

    def display
      Display[display_index]
    end

    def flags
      SDL2.get_window_flags(self)
    end

    def grab?
      get_window_grab(self) == :true
    end

    def grab=(value)
      unless value == :true or value == :false
        value = value ? :true : :false
      end
      set_window_grab(self, value)
    end

    def id
      SDL2.get_window_id(self)
    end

    def pixel_format
      SDL2.get_window_pixel_format(self)
    end

    def title
      SDL2.get_window_title(self)
    end

    def title=(value)
      SDL2.set_window_title(self, value)
    end

    def hide
      SDL2.hide_window(self)
    end

    def maximize
      SDL2.maximize_window(self)
    end

    def minimize
      SDL2.minimize_window(self)
    end

    def raise_above
      SDL2.raise_window(self)
    end

    def restore
      SDL2.restore_window(self)
    end
    
    def show
      SDL2.show_window(self)
    end

    def icon=(surface)
      set_window_icon(self, surface)
    end

    def update_surface()
      SDL2.update_window_surface(self)
    end
    
    def update_surface!()      
      SDL2.throw_error_unless update_surface == 0
      return 0
    end

    def current_size()
      w_struct, h_struct = IntStruct.new, IntStruct.new
      SDL2::get_window_size(self, w_struct, h_struct)
      w, h = w_struct[:value], h_struct[:value]
      [w, h]
    end

    def current_size=(size)
      SDL2.set_window_size(self, size[0], size[1])
    end

    def maximum_size
      w_struct, h_struct = IntStruct.new, IntStruct.new
      SDL2::get_window_maximum_size(self, w_struct, h_struct)
      w, h = w_struct[:value], h_struct[:value]
      [w, h]
    end

    def maximum_size=(size)
      SDL2.set_window_maximum_size(self, size[0], size[1])
    end

    def minimum_size
      w_struct, h_struct = IntStruct.new, IntStruct.new
      SDL2::get_window_minimum_size(self, w_struct, h_struct)
      w, h = w_struct[:value], h_struct[:value]      
      [w, h]
    end

    def minimum_size=(size)
      SDL2.set_window_minimum_size(self, size[0], size[1])
    end    
    
    def position
      position = [IntStruct.new, IntStruct.new]
      SDL2::get_window_position(self, position[0], position[1])
      x, y = position[0][:value], position[1][:value]
      position.each{|struct|struct.pointer.free}
      [x, y]
    end
    
    def position=(location)
      SDL2::set_window_position(self, location[0],location[1])
    end
    
    def surface
      SDL2.get_window_surface(self)
    end
    
    def fullscreen=(flags)
      SDL2.set_window_fullscreen(self, flags)
    end
  end

end
