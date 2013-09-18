require 'sdl2'

module SDL2
  class Point < Struct
    layout :x, :int, :y, :int
    
    member_readers *members
    member_writers *members
    
    def self.cast(something)
      if something.kind_of?(Array) and something.count == 2
        something.map!(&:to_i) 
        result = Point.new
        result.x, result.y = something
        return result
      else      
        return super
      end
    end
    
    
  end
end