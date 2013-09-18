require 'approvals'
require 'approvals/rspec'


INPUT_FILE_DIR = File.expand_path('../input_files',__FILE__)

def input_file(named)
  file = File.expand_path(named, INPUT_FILE_DIR)
  raise "Missing Input File: #{named}!" unless File.exist?(file)
  return file
end

require 'pry'