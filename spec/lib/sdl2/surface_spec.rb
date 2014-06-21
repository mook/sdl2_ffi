require_relative '../../spec_helper'

describe SDL2 do
  it 'has the SDL_surface.h API' do
    [
      :blit_scaled!,
      :blit_surface!,
      :convert_pixels!,
      :convert_surface!,
      :convert_surface_format!,
      :create_rgb_surface!,
      :create_rgb_surface_from!,
      :fill_rect!,
      :fill_rects!,
      :free_surface,
      :get_clip_rect,
      :get_color_key!,
      :get_surface_alpha_mod!,
      :get_surface_blend_mode!,
      :get_surface_color_mod!,
      :load_bmp!,
      :load_bmp_rw!,
      :lock_surface!,
      :lower_blit!,
      :lower_blit_scaled!,
      :save_bmp!,
      :save_bmp_rw!,
      :set_clip_rect?,
      :set_color_key!,
      :set_surface_alpha_mod!,
      :set_surface_blend_mode!,
      :set_surface_color_mod!,
      :set_surface_palette!,
      :set_surface_rle!,
      :unlock_surface,
    ].each do |function|
      SDL2.should respond_to(function)
    end

  end
end

describe SDL2::Surface do
  before :each do
    SDL2.init(:VIDEO)
    @window = SDL2::Window.create()
    @screen = @window.surface
    def img_load(img)
      @screen.convert(SDL2::Image.load(img_path(img)))
    end
    @foo = img_load('foo.jpg')
    @background = img_load('background.jpg')
    @gradient = img_load('background.png')
  end

  it 'should be able to blit scaled' do
    @screen.should respond_to(:blit_in_scaled)
    @foo.should respond_to(:blit_out_scaled)
    @screen.blit_in_scaled(@gradient)
    @foo.blit_out_scaled(@screen, {x: 128, y: 64, w: 200, h: 128})
  end

  it 'should be able to blit in and out' do
    @screen.blit_in(@background)
    @foo.blit_out(@screen, {x: 22, y: 44})
  end

  it 'should be able to fill a rectangle' do
    @screen.fill_rect({x: 128, y: 64, w: 128, h: 64}, {r: 255})
  end

  it 'should be able to fill a bunch of rectangles' do
    @screen.fill_rects(
    [
      {x: 32, y: 32, w: 32, h: 32},
      {x: 128, y: 128, w: 64, h: 64},
      {x: 64, y: 0, w: 48, h: 16},
    ],
    {g: 255}
    )
  end
  
  it 'should have a clip rect' do
    @screen.should respond_to(:clip_rect)
    @screen.should respond_to(:get_clip_rect)
    @screen.should respond_to(:clip_rect=)
    @screen.should respond_to(:set_clip_rect?)
    @screen.clip_rect.should == SDL2::Rect.cast({w: 320, h: 240})
    @screen.set_clip_rect?(w: 240, h: 320).should be_truthy
    @screen.set_clip_rect?(x: 320, y: 240, w: 1, h: 1).should be_falsy
    @screen.clip_rect = {x: 8, y: 16, w: 32, h: 64}
    @screen.fill_rect({w: 320, h: 240}, {r: 255, g: 255, b: 255}) 
    #binding.pry
  end
  
  it 'should have a color key' do
    @screen.should respond_to(:color_key)
    @screen.should respond_to(:color_key=)
    @screen.color_key.should be_nil
    @screen.color_key = 0
    @screen.color_key.should == 0
    @screen.color_key = nil
    @screen.color_key.should be_nil
    @foo.color_key = {g: 255, b: 255}
    @screen.blit_in_scaled(@foo)
  end
  
  it 'should have an alpha modulation' do
    @foo.should respond_to(:alpha_mod)
    @foo.should respond_to(:alpha_mod=)
        
    @background.alpha_mod.should == 255
    @foo.alpha_mod = 128
    @foo.blend_mode = :BLEND
    
    @screen.blit_in(@background)
    @screen.blit_in_scaled(@foo)
 
  end
  
  it 'should have a blend mode' do
    @foo.should respond_to(:blend_mode)
    @foo.should respond_to(:blend_mode=)
    @foo.alpha_mod = 200
    @screen.blit_in(@background)
    [:NONE, :BLEND, :ADD, :MOD].each_with_index do |mode, idx|
      @foo.blend_mode = mode
      @foo.blit_out(@screen, x: 2*idx*@foo.w, y: 128)
    end    
  end
  
  it 'should have a color modulation' do
    @foo.should respond_to(:color_mod)
    @foo.should respond_to(:color_mod=)
    @foo.color_mod = [255, 0, 0] #red
    @foo.color_mod.r.should == 255
    @foo.color_mod.g.should == 0
    @foo.color_mod.b.should == 0
    @foo.color_mod.a.should == 255
    @foo.blit_out_scaled(@screen)
  end
  
  after :each do
    @window.update_surface
    verify(format: :png){@screen}    
    SDL2.quit()
  end
end