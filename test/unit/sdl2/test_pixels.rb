require_relative '../../test_helper'
require 'sdl2/pixels'

describe SDL2 do
  it 'should have the SDL_pixels.h API' do
    [
      :get_pixel_format_name,
      :pixel_format_enum_to_masks,
      :masks_to_pixel_format_enum,
      :alloc_format,
      :free_format,
      :alloc_palette,
      :set_pixel_format_palette,
      :set_palette_colors,
      :free_palette,
      :map_rgb,
      :map_rgba,
      :get_rgb,
      :get_rgba,
    ].each do |function|
      assert_respond_to SDL2, function
    end
  end
end