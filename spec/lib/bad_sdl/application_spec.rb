require_relative '../../spec_helper'

require 'bad_sdl/application'


describe BadSdl::Application do
  before :each do
    SDL2.init(:EVERYTHING)
    @app = BadSdl::Application.new title: example.metadata[:example_group][:full_description]    
  end
  
  after :each do
    @app.quit()
    SDL2.quit
  end
  

  
  
  
  
end