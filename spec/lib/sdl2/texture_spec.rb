require_relative '../../spec_helper'

module SDL2
  
  describe Texture do
    
    before :each do 
      SDL2.init!(:VIDEO)     
      @window = SDL2::Window.create()
      @renderer = SDL2::Renderer.create(@window)
      @texture = @renderer.texture_from_surface(SDL2::Image.load(img_path('hello.bmp')))
      #@texture = SDL2::Texture.create(@renderer, :RGBA8888, :STATIC, 64,64)  
      #@renderer.present    
      #binding.pry
      #SDL2::Debug.enable(SDL2::Struct)
      #SDL2::Debug.enable(SDL2)      
    end
    
    after :each do    
      #@texture.destroy
      #@renderer.destroy        
      SDL2.quit
    end
        
    it 'has an alpha_mod' do
      @texture.should respond_to(:alpha_mod)
      @texture.should respond_to(:alpha_mod=) 
      @texture.alpha_mod.should == 255
      @texture.alpha_mod = 128
      @texture.alpha_mod.should == 128
    end
    
    it 'has a blend_mode' do
      @texture.should respond_to(:blend_mode)
      @texture.should respond_to(:blend_mode=)
      @texture.blend_mode.should == :BLEND
      @texture.blend_mode = SDL2::BLENDMODE::ADD
      @texture.blend_mode.should == :ADD
    end
    
    it 'has a color_mod' do
      @texture.should respond_to(:color_mod)
      @texture.should respond_to(:color_mod=)
      @texture.color_mod.should == [255,255,255]
      @texture.color_mod = [32,64,128]
      @texture.color_mod.should == [32,64,128]
    end
    
    it 'can be locked' do
      @texture.should respond_to(:lock)
      @texture.should respond_to(:unlock)
      skip 'need to mess with streaming textures'
      @texture.lock
      @texture.unlock
    end
    
    it 'can be queried' do
      query = @texture.query
      query.length.should == 4      
    end
    
    
  end
  
end