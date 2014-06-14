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
      :render_set_clip_rect!,
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
    
    it 'should be able to clear' do
      @renderer.should respond_to(:clear)
      @renderer.draw_color = SDL2::Color.create(g: 255)
      @renderer.clear           
      SDL2.render_present(@renderer)
      
      verify(format: :png){@window.renderer_to_surface}
    end
    
    it 'should be able to create textures from surfaces' do
      @renderer.should respond_to(:texture_from_surface)
      sur_hello = @window.surface.convert(SDL2.load_bmp!(img_path('hello.bmp')))
      @renderer.texture_from_surface(sur_hello).should be_a(SDL2::Texture)      
    end
    
    it 'should be able to render textures' do
      @renderer.should respond_to(:copy)  
      txt_hello = @renderer.texture_from_surface(@window.surface.convert(SDL2.load_bmp!(img_path('hello.bmp'))))
      @renderer.copy(txt_hello, {w: 200, h: 200}, {x: 100, y: 100, w: 100, h: 100})
      SDL2.render_present(@renderer)
      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to rotate and flip while rendering textures' do
      @renderer.should respond_to(:copy_ex)
      txt_hello = @renderer.texture_from_surface(@window.surface.convert(SDL2.load_bmp!(img_path('hello.bmp'))))
      @renderer.copy_ex(txt_hello, nil, nil, 12, {x: 12, y: 12}, :BOTH )
      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to draw a single pixel line' do
      @renderer.should respond_to(:draw_line)
      @renderer.draw_color = SDL2::Color.create(r: 255,g: 255,b: 255)
      @renderer.draw_line(100,100,200,200)
      SDL2.render_present(@renderer)
      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to draw a line connecting many points' do
      @renderer.should respond_to(:draw_lines)
      points = [[5,5],[1,123],[290,33],[27,222]]
      @renderer.draw_color = SDL2::Color.create(g: 255)
      # draw lines expects each point to be specified as an argument,
      # no limit to the number of points that can be specified at once
      # that I know of using this method.
      @renderer.draw_lines(*points)
      SDL2.render_present(@renderer)

      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to draw a point' do
      @renderer.should respond_to(:draw_point)
      @renderer.draw_color = SDL2::Color.create(r: 255)
      @renderer.draw_point(160,120)
      SDL2.render_present(@renderer)
      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to draw points' do
      # You can pass many kinds of points.
      points = [[88,44],SDL2::Point.cast([128,40]),{x: 300, y: 444}]
      @renderer.draw_color = SDL2::Color.create(b: 255)
      @renderer.draw_points(*points)
      SDL2.render_present(@renderer)
      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to draw a single rectangle' do
      @renderer.should respond_to(:draw_rect)
      @renderer.draw_color = {r: 255}
      @renderer.draw_rect([10,10,100,100])
      @renderer.draw_color = {g: 255}
      @renderer.draw_rect({x: 40, y: 40, w: 64, h: 128})
      @renderer.draw_color = {b: 255}
      @renderer.draw_rect(SDL2::Rect.cast({x: 100, y: 100, w: 128, h: 64}))
      SDL2.render_present(@renderer)
      verify(){@window.renderer_to_surface}
    end
    
    
    it 'should be able to draw many rectangles at once' do
      @renderer.should respond_to(:draw_rects)
      # Should be able to handle many kinds of cords.
      cords = [[10,10,100,100],{x: 40, y: 40, w: 64, h: 128},SDL2::Rect.cast({x: 100, y: 100, w: 128, h: 64})]
      @renderer.draw_color = {r: 255, g: 255, b: 255}
      @renderer.draw_rects(*cords)
      SDL2.render_present(@renderer)
      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to draw a single filled rectangle' do
      @renderer.should respond_to(:fill_rect)
      rect = {x: 123, y: 132, w: 200, h: 200}
      @renderer.fill_rect(rect)
      @renderer.present
      verify(){@window.renderer_to_surface}
    end
    
    it 'should be able to draw many filled rectangles' do
      rects = [
        [21,32,124,200],
        [64,11,15,66],
        [222,100,80,100]
      ]
      @renderer.fill_rects(*rects)
      @renderer.present
      verify(){@window.renderer_to_surface}
    end
    
    it 'should have a clip rect' do
      @renderer.should respond_to(:clip_rect)
      @renderer.should respond_to(:clip_rect=)
      @renderer.clip_rect.should be_a(SDL2::Rect)
      @renderer.clip_rect.x.should == 0
      @renderer.clip_rect.y.should == 0
      @renderer.clip_rect.w.should == 0
      @renderer.clip_rect.h.should == 0
      @renderer.clip_rect = {x: 128, y: 128, w: 64, h: 32}
      
      @renderer.clip_rect.x.should == 128
      @renderer.clip_rect.y.should == 128
      @renderer.clip_rect.w.should == 64
      @renderer.clip_rect.h.should == 32      
      @renderer.fill_rect x: 100, y: 100, w: 100, h: 100
      @renderer.present
      verify(){@window.renderer_to_surface}
    end
      
    after :each do
      SDL2.quit
    end

  end
end