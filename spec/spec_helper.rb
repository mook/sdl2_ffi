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


