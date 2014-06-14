require_relative '../../spec_helper'

describe SDL2 do
  it 'should have the renderer api' do
    [
      :create_renderer!,      
      :create_software_renderer!,
      :create_texture!,
      :create_texture_from_surface!,
      :create_window_and_renderer!,
      :destroy_renderer,
      :destroy_texture,
      :get_num_render_drivers!,
      :get_render_draw_blend_mode!,
      :get_render_draw_color!,
      :get_render_driver_info!,
      :get_render_target,
      :get_renderer!,
      :get_renderer_info!,
      :get_renderer_output_size!,
      :get_texture_alpha_mod!,
      :get_texture_color_mod!,
      :get_texture_blend_mode!,
      :lock_texture!,
      :query_texture!,
      :render_clear!,
      :render_copy!,
      :render_copy_ex!,
      :render_draw_line!,
      :render_draw_lines!,
      :render_draw_point!,
      :render_draw_points!,
      :render_draw_rect!,
      :render_draw_rects!,
      :render_fill_rect!,
      :render_fill_rects!,
      :render_get_clip_rect,
      :render_get_logical_size,
      :render_get_scale,
      :render_get_viewport,
      :render_present,
      :render_read_pixels!,
      :render_set_clip_rect!,
      :render_set_logical_size!,
      :render_set_scale!,
      :render_set_viewport!,
      :render_target_supported?,
      :set_render_draw_blend_mode!,
      :set_render_draw_color!,
      :set_render_target!,
      :set_texture_alpha_mod!,
      :set_texture_blend_mode!,
      :set_texture_color_mod!,
      :unlock_texture,
      :update_texture!,
    ].each do |method| 
      SDL2.should respond_to(method)
    end    
  end
  
  describe SDL2::Renderer do
    before :each do
      SDL2.init(:VIDEO)
      @window = SDL2::Window.create()   
      @renderer = SDL2::Renderer.create(@window)
    end
    
    it 'could have many drivers' do
      SDL2::Renderer::Drivers.count.should be_a(Integer)
      SDL2::Renderer::Drivers.count.should >= 0
    end
    
    it 'should have a draw_color' do      
      @renderer.draw_color.should be_a(SDL2::Color)
      @renderer.draw_color = SDL2::Color.create(r: 255)
      @renderer.draw_color.r.should == 255 
    end
    
    it 'should have a draw blend mode' do
      @renderer.should respond_to(:draw_blend_mode)
      @renderer.draw_blend_mode= :BLEND
      @renderer.draw_blend_mode.should == :BLEND
      @renderer.draw_blend_mode= :NONE
      @renderer.draw_blend_mode.should == :NONE
    end
    
    it 'should have an info' do
      @renderer.should respond_to(:info)
      @renderer.info.should be_a(SDL2::RendererInfo)
      @renderer.info.should_not be_null     
    end
    
    it 'should have an output size' do
      @renderer.should respond_to(:output_size)
      @renderer.output_size.count.should == 2
      @renderer.output_size.should == @window.current_size
      @renderer.output_size.each{|val|val.should be_a(Integer)}
    end
    
    it 'should have a target' do
      @renderer.should respond_to(:target)
      @renderer.should respond_to(:target=)
      @renderer.target.should be_nil
      skip "TODO: SDL Error: glFramebufferTexture2DEXT() failed" #TODO: Investigate SDL Error: glFramebufferTexture2DEXT() failed
      binding.pry
      texture = SDL2::Texture.create(@renderer, :RGBA8888, :TARGET, 128, 128)
      @renderer.target=texture
      @renderer.target.should == texture
      @renderer.target=nil
      @renderer.target.should be_nil
    end
    
    after :each do
      SDL2.quit
    end
  end
end