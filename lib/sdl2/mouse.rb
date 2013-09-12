require 'sdl2'
require 'yinum'

module SDL2

  class Cursor < Struct

    def self.release(pointer)
      SDL2.free_cursor(pointer)
    end
  end

  enum :system_cursor, [:ARROW,:IBEAM,:WAIT,:CROSSHAIR,:WAITARROW,:SIZENWSE,:SIZENESW,:SIZEWE,
    :SIZENS,:SIZEALL,:NO,:HAND]

  api :SDL_GetMouseFocus, [], Window.by_ref
  api :SDL_GetMouseState, [IntStruct.by_ref, IntStruct.by_ref], :uint32
  api :SDL_GetRelativeMouseState, [IntStruct.by_ref, IntStruct.by_ref], :uint32
  api :SDL_WarpMouseInWindow, [Window.by_ref, :int, :int], :void
  api :SDL_SetRelativeMouseMode, [:bool], :int
  api :SDL_GetRelativeMouseMode, [], :bool
  api :SDL_CreateCursor, [:pointer, :pointer, :int, :int, :int, :int], Cursor.auto_ptr
  api :SDL_CreateColorCursor, [Surface.by_ref, :int, :int], Cursor.auto_ptr
  api :SDL_CreateSystemCursor, [:system_cursor], Cursor.auto_ptr
  api :SDL_GetCursor, [], Cursor.by_ref
  api :SDL_GetDefaultCursor, [], Cursor.by_ref
  api :SDL_FreeCursor, [Cursor.by_ref], :void
  api :SDL_ShowCursor, [:int], :int

  module Mouse

    def self.button(num)
      1 << (num-1)
    end

    Button = Enum.new(:MOUSE_BUTTONS, {
      :LEFT => 1,
      :MIDDLE => 2,
      :RIGHT => 3,
      :X1 => 4,
      :X2 => 5
    })

    ButtonMask = Enum.new(:MOUSE_BUTTON_MASK, {
      :LEFT => button(Button.LEFT),
      :MIDDLE => button(Button.MIDDLE),
      :RIGHT => button(Button.RIGHT),
      :X1 => button(Button.X1),
      :X2 => button(Button.X2)
    })

  end

end