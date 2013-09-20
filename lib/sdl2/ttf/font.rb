module SDL2

  module TTF

    # Internal structure containing font information
    class Font < Struct

      class FT_Bitmap < Struct
        layout :rows, :int,
        :width, :int,
        :pitch, :int,
        :buffer, :string,
        :num_grays, :short,
        :pixel_mode, :char,
        :palette_mode, :char,
        :palette, :pointer
      end

      class FT_Open_Args < Struct
        layout :flags, :uint,
        :memory_base, :uint8,
        :memory_size, :long,
        :pathname, :string,
        :stream, :pointer,
        :module, :pointer,
        :num_params, :int,
        :params, :pointer
      end

      class CachedGlyph < Struct
        layout :stored, :int,
        :index, :uint,
        :bitmap, FT_Bitmap,
        :pixmap, FT_Bitmap,
        :minx, :int,
        :maxx, :int,
        :miny, :int,
        :maxy, :int,
        :yoffset, :int,
        :advance, :int,
        :cached, :uint16
      end

      layout :face, :pointer,

      :height, :int,
      :ascent, :int,
      :descent, :int,
      :lineskip, :int,

      :face_style, :int,
      :style, :int,
      :outline, :int,

      :kerning, :int,

      :glyph_overhang, :int,
      :glyph_italics, :float,

      :underline_offset, :int,
      :underline_height, :int,

      :current, CachedGlyph.by_ref,
      :cache, [CachedGlyph, 257], # SDL_ttf.c: Line 95

      :src, SDL2::RWops.by_ref,
      :freesrc, :int,
      :args, FT_Open_Args,

      :font_size_family, :int,

      :hinting, :int

      def self.open(file, pt_size)
        TTF.open_font!(file, pt_size)
      end

      def self.release(pointer)
        TTF.close_font(pointer)
      end
      
      def close()
        TTF.close_font(self)
      end
      
      alias_method :free, :close

      def render_text_solid(text, color = [255,255,255])
        color = Color.cast(color)
        TTF.render_text_solid!(self, text, color)
      end

      def render_text_shaded(text, fg = [255,255,255,255], bg = [0,0,0,0] )
        fg = Color.cast(fg)
        bg = Color.cast(bg)
        TTF.render_text_shaded!(self, text, fg, bg)
      end

      def render_text_blended(text, fg = [255, 255, 255, 255])
        #binding.pry
        fg = Color.cast(fg)
        #binding.pry
        TTF.render_text_blended!(self, text, fg)
      end
      
      def render_text_blended_wrapped(text, width, fg = [255,255,255,255])
        fg = Color.cast(fg)
        TTF.render_text_blended_wrapped!(self, text, fg, width)
      end

    end

  end

end