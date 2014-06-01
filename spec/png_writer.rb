require 'approvals'

##
# This class connects SDL's png writer to Approval's Abstract Binary Writer
class Approvals::Writers::PngWriter < Approvals::Writers::BinaryWriter
  
  ##
  # This Proc will be used to write data
  WRITE_PROC = Proc.new do |data, file|
    # Bind to prototype
    FileUtils.mkdir_p(File.dirname(file))
    SDL2::Image.save_png(data,file)
  end
  
  ##
  # This Proc will be used to detect if we could write to PNGs
  DETECT_PROC = Proc.new do |subject|    
    subject.kind_of? SDL2::Surface
  end
  
  ##
  # Setup the PngWriter
  def initialize()
    super(format: :png, extension: 'png', write: WRITE_PROC, detect: DETECT_PROC) 
  end
  
end

Approvals::Writers::PngWriter.instance # Should register writer.