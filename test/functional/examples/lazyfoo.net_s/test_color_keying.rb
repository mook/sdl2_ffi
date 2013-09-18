require_relative '../../../test_helper'

def path_for(something)
  File.expand_path(something, FIXTURE_DIR)
end

describe "Color Keying" do
  it "runs LazyFoo.net's Color Keying example" do
    require 'sdl2'
    require 'sdl2/image'
    
    def load_image(filename)
      loadedImage = SDL2::Image.load!(path_for(filename))
      optimizedImage = @screen.convert(loadedImage)
      loadedImage.free
      
      return optimizedImage
    end
    
    @window = SDL2::Window.create("Color Keying",:CENTERED,:CENTERED,640,480)
    @screen = @window.surface
    
    background = load_image('background.jpg')
    
    foo = load_image('foo.jpg')
        
    foo.color_key = foo.format.map_rgb([0, 0xFF, 0xFF])
    
    @screen.blit_in(background)
    @screen.blit_in(foo)
    
    @window.update_surface
    
    Approvals.verify(@screen, format: :png, name: "Color Keying Example")
    
    background.free
    foo.free
    
    SDL2.quit()
  end

end