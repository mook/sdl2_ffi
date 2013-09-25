require_relative 'sdl2_helper'

require 'sdl2/application'


describe Application do
  before :each do
    @app = Application.new title: example.metadata[:example_group][:full_description]    
  end
  
  after :each do
    @app.quit()
  end
  

  
  
  
  
end