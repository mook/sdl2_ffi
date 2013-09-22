require 'sdl2'

module SDL2

  #SDL_pixels.h:252~258
  class Color < Struct
    layout :r, :uint8,
    :g, :uint8,
    :b, :uint8,
    :a, :uint8

    member_readers *members
    member_writers *members

    def self.create(values = {})
      values[:a] ||= ALPHA_OPAQUE
       super(values)
    end

    # If possible, convert argument into a SDL::Color
    def self.cast(something)
      if something.kind_of? Array
        something.map!(&:to_i)
        result = new
        result.set(*something)

        return result
      else
        return super
      end
    end

    def set(r,g,b,a=nil)
      self.r = r
      self.g = g
      self.b = b
      self.a = a.nil? ? ALPHA_OPAQUE : a
    end

    def copy_from(color)
      [:r, :g, :b, :a].each do |c|
        self.send("#{c}=", color.send(c))
      end
    end

    def to_a
      [r, g, b, a]
    end
  end
  # Alternative spelling of Color
  Colour = Color # Because SDL does it
end