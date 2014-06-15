require 'approvals'
require 'approvals/rspec'
require_relative 'png_writer'
require 'sdl2/image'
require 'pry'

ImagesPath = File.expand_path('../fixtures/images', __FILE__)

def img_path(filename)
  path = File.expand_path(filename, ImagesPath)
  raise "Missing Image File: #{path}!" unless File.exist?(path)
  return path  
end

FixturesPath = File.expand_path('../fixtures',__FILE__)

def fixture(filename)
  path = File.expand_path(filename, FixturesPath)
  raise "Missing Fixture File: #{path}!" unless File.exist?(path)
  return path
end

#SDL2::Debug.enable(SDL2::Struct)

#at_exit do
#  SDL2.quit()
#end