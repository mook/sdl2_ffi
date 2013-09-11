require 'sdl2'

module SDL2  
  class GLContext < Struct
    layout :nothing, :uint8 # FIXME: This struct is just a pointer.
    
    def self.release(pointer)
      delete_context(pointer)
    end
    
    def self.create(window)
      SDL2.gl_create_context(window)
    end
    
    def self.create!(window)
      created = create(window)
      SDL2.throw_error_if(created.nil?)
      return created
    end
    
    
  end
end