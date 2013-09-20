require 'sdl2'

# Because SDL_rect.h defines the point struct too, include it here
require 'sdl2/point'

module SDL2

  class Rect < Struct
    layout :x, :int, :y, :int, :w, :int, :h, :int

    member_readers *members
    member_writers *members

    # Automatically construct a Rect out of something.
    # * Accepts an array of &:to_i with length 2 or 4 as [x, y, [w, h]]
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

    # Returns true if the rectangle has no area.
    def empty
      return ((!self.null?) || (self[:w] <= 0) || (self[:h] <= 0))
    end

    alias_method :empty?, :empty

    # SDL Defines a macro that is roughly the same as Struct#==
    alias_method :equals, :==
    # TODO: Review for removal.  Originally this was a MACRO reimplementation, 
    # but has since been replaced with a working #== methond on SDL2::Struct
    #
    #    def equals(other)
    #      return false if other.nil?
    #      return false unless other.kind_of? Rect
    #
    #      if self.null? or other.null? # Either null?
    #        return (self.null? and other.null?) # Equal if both are null!
    #      else
    #        members.each do |field| # Compare our fields.
    #          return false unless self[field] == other[field]
    #        end
    #      end
    #      return true # if we made it this far
    #    end

    
    # Determine whether two rectangles intersect.
    # @param Another rectangle to test against.
    # @return True when they touch, false when they don't
    def has_intersection?(rect)
      rect = Rect.cast(rect)
      SDL2.has_intersection?(self, rect)
    end
    
    # Calculate the intersection of two rectangles.
    # @param Another rectangle to find intersection with self.
    # @return Rect or Nil if no intersection found. 
    def intersection(rect)
      rect = Rect.cast(rect)
      result = Rect.new
      if SDL2.intersect_rect?(self, rect, result)
        return result
      else
        result.free
        return nil
      end
    end
    # I prefer #intersection, but aliased for compatibility.
    alias_method :intersect_rect, :intersection 
    
    # Calculate the union of two rectangles.
    def union(rect)
      rect = Rect.cast(rect)
      result = Rect.new
      SDL2.union_rect(self, rect, result)
      return result
    end
    
    # Calculate a minimal rectangle enclosing a set of points
    def enclose_points(points, count = nil, clip = self)
      clip = Rect.cast(clip)
      points, count = Point.cast_array(points, count)
      result = Rect.new
      if SDL2.enclose_points?(points, count, clip, result)
        return result
      else
        result.free
        return nil
      end
    end
      
    # Calculate the intersection of a rectangle and line segment.
    def intersect_line(x1, y1, x2, y2)
      result = Rect.new
      if SDL2.intersect_rect_and_line(self, x1, y1, x2, y2)
        return result
      else
        result.free
        return nil
      end
    end

  end

  ##
  # Determine whether two rectangles intersect.
  api :SDL_HasIntersection, [Rect.by_ref, Rect.by_ref], :bool
  ##
  # Calculate the intersection of two rectangles.
  api :SDL_IntersectRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :bool
  ##
  # Calculate the union of two rectangles.
  api :SDL_UnionRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :void
  ##
  # Calculate a minimal rectangle enclosing a set of points
  api :SDL_EnclosePoints, [Point.by_ref, :count, Rect.by_ref, Rect.by_ref], :bool
  ##
  # Calculate the intersection of a rectangle and a line segment.
  api :SDL_IntersectRectAndLine, [Rect.by_ref, :int, :int, :int, :int], :bool

end