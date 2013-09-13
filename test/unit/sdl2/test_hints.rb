require_relative '../../test_helper'

require 'sdl2/hints'

describe SDL2 do
  
  it 'has hints' do
    assert_respond_to SDL2, :clear_hints
    assert_respond_to SDL2, :get_hint
    assert_respond_to SDL2, :set_hint
    
    assert_equal 'constant', defined?(SDL2::HINT_FRAMEBUFFER_ACCELERATION)
    assert_equal 'constant', defined?(SDL2::HINT_IDLE_TIMER_DISABLED)
    assert_equal 'constant', defined?(SDL2::HINT_ORIENTATIONS)
    assert_equal 'constant', defined?(SDL2::HINT_RENDER_DRIVER)
    assert_equal 'constant', defined?(SDL2::HINT_RENDER_OPENGL_SHADERS)
    assert_equal 'constant', defined?(SDL2::HINT_RENDER_SCALE_QUALITY)
    assert_equal 'constant', defined?(SDL2::HINT_RENDER_VSYNC)

    assert_equal :true, SDL2.set_hint("My Hint", "My Value")
    assert_kind_of String, SDL2.get_hint("My Hint")
    assert_equal "My Value", SDL2.get_hint("My Hint")
    
    [:default, :normal, :override].each do |priority|
      assert_equal :true, SDL2.set_hint_with_priority("#{priority}Hint", "#{priority}Value", priority)
    end    
    
  end
  
  describe SDL2::Hint do
    
    it 'has hash access' do
      assert SDL2::Hint.respond_to?(:[])
      assert SDL2::Hint.respond_to?(:[]=)
        
      assert_equal "My Value", SDL2::Hint["My Hint"] = "My Value"
      assert_equal "My Value", SDL2::Hint["My Hint"]
        
      [:default, :normal, :override].each do |priority|
        assert_equal "#{priority}Value", SDL2::Hint.set_with_priority("#{priority}Hint","#{priority}Value",priority)
      end
    end
  
  end
  
  
  
  
  
end