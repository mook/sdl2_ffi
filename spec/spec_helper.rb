require 'approvals'
require 'approvals/rspec'

require 'sdl2/image'

class Approvals::Writers::PngWriter < Approvals::Writers::BinaryWriter
  
  WRITE_PROC = Proc.new do |data, file|
    SDL2::Image.save_png(data,file)
  end
  
  DETECT_PROC = Proc.new do |subject|
    subject.kind_of? SDL2::Surface
  end
  
  def initialize()
    super(format: :png, extension: 'png', write: WRITE_PROC, detect: DETECT_PROC) 
  end
  
end

Approvals::Writers::PngWriter.instance # Should register writer.


INPUT_FILE_DIR = File.expand_path('../input_files',__FILE__)

def input_file(named)
  file = File.expand_path(named, INPUT_FILE_DIR)
  raise "Missing Input File: #{named}!" unless File.exist?(file)
  return file
end

require 'pry'