require_relative '../../spec_helper'

describe SDL2 do
  it 'should have the SDL_mouse.h API' do
    [
      :create_color_cursor!,
    ].each do |function|
      SDL2.should respond_to(function)
    end
  end
end

describe SDL2::Cursor do
  it 'can create color cursors' do
    skip 'supported yet?' do
      SDL2::Cursor.should respond_to(:create_color_cursor)
      finger = SDL2::Image.load(img_path('finger.png'))
      @cursor = SDL2::Cursor.create_color_cursor(finger,finger.w/2,finger.h/2)
    end
  end
end