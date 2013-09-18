require 'sdl2'

# Because SDL_rect.h defines the point struct too, include it here
require 'sdl2/point'

module SDL2

  class Rect < Struct
    layout :x, :int, :y, :int, :w, :int, :h, :int

    member_readers *members
    member_writers *members
    
    def self.cast(something)
      
      if something.kind_of?(Array) 
        something.map!(&:to_i)
        result = Rect.new
        case something.count
        when 4
          result.x, result.y, result.w, result.h = something
        when 2
          result.x, result.y = something
        else
          raise "#{self}#cast cannot convert array length #{something.count} of: #{something.inspect}"
        end
        return result
      else
        return super
      end
    end
    
    def empty
      return ((!self.null?) || (self[:w] <= 0) || (self[:h] <= 0))
    end

    alias_method :empty?, :empty

    def equals(other)    
      return false if other.nil?
      return false unless other.kind_of? Rect
      
      if self.null? or other.null? # Either null?
        return (self.null? and other.null?) # Equal if both are null!      
      else
        members.each do |field| # Compare our fields.
          return false unless self[field] == other[field]
        end
      end
      return true # if we made it this far
    end

  end

  api :SDL_HasIntersection, [Rect.by_ref, Rect.by_ref], :bool
  api :SDL_IntersectRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :bool
  api :SDL_UnionRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :void
  api :SDL_EnclosePoints, [Point.by_ref, :count, Rect.by_ref, Rect.by_ref], :bool
  api :SDL_IntersectRectAndLine, [Rect.by_ref, :int, :int, :int, :int], :bool

end