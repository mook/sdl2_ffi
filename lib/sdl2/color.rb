require 'sdl2'

module SDL2

  #SDL_pixels.h:252~258
  class Color < Struct
    layout :r, :uint8,
    :g, :uint8,
    :b, :uint8,
    :a, :uint8

    [:r,:g,:b,:a].each do |field|
      define_method field do
        self[field]
      end
      define_method "#{field}=".to_sym do |value|
        self[field]=value
      end
    end

    def set(r,g,b,a=nil)
      self.r = r
      self.g = g
      self.b = b
      self.a = a unless a.nil?
    end

    def copy_from(color)
      [:r, :g, :b, :a].each do |c|
        self.send("#{c}=", color.send(c))
      end
    end
  end
  Colour = Color # Because SDL does it
end