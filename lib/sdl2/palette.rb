require 'sdl2'

module SDL2

  #SDL_pixels.h:261~267
  class Palette < FFI::Struct
    layout :ncolors, :int,
    :colors, :pointer,
    :version, :uint32,
    :refcount, :int

    def self.create(num_colors)
      SDL2.alloc_palette!(num_colors)
    end

    def self.release(pointer)
      SDL2.free_palette(pointer)
    end

    # \brief Set a range of colors in a palette
    # \param colors: An array of colors to copy into the palette
    # - Can be a FFI::Pointer, which is passed directly to the routine.
    # - Can be a ruby array, an FFI::Pointer array will be created and values
# copied:
    #   - Elements that are arrays are converted to SDL_Color in the FFI::Pointer
# array.
    #   - Elements that are Color structs are copied into the array.
    # \param firstcolor: The index of the first palette entry to modify.
    # \param ncolors: The number of entries to modify
    # - This defaults to the length of colors if colors is a Ruby Array
    def set_colors(colors, firstcolor = 0, ncolors = nil)
      
      if colors.kind_of? Array
        
        ncolors = colors.count if ncolors.nil?
        
        raise "(ncolors = #{ncolors} > colors.count #{colors.count}" if ncolors > colors.count
        
        # We must build our on colors pointer:
        colors_ptr = FFI::MemoryPointer.new(Color, ncolors)
        
        colors.each_with_index() { |color, idx|
          
          puts "color##{idx} = #{color.inspect}"
          
          if idx < ncolors # Skip when the array count is more than ncolors
        
            color_ptr = Color.new(colors_ptr[idx])
            
            if color.kind_of? Array          
              color_ptr.set(*color)
            elsif color.kind_of? Color
              color_ptr.copy_from(color)
            else
              raise "Invalid Array Member"
            end#if color.kind_of?
            
          end
          
        }#colors.each_with_index
        
        colors = colors_ptr # Replace the passed in argument with our pointer
        
      elsif colors.kind_of? FFI::Pointer
        raise "ncolors must be specified" if ncolors.nil?
        # Then we can just continue using it as is below.
      end# if
      binding.pry
      SDL2.set_palette_colors(self, colors, firstcolor, ncolors)
      
      
      
    end
  end
end