require_relative '../unit_helper'

describe SDL2::Color do
  before :each do
    SDL2.init!(:EVERYTHING)
    @window = SDL2::Window.create(title: subject.to_s, width: 100, height: 100)
    @screen = @window.surface
    @color = SDL2::Color.new
  end
  
  it 'looks RED when it should' do
    @color.set(255,0,0,255)
  end
  
  it 'looks GREEN when it should' do
    @color.set(0,255,0,255)
  end
  
  it 'looks BLUE when it should' do
    @color.set(0,0,255,255)
  end
  
  it 'should cast hashes properly' do
    @color = SDL2::Color.cast({r: 255, g: 0, b: 0, a: 255})
    expect(@color.r).to eq(255)
    expect(@color.g).to eq(0)
    expect(@color.b).to eq(0)
    expect(@color.a).to eq(255)
  end
  
  
  it 'should cast arrays properly' do
    @color = SDL2::Color.cast([0, 255, 255, 255])
    expect(@color.r).to eq(0)
    expect(@color.g).to eq(255)
    expect(@color.b).to eq(255)
    expect(@color.a).to eq(255)
  end
    
  after :each do
    @screen.fill_rect(@screen.rect, @color)
    @window.update_surface()
    verify(){@screen} 
    SDL2.quit()
  end
end