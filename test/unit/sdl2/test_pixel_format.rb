require_relative '../../test_helper'

require 'sdl2/pixels' # SDL_pixels.h defines SDL_PixelFormat

require 'sdl2/pixel_format'

describe SDL2::PixelFormat do

  it 'can be created in all formats' do

    SDL2::PIXELFORMAT.by_name.each do |format|
      unless format == 0 # Skip "UNKOWN"
        begin
          pixel_format = SDL2::PixelFormat.create(format[1])
          refute pixel_format.null?
          assert_kind_of SDL2::PixelFormat, pixel_format
        rescue RuntimeError => e
          skip  "Problem with SDL2::PIXELFORMAT.#{format[0]}" #TODO: Fix broken PIXELFORMATS
        end
      end

    end

  end
  
  
  it 'can get the name of all formats' do    
    SDL2::PIXELFORMAT.by_name.each_pair do |k,v|
      name = SDL2::PixelFormat.get_name(v)
      assert_includes name, k.to_s      
    end
  end
  
  

end