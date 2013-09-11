require 'sdl2'

# Because SDL_rect.h defines the point struct too, include it here
require 'sdl2/point'

module SDL2

  class Rect < FFI::Struct
    layout :x, :int, :y, :int, :w, :int, :h, :int
    
    
    def empty
      return ((!self.null?) || (self[:w] <= 0) || (self[:h] <= 0)) ? :true : :false
    end
    
    def empty?
      empty == :true
    end
    
    def equals(other)
      if self.null or other.null?
        return (self.null? and other.null?) ? :true : :false
      else 
        [:x, :y, :w, :h].each do |field|
          return :false unless self[field] == other[field]        
        end
      end
      return true # if we made it this far           
    end
        
        
  end
  
  attach_function :has_intersection, :SDL_HasIntersection, [Rect.by_ref, Rect.by_ref], :bool
  attach_function :intersect_rect, :SDL_IntersectRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :bool
  attach_function :union_rect, :SDL_UnionRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :void
  attach_function :enclose_points, :SDL_EnclosePoints, [Point.by_ref, :count, Rect.by_ref, Rect.by_ref], :bool
  attach_function :intersect_rect_and_line, :SDL_IntersectRectAndLine, [Rect.by_ref, :int, :int, :int, :int], :bool
  
  
end