require 'sdl2'

module SDL2

  class Display
    
    class Modes
      # TODO: Consider converting this into some kind of enumerator?
      def initialize(for_display)
        @for_display = for_display
      end

      def count
        SDL2.get_num_display_modes(@for_display.id)
      end

      # TODO: Probably leaks memory.. WeakRef cache?
      def [](index)
        if (idx = index.to_i) < count
          dm_buffer = SDL2::Display::Mode.new
          if SDL2.get_display_mode(@for_display.id, idx, dm_buffer) == 0
            return dm_buffer
          else
            dm_buffer.pointer.free
          end
        else
          return nil
        end
      end

      def first
        self[0]
      end
    end
  end
end