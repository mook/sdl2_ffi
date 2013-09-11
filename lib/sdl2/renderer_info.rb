require 'sdl2'

module SDL2
  class RendererInfo < Struct
    layout :name, :string,
      :flags, :uint32,
      :num_texture_formats, :uint32,
      :texture_formats, [:uint32, 16],
      :max_texture_width, :int,
      :max_texture_height, :int
    
  end
end