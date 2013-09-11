require_relative '../../test_helper'

require 'sdl2/surface'

describe SDL2 do
  it 'has the SDL_surface.h API' do
    [
      :create_rgb_surface,
      :free_surface,
      :set_surface_palette,
      :lock_surface,
      :unlock_surface,
      :load_bmp_rw,
      :load_bmp,
      :save_bmp_rw,
      :save_bmp,
      :set_surface_rle,
      :set_color_key,
      :get_color_key,
      :set_surface_color_mod,
      :get_surface_color_mod,
      :set_surface_alpha_mod,
      :get_surface_alpha_mod,
      :set_surface_blend_mode,
      :get_surface_blend_mode,
      :set_clip_rect,
      :get_clip_rect,
      :convert_surface,
      :convert_surface_format,
      :convert_pixels,
      :fill_rect,
      :fill_rects,
      :upper_blit,
      :blit_surface,
      :lower_blit,
      :soft_stretch,
      :upper_blit_scaled,
      :blit_scaled,
      :lower_blit_scaled,
    ].each do |function|
      assert_respond_to SDL2, function
    end

  end
end