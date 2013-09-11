require_relative '../../test_helper'

require 'sdl2/render'

describe SDL2 do
  SDL_render_H_API =     [
    :create_renderer,
    :create_software_renderer,
    :create_texture,
    :create_texture_from_surface,
    :create_window_and_renderer,
    :destroy_renderer,
    :destroy_texture,
    :get_num_render_drivers,
    :get_render_draw_blend_mode,
    :get_render_draw_color,
    :get_render_driver_info,
    :get_renderer,
    :get_renderer_info,
    :get_texture_alpha_mod,
    :get_texture_blend_mode,
    :get_texture_color_mod,
    :lock_texture,
    :query_texture,
    :render_clear,
    :render_copy,
    :render_copy_ex,
    :render_draw_line,
    :render_draw_lines,
    :render_draw_point,
    :render_draw_points,
    :render_draw_rect,
    :render_draw_rects,
    :render_fill_rect,
    :render_fill_rects,
    :render_get_clip_rect,
    :render_get_viewport,
    :render_present,
    :render_read_pixels,
    :render_set_clip_rect,
    :render_set_viewport,
    :set_render_draw_blend_mode,
    :set_render_draw_color,
    :set_render_target,
    :set_texture_alpha_mod,
    :set_texture_blend_mode,
    :set_texture_color_mod,
    :unlock_texture,
    :update_texture
  ]
  
  it 'has the SDL_render.h api' do
    assert_equal 43, SDL_render_H_API.count
    SDL_render_H_API.each do |function|
      assert_respond_to SDL2, function      
    end
  end
end