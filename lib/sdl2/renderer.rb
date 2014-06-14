require 'sdl2'
require 'sdl2/renderer_info'

module SDL2
  ##
  # Constants used to describe Renderer features (flags)
  module RENDERER
    include EnumerableConstants

    SOFTWARE       = 0x00000001
    ACCELERATED    = 0x00000002
    PRESENTVSYNC   = 0x00000004
    TARGETTEXTURE  = 0x00000008
  end

  ##
  # Render: Interface for 2D accelerated rendering.
  # Supports the following:
  #   - pixel points
  #   - pixel lines
  #   - filled rectangles
  #   - texture images
  #
  # Also supports:
  #   - additive modes
  #   - blending/opaqueness
  #
  # Note: Does not support threading, single thread only.
  #
  # https://wiki.libsdl.org/CategoryRender
  class Renderer < Struct
    include RENDERER
    ##
    # Enumerates the available Renderer Drivers
    class Drivers
      def self.count
        SDL2.get_num_render_drivers!
      end

      def self.[](idx)
        info = SDL2::RendererInfo.create()
        SDL2.get_render_driver_info!(idx, info)
        info
      end
    end

    layout :blank, :uint8 # Ignore Structure?

    ##
    # Constructs a Renderer for a window.
    # @param flags: Combination of RENDERER flags requested
    def self.create(window, flags = 0, driver_idx = -1)
      SDL2.create_renderer!(window, driver_idx, flags)
    end

    ##
    # Returns the rendering context for a window
    def self.get(window)
      SDL2.get_renderer!(window)
    end

    ##
    # Create a 2D software rendering context to be able
    # to write directly to a surface (not a window).
    def self.create_software(surface)
      SDL2.create_software_renderer(surface)
    end

    ##
    # Release a render
    def self.release(pointer)
      SDL2.destroy_renderer(pointer)
    end

    ##
    # Return the Draw Blend Mode
    def draw_blend_mode
      blend_mode = BlendModeStruct.new
      SDL2.get_render_draw_blend_mode!(self, blend_mode)
      blend_mode.value
    end

    ##
    # Change the Draw Blend Mode
    def draw_blend_mode=(blend_mode)
      SDL2.set_render_draw_blend_mode!(self, blend_mode)
    end

    ##
    # Get the Draw Color
    # Returns an SDL2::Color
    def draw_color
      colors = 4.times.map{SDL2::TypedPointer::UInt8.new}
      SDL2.get_render_draw_color!(self, *colors)
      colors = colors.map(&:value)
      SDL2::Color.cast(colors)
    end

    ##
    # Set the Draw Color
    def draw_color=(color)
      color = SDL2::Color.cast(color)
      SDL2.set_render_draw_color!(self, *color.to_a)
    end

    ##
    # Get the target
    # Returns nil if default when 'default' render target set
    def target
      target = SDL2.get_render_target(self)
      target.null? ? nil : target
    end
    ##
    # Set the target
    #
    def target=(texture)
      SDL2.set_render_target!(self, texture)
    end
    ##
    # Retrive the Render Driver Info for this Renderer
    def info
      render_info = SDL2::RendererInfo.new
      SDL2.get_renderer_info!(self, render_info)
      render_info
    end
    ##
    # Get the output size
    # @returns the [width, height]
    def output_size
      wh = 2.times.map{SDL2::TypedPointer::Int.new}
      SDL2.get_renderer_output_size!(self, *wh)
      wh.map(&:value)
    end
    
    ##
    #
    def clear
      SDL2.render_clear(self)
    end

  end

end