require_relative '../spec_helper'

require 'sdl2/init'
require 'sdl2/video'

# http://wiki.libsdl.org/CategoryVideo
# Aligned to line 10 to make coutning easy.
#
# What the Ruby version of the SDL_video.h API should look like
#
VIDEO_API = [
  :get_num_video_drivers,
  :get_video_driver,
  :video_init,
  :video_quit,
  :get_current_video_driver,
  :get_num_video_displays,
  :get_display_name,
  :get_display_bounds,
  :get_num_display_modes,
  :get_display_mode,
  :get_desktop_display_mode,
  :get_current_display_mode,
  :get_closest_display_mode,
  :get_window_display_index,
  :set_window_display_mode,
  :get_window_display_mode,
  :get_window_pixel_format,
  :create_window,
  :create_window_from,
  :get_window_from_id,
  :get_window_id,
  :get_window_flags,
  :get_window_title,
  :set_window_title,
  :set_window_icon,
  :set_window_data,
  :get_window_data,
  :set_window_position,
  :get_window_position,
  :set_window_size,
  :get_window_size,
  :set_window_maximum_size,
  :get_window_maximum_size,
  :set_window_minimum_size,
  :get_window_minimum_size,
  :set_window_bordered,
  :show_window,
  :hide_window,
  :raise_window,
  :maximize_window,
  :minimize_window,
  :restore_window,
  :set_window_fullscreen,
  :get_window_surface,
  :update_window_surface,
  :update_window_surface_rects,
  :get_window_grab,
  :set_window_grab,
  :get_window_brightness,
  :set_window_brightness,
  :get_window_gamma_ramp,
  :set_window_gamma_ramp,
  :destroy_window,
  :is_screen_saver_enabled,
  :disable_screen_saver,
  :enable_screen_saver,
  :gl_load_library,
  :gl_get_proc_address,
  :gl_unload_library,
  :gl_extension_supported,
  :gl_set_attribute,
  :gl_get_attribute,
  :gl_create_context,
  :gl_make_current,
  :gl_get_current_window,
  :gl_get_current_context,
  :gl_set_swap_interval,
  :gl_get_swap_interval,
  :gl_delete_context,
  :gl_swap_window

]

describe SDL2 do
  before do
    SDL2.init(SDL2::INIT::VIDEO).should == 0 
  end

  after do
    SDL2.quit()
  end

  it 'has the video API' do
    VIDEO_API.count.should == 70
    VIDEO_API.each do |function|
      SDL2.should respond_to(function)
    end
  end

  it 'can manage the screen saver' do
    SDL2.disable_screen_saver
    SDL2.is_screen_saver_enabled.should_not be_true
    SDL2.enable_screen_saver
    SDL2.is_screen_saver_enabled.should be_true
  end

  describe SDL2::Window do

  end

  it 'can query OpenGL Extension Support' do
    pending 'not sure how to write this test right now.'
  end

  it 'can query and set OpenGL Attributes' do
    pending 'for now.'
  end

  describe SDL2::Display do
    it 'can count the displays attached' do
      sdl_count = SDL2.get_num_video_displays()
      SDL2::Display.count.should == sdl_count
    end

    it 'can get the first display' do
      SDL2::Display.first.should be_a(SDL2::Display)
    end

    it 'can get the display bounds' do
      SDL2::Display.first.bounds!.should be_a(SDL2::Rect)
    end

    it 'has many display modes' do
      SDL2::Display.first.modes.count.should > 0
      SDL2::Display.first().modes.first.should be_a(SDL2::Display::Mode)
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
    closest_display_mode_found.should be_a(SDL2::Display::Mode)

  end
  #TODO: Redo GLContext testing
  #describe SDL2::GLContext do
  #
  #    it 'can create gl_context' do
  #      window = SDL2::Window.create!()
  #      context = SDL2::GLContext.create!(window)
  #      assert_kind_of SDL2::GLContext, context
  #    end
  #
  #  end

end