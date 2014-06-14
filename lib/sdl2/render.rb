require 'sdl2'
require 'sdl2/video'
require 'sdl2/renderer'
require 'sdl2/texture'
require 'sdl2/point'

module SDL2
  enum :renderer_flags, RENDERER.flatten_consts
  # The access pattern allowed for a texture
  module TEXTUREACCESS
    include EnumerableConstants
    STATIC
    STREAMING
    TARGET
  end
  enum :texture_access, TEXTUREACCESS.flatten_consts

  # The texture channel modulation used in #render_copy
  module TEXTUREMODULATE
    include EnumerableConstants
    NONE = 0x00000000
    COLOR = 0x00000001
    ALPHA = 0x00000002
  end
  enum :texture_modulate, TEXTUREMODULATE.flatten_consts

  # Constants for #render_copy_ex
  module FLIP
    include EnumerableConstants
    NONE = 0x00000000
    HORIZONTAL = 0x00000001
    VERTICAL = 0x00000002
    BOTH = HORIZONTAL | VERTICAL
  end
  enum :renderer_flip, FLIP.flatten_consts

  typedef :int, :render_driver_index

  ##
  #
  api :SDL_GetNumRenderDrivers, [], :int, {error: true, filter: OK_WHEN_GTE_ZERO}
  ##
  #
  api :SDL_GetRenderDriverInfo, [:render_driver_index, RendererInfo.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_CreateWindowAndRenderer, [:int, :int, :window_flags, Window.by_ref, Renderer.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_CreateRenderer, [Window.by_ref, :render_driver_index, :renderer_flags], Renderer.auto_ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  #
  api :SDL_CreateSoftwareRenderer, [Surface.by_ref], Renderer.auto_ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  #
  api :SDL_GetRenderer, [Window.by_ref], Renderer.auto_ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  #
  api :SDL_GetRendererInfo, [Renderer.by_ref, RendererInfo.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_GetRendererOutputSize, [Renderer.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_CreateTexture, [Renderer.by_ref, :pixel_format, :texture_access, :int, :int], Texture.auto_ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  #
  api :SDL_CreateTextureFromSurface, [Renderer.by_ref, Surface.by_ref], Texture.auto_ptr, {error: true, filter: OK_WHEN_NOT_NULL}
  ##
  #
  api :SDL_QueryTexture, [Texture.by_ref, TypedPointer::UInt32.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SetTextureColorMod, [Texture.by_ref, :uint8, :uint8, :uint8], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_GetTextureColorMod, [Texture.by_ref, TypedPointer::UInt8.by_ref, TypedPointer::UInt8.by_ref, TypedPointer::UInt8.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SetTextureAlphaMod, [Texture.by_ref, :uint8], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_GetTextureAlphaMod, [Texture.by_ref, TypedPointer::UInt8.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SetTextureBlendMode, [Texture.by_ref, :blend_mode], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_GetTextureBlendMode, [Texture.by_ref, BlendModeStruct.by_ref], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_UpdateTexture, [Texture.by_ref, Rect.by_ref, :pointer, :int], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_LockTexture, [Texture.by_ref, Rect.by_ref, :pointer, TypedPointer::Int.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_UnlockTexture, [Texture.by_ref], :void
  ##
  #
  api :SDL_RenderTargetSupported, [Renderer.by_ref], :bool
  ##
  #
  api :SDL_GetRenderTarget, [Renderer.by_ref], Texture.by_ref
  ##
  #
  api :SDL_SetRenderTarget, [Renderer.by_ref, Texture.by_ref], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderSetLogicalSize, [Renderer.by_ref, :int, :int],:int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderGetLogicalSize, [Renderer.by_ref, TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :void
  ##
  #
  api :SDL_RenderSetViewport, [Renderer.by_ref, Rect.by_ref], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderGetViewport, [Renderer.by_ref, Rect.by_ref], :int
  ##
  #
  api :SDL_RenderSetClipRect, [Renderer.by_ref, Rect.by_ref], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderGetClipRect, [Renderer.by_ref, Rect.by_ref], :int,{error: true, filter: OK_WHEN_ZERO}

  ##
  #
  api :SDL_RenderSetScale, [Renderer.by_ref, :float, :float], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderGetScale, [Renderer.by_ref, TypedPointer::Float.by_ref, TypedPointer::Float.by_ref], :int
  ##
  #
  api :SDL_SetRenderDrawColor, [Renderer.by_ref, :uint8, :uint8, :uint8, :uint8], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_GetRenderDrawColor, [Renderer.by_ref, TypedPointer::UInt8.by_ref,TypedPointer::UInt8.by_ref,TypedPointer::UInt8.by_ref,TypedPointer::UInt8.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_SetRenderDrawBlendMode, [Renderer.by_ref, :blend_mode], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_GetRenderDrawBlendMode, [Renderer.by_ref, BlendModeStruct.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderClear, [Renderer.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderDrawPoint, [Renderer.by_ref, :int, :int], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderDrawPoints, [Renderer.by_ref, Point.by_ref, :count], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderDrawLine, [Renderer.by_ref, :int, :int, :int, :int], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderDrawLines, [Renderer.by_ref, Point.by_ref, :count], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderDrawRect, [Renderer.by_ref, Rect.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderDrawRects, [Renderer.by_ref, Rect.by_ref, :count], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderFillRect, [Renderer.by_ref, Rect.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderFillRects, [Renderer.by_ref, Rect.by_ref, :count], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderCopy, [Renderer.by_ref, Texture.by_ref, Rect.by_ref, Rect.by_ref], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderCopyEx, [Renderer.by_ref, Texture.by_ref, Rect.by_ref, Rect.by_ref, :double, Point.by_ref, :renderer_flip], :int, {error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderReadPixels, [Renderer.by_ref, Rect.by_ref, :pixel_format, :pointer, :int], :int,{error: true, filter: OK_WHEN_ZERO}
  ##
  #
  api :SDL_RenderPresent, [Renderer.by_ref], :void
  ##
  #
  api :SDL_DestroyTexture, [Texture.by_ref], :void
  ##
  #
  api :SDL_DestroyRenderer, [Renderer.by_ref], :void
  ##
  #
  api :SDL_GL_BindTexture, [Texture.by_ref, TypedPointer::Float.by_ref, TypedPointer::Float.by_ref], :int
  ##
  #
  api :SDL_GL_UnbindTexture, [Texture.by_ref], :int

end