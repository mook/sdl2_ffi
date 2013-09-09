require 'sdl2'
require 'sdl2/error'

module SDL2

  # System Window
  # A rectangular area you can blit into.
  class Window < FFI::Struct
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

    layout :nothing, :uint8

    def self.create(title ='', x = 0, y = 0, w = 100, h = 100, flags = 0)
      create_window(title, x, y, w, h, flags)
    end

    def self.create_from(data)
      create_window_from(data)
    end

    def self.from_id(id)
      get_window_from_id(id)
    end

    private_class_method :new

    def self.create!(*args)
      creation = create(*args)
      get_error() if creation.null?
      return creation
    end

    def self.release(pointer)
      destroy_window(pointer)
    end

    def brightness
      get_window_brightness(self)
    end

    def brightness=(level)
      set_window_brightness(self, level.to_f)
    end

    def data(named)
      get_window_data(self, named)
    end

    def data=(named, value)
      set_window_data(self, named, value)
    end

    def display_index
      get_window_display_index(self)
    end

    def flags
      get_window_flags(self)
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
      get_window_id(self)
    end

    def maximum_size
      get_window_maximum_size!(self)
    end

    def minimum_size
      get_window_minimum_size!(self)
    end

    def pixel_format
      get_window_pixel_format(self)
    end

    def title
      get_window_title(self)
    end

    def hide
      hide_window(self)
    end

    def maximize
      maximize_window(self)
    end

    def minimize
      minimize_window(self)
    end

    def raise_above
      raise_window(self)
    end

    def restore
      restore_window(self)
    end

    def icon=(surface)
      set_window_icon(self, surface)
    end

    def update_surface()
      update_window_surface(self)
    end

  end

end
