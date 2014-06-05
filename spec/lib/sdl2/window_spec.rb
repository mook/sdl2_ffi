require_relative 'sdl2_helper'

describe SDL2::Window do

  before do
    @window = SDL2::Window.create()
  end

  it 'has a title' do
    expect(@window.title).to eq(@window.class.to_s) # Defaults to
    @window.title = 'My new title'
    expect(@window.title).to eq('My new title')
  end

  it 'has different sizes' do
    expect(@window.current_size).to eq([320, 240])
    expect(@window.minimum_size).to eq([0,0])
    expect(@window.maximum_size).to eq([0,0])
    @window.minimum_size = [320,240]
    @window.maximum_size = [1024,768]
    expect(@window.minimum_size).to eq([320,240])
    expect(@window.maximum_size).to eq([1024,768])
    @window.should respond_to :width
    @window.width.should == 320
    @window.should respond_to :height
    @window.height.should == 240
  end
  
  it 'has data' do
    expect(@window.data).to be_a(SDL2::Window::Data)
  end
  
  it 'has window flags' do
    @window.flags.should == SDL2::Window::FLAGS::SHOWN
  end

end