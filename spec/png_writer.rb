require 'approvals'

class Approvals::Writers::PngWriter < Approvals::Writers::BinaryWriter
  
  WRITE_PROC = Proc.new do |data, file|
    # Bind to prototype
    FileUtils.mkdir_p(File.dirname(file))
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