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

describe SDL2::Surface do
  
  it 'rejects invalid pixel formats' do 
    assert_raises RuntimeError do
      # Try to create a 64bit depth image
      SDL2::Surface.create_rgb(0, 100, 100, 64)
    end
  end
  
  it 'can be created with valid arguments' do
    surfaces = 
      [
        SDL2::Surface.create_rgb(0, 100, 100, 4),
        SDL2::Surface.create_rgb(0, 100, 100, 8),
        SDL2::Surface.create_rgb(0,100,100,16)
      ]
    surfaces.each do |surface|
      refute surface.null?
      assert_kind_of SDL2::Surface, surface
    end
    assert_equal 4, surfaces[0].format.bits_per_pixel
    assert_equal 8, surfaces[1].format.bits_per_pixel
    assert_equal 16, surfaces[2].format.bits_per_pixel
  end
  
  it 'can be freed' do
    surface = SDL2::Surface.create_rgb(0, 100, 100, 4)
    surface.free
    skip("Don't know how to test this")
  end
  
  it 'can get and set the palette' do
    surface = SDL2::Surface.create_rgb(0, 100, 100, 4)
    surface_palette = surface.palette
    assert_kind_of SDL2::Palette, surface_palette
    my_palette = SDL2::Palette.create(32)
    my_palette.
    surface.palette = my_palette
    
    assert_equal my_palette, surface.palette
  end
end