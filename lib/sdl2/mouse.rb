require 'sdl2'

##
# ## SDL2 Mouse Support
# 
module SDL2

  class Cursor < Struct
    layout :private, :pointer
    def self.release(pointer)
      SDL2.free_cursor(pointer)
    end
    
    def self.create_color_cursor(surface, hot_x, hot_y)
      SDL2.create_color_cursor!(surface, hot_x, hot_y)
    end
  end

  enum :system_cursor, [:ARROW,:IBEAM,:WAIT,:CROSSHAIR,:WAITARROW,:SIZENWSE,:SIZENESW,:SIZEWE,
    :SIZENS,:SIZEALL,:NO,:HAND]

  api :SDL_GetMouseFocus, [], Window.by_ref
  api :SDL_GetMouseState, [TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :uint32
  api :SDL_GetRelativeMouseState, [TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :uint32
  api :SDL_WarpMouseInWindow, [Window.by_ref, :int, :int], :void
  api :SDL_SetRelativeMouseMode, [:bool], :int
  api :SDL_GetRelativeMouseMode, [], :bool
  api :SDL_CreateCursor, [:pointer, :pointer, :int, :int, :int, :int], Cursor.ptr
  api :SDL_CreateColorCursor, [Surface.by_ref, :int, :int], Cursor.ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  api :SDL_CreateSystemCursor, [:system_cursor], Cursor.ptr
  api :SDL_GetCursor, [], Cursor.by_ref
  api :SDL_GetDefaultCursor, [], Cursor.by_ref
  api :SDL_FreeCursor, [Cursor.by_ref], :void
  api :SDL_ShowCursor, [:int], :int

  module Mouse

    def self.button(num)
      1 << (num-1)
    end
    
    module BUTTON
      include EnumerableConstants
      LEFT
      MIDDLE 
      RIGHT 
      X1 
      X2 
    end
    
    module BUTTONMASK
      def self.for_enum button_enum 
        1 << (button_enum-1)
      end
      include EnumerableConstants
      LEFT = for_enum(BUTTON::LEFT)
      MIDDLE = for_enum(BUTTON::MIDDLE)
      RIGHT = for_enum(BUTTON::RIGHT)
      X1 = for_enum(BUTTON::X1)
      X2 = for_enum(BUTTON::X2)
    end

  end

end