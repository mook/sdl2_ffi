require_relative '../../test_helper'

require 'sdl2/init'
require 'sdl2/video'
# http://wiki.libsdl.org/CategoryVideo
# Aligned to line 10 to make coutning easy.
#
# What the Ruby version of the SDL_video.h API should look like
#
VIDEO_API = [
  :create_window, 
  :create_window_and_renderer, 
  :create_window_from,
  :destroy_window, 
  :disable_screen_saver, 
  :enable_screen_saver,
  :gl_bind_texture,   
  :gl_create_context, 
  :gl_delete_context,  
  :gl_extension_supported, 
  :gl_get_attribute, 
  :gl_get_proc_address,  
  :gl_get_swap_interval, 
  :gl_load_library, 
  :gl_make_current,  
  :gl_set_attribute, 
  :gl_set_swap_interval, 
  :gl_swap_window,  
  :gl_unbind_texture, 
  :gl_unload_library, 
  :get_closest_display_mode,  
  :get_current_display_mode, 
  :get_current_video_driver,  
  :get_desktop_display_mode, 
  :get_display_bounds, 
  :get_display_mode,  
  :get_num_display_modes, 
  :get_num_video_displays, 
  :get_num_video_drivers,  
  :get_video_driver, 
  :get_window_brightness, 
  :get_window_data,  
  :get_window_display_index, 
  :get_window_display_mode,  
  :get_window_flags, 
  :get_window_from_id, 
  :get_window_gamma_ramp,
  :get_window_grab, 
  :get_window_id, 
  :get_window_maximum_size,
  :get_window_minimum_size,
  :get_window_pixel_format, 
  :get_window_position, 
  :get_window_size,
  :get_window_surface, 
  :get_window_title, 
  :get_window_wm_info,
  :hide_window, 
  :is_screen_saver_enabled, 
  :maximize_window,
  :minimize_window, 
  :raise_window, 
  :restore_window,
  :set_window_brightness, 
  :set_window_data,
  :set_window_display_mode, 
  :set_window_fullscreen,  
  :set_window_gamma_ramp, 
  :set_window_grab, 
  :set_window_icon,
  :set_window_maximum_size, 
  :set_window_minimum_size,
  :set_window_position, 
  :set_window_size, 
  :set_window_title,
  :show_window, 
  :update_window_surface, 
  :update_window_surface_rects,
  :video_init, 
  :video_quit
]

describe SDL2 do
  before do
    assert(SDL2.init(SDL2::INIT_VIDEO) == 0, 'Video initialized.')
  end

  it 'has the video API' do
    assert_equal 70, VIDEO_API.count
    VIDEO_API.each do |function|
      assert_respond_to SDL2, function
    end
  end

  after do
    SDL2.quit()
  end
end