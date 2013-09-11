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
 
  after do
    SDL2.quit()
  end

  it 'has the video API' do
    assert_equal 70, VIDEO_API.count
    VIDEO_API.each do |function|
      assert_respond_to SDL2, function
    end
  end

  it 'can manage the screen saver' do
    SDL2.disable_screen_saver
    refute SDL2.is_screen_saver_enabled == :true
    SDL2.enable_screen_saver
    assert SDL2.is_screen_saver_enabled == :true
  end

  describe SDL2::Window do

  end

  it 'can query OpenGL Extension Support' do
    skip 'not sure how to write this test right now.'
  end

  it 'can query and set OpenGL Attributes' do
    skip 'for now.'
  end

  describe SDL2::Display do
    it 'can count the displays attached' do
      sdl_count = SDL2.get_num_video_displays()
      assert_equal sdl_count, SDL2::Display.count
    end

    it 'can get the first display' do
      assert_kind_of SDL2::Display, SDL2::Display.first
    end

    it 'can get the display bounds' do
      assert_kind_of SDL2::Rect, SDL2::Display.first.bounds!
    end

    it 'has many display modes' do
      assert SDL2::Display.first.modes.count > 0
      assert_kind_of SDL2::Display::Mode, SDL2::Display.first().modes.first
    end

  end

  it 'can get the closest display mode' do
    closest_display_mode_found = nil # for now

    SDL2::Display::Mode.new do |wanted|

      wanted.format = 0 #SDL2::PIXELFORMAT_RGBA8888 #TODO: Import PIXELFORMAT
# constants?
      wanted.w = 640
      wanted.h = 480
      wanted.refresh_rate = 60
      wanted.driverdata = nil

      closest_display_mode_found = SDL2::Display.first.closest_display_mode!(wanted)
    end # This should automatically dispose of the display_mode struct we created
# as wanted
    assert_kind_of SDL2::Display::Mode, closest_display_mode_found

  end

  describe SDL2::GLContext do

    it 'can create gl_context' do
      window = SDL2::Window.create!()
      context = SDL2::GLContext.create!(window)
      assert_kind_of SDL2::GLContext, context
    end

  end

end