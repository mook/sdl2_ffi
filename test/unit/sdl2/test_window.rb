require_relative '../../test_helper'

require 'sdl2/video'
# Window is a part of the Video API

describe SDL2::Window do

  before do
    @window = SDL2::Window.create
  end

  after do
    SDL2.destroy_window(@window)
  end

  it 'can be created' do
    window =  SDL2::Window.create('My Title', 10, 20, 300, 400)
    assert_kind_of SDL2::Window, window
    SDL2.destroy_window(window)
  end

  it 'has a title' do
    @window.title = 'Updated'
    assert_equal 'Updated', @window.title
  end

  it 'has a current_size' do
    window = SDL2::Window.create('Title', 10, 20, 300, 400)
    assert_equal [300, 400], window.current_size
    window.current_size = [640, 480]
    assert_equal [640, 480], window.current_size
    SDL2.destroy_window(window)
  end

  it 'has a maximum size' do

    assert_kind_of Array, @window.maximum_size
    @window.maximum_size = [800,600]
    assert_equal [800,600], @window.maximum_size

  end

  it 'has a minimum size' do

    assert_kind_of Array, @window.minimum_size
    @window.minimum_size = [320,200]
    assert_equal [320,200], @window.minimum_size
  end

  it 'has a pixel format' do
    assert_kind_of Integer, @window.pixel_format
  end

  it 'can create a window and renderer pair' do
    pair = SDL2::Window.create_with_renderer(300, 400, 0)
    refute_nil pair
    assert_equal 2, pair.count
    assert_kind_of SDL2::Window, pair[0]
    assert_kind_of SDL2::Renderer, pair[1]
  end

  it 'can bind a texture' do
    skip 'Texture support not implemented.'
  end

  it 'has brightness' do
    assert_kind_of Float, @window.brightness
    @window.brightness = 0.85
    assert_in_delta 0.85, @window.brightness, 0.1
  end

  it 'has many data' do
    assert_respond_to @window, :data
    skip("For now...")
    #assert_respond_to window.data, :count
    #assert window.data.count > 0
    #assert_kind_of FFI::Pointer, window.data
  end

  it 'has an associated display' do
    assert_kind_of SDL2::Display, @window.display
  end

  it 'has an associated display mode' do
    assert_kind_of SDL2::Display::Mode, @window.display_mode
  end

  it 'has associated flags' do
    assert_kind_of Integer, @window.flags
  end

  it 'has an associated gamma ramp' do
    skip('Not sure how to implement this yet.')
  end

  it 'has an associated id' do
    assert_kind_of Integer, @window.id
  end

  it 'has a position' do
    assert_kind_of Array, @window.position
    @window.position = [123,456]
    assert_equal [123,456], @window.position
  end

  it 'has a surface' do
    assert_kind_of SDL2::Surface, @window.surface
  end

  it 'can update the window surface' do
    surface = @window.surface
    assert_equal 0, @window.update_surface!
  end

  it 'can update surface rects' do
    skip('For now, I\'ll handle arrays of rects later.')
  end

  it 'can be hidden' do
    @window.hide
    skip("Not sure how to test state.")
  end

  it 'can be shown' do
    @window.show
    skip("Not sure how to test state.")
  end

  it 'can be maximized' do
    @window.maximize
    skip("Not sure how to test state.")
  end

  it 'can be minimized' do
    @window.minimize
    skip("Not sure how to test state.")
  end

  it 'can be restored' do
    @window.restore
    skip("Not sure how to test state.")
  end

  it 'can be raised above other windows' do
    @window.raise_above
    skip("Not sure how to test state.")
  end

  it 'can be set to fullscreen' do
    assert_equal 0, @window.flags & SDL2::Window::FULLSCREEN_DESKTOP
    @window.fullscreen = SDL2::Window::FULLSCREEN_DESKTOP
    refute_equal 0, @window.flags & SDL2::Window::FULLSCREEN_DESKTOP
  end

end