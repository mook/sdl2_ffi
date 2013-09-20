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
  end
  enum :renderer_flip, FLIP.flatten_consts
    
  typedef :int, :render_driver_index
  
  ##
	#
	api :SDL_GetNumRenderDrivers, [], :int
  ##
	#
	api :SDL_GetRenderDriverInfo, [:render_driver_index, RendererInfo.by_ref], :int
  ##
	#
	api :SDL_CreateWindowAndRenderer, [:int, :int, :window_flags, Window.by_ref, Renderer.by_ref], :int
  ##
	#
	api :SDL_CreateRenderer, [Window.by_ref, :render_driver_index, :renderer_flags], Renderer.auto_ptr
  ##
	#
	api :SDL_CreateSoftwareRenderer, [Surface.by_ref], Renderer.auto_ptr
  ##
	#
	api :SDL_GetRenderer, [Window.by_ref], Renderer.auto_ptr
  ##
	#
	api :SDL_GetRendererInfo, [Renderer.by_ref, RendererInfo.by_ref], :int
  ##
	#
	api :SDL_GetRendererOutputSize, [Renderer.by_ref, IntStruct.by_ref, IntStruct.by_ref], :int
  ##
	#
	api :SDL_CreateTexture, [Renderer.by_ref, :pixel_format, :texture_access, :int, :int], Texture.auto_ptr
  ##
	#
	api :SDL_CreateTextureFromSurface, [Renderer.by_ref, Surface.by_ref], Texture.auto_ptr
  ##
	#
	api :SDL_QueryTexture, [Texture.by_ref, UInt32Struct.by_ref, IntStruct.by_ref, IntStruct.by_ref, IntStruct.by_ref], :int
  ##
	#
	api :SDL_SetTextureColorMod, [Texture.by_ref, :uint8, :uint8, :uint8], :int
  ##
	#
	api :SDL_GetTextureColorMod, [Texture.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref], :int
  ##
	#
	api :SDL_SetTextureAlphaMod, [Texture.by_ref, :uint8], :int
  ##
	#
	api :SDL_GetTextureAlphaMod, [Texture.by_ref, UInt8Struct.by_ref], :int
  ##
	#
	api :SDL_SetTextureBlendMode, [Texture.by_ref, :blend_mode], :int
  ##
	#
	api :SDL_GetTextureBlendMode, [Texture.by_ref, BlendModeStruct.by_ref], :int
  ##
	#
	api :SDL_UpdateTexture, [Texture.by_ref, Rect.by_ref, :pointer, :int], :int
  ##
	#
	api :SDL_LockTexture, [Texture.by_ref, Rect.by_ref, :pointer, IntStruct.by_ref], :int
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
	api :SDL_SetRenderTarget, [Renderer.by_ref, Texture.by_ref], :int
  ##
	#
	api :SDL_RenderSetLogicalSize, [Renderer.by_ref, :int, :int],:int
  ##
	#
	api :SDL_RenderGetLogicalSize, [Renderer.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  ##
	#
	api :SDL_RenderSetViewport, [Renderer.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_RenderGetViewport, [Renderer.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_RenderSetClipRect, [Renderer.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_RenderGetClipRect, [Renderer.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_RenderSetScale, [Renderer.by_ref, :float, :float], :int
  ##
	#
	api :SDL_RenderGetScale, [Renderer.by_ref, FloatPointer.by_ref, FloatPointer.by_ref], :int
  ##
	#
	api :SDL_SetRenderDrawColor, [Renderer.by_ref, :uint8, :uint8, :uint8, :uint8], :int
  ##
	#
	api :SDL_GetRenderDrawColor, [Renderer.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :int
  ##
	#
	api :SDL_SetRenderDrawBlendMode, [Renderer.by_ref, :blend_mode], :int
  ##
	#
	api :SDL_GetRenderDrawBlendMode, [Renderer.by_ref, BlendModeStruct.by_ref], :int
  ##
	#
	api :SDL_RenderClear, [Renderer.by_ref], :int
  ##
	#
	api :SDL_RenderDrawPoint, [Renderer.by_ref, :int, :int], :int
  ##
	#
	api :SDL_RenderDrawPoints, [Renderer.by_ref, Point.by_ref, :count], :int
  ##
	#
	api :SDL_RenderDrawLine, [Renderer.by_ref, :int, :int, :int, :int], :int
  ##
	#
	api :SDL_RenderDrawLines, [Renderer.by_ref, Point.by_ref, :count], :int
  ##
	#
	api :SDL_RenderDrawRect, [Renderer.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_RenderDrawRects, [Renderer.by_ref, Rect.by_ref, :count], :int
  ##
	#
	api :SDL_RenderFillRect, [Renderer.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_RenderFillRects, [Renderer.by_ref, Rect.by_ref, :count], :int
  ##
	#
	api :SDL_RenderCopy, [Renderer.by_ref, Texture.by_ref, Rect.by_ref, Rect.by_ref], :int
  ##
	#
	api :SDL_RenderCopyEx, [Renderer.by_ref, Texture.by_ref, Rect.by_ref, Rect.by_ref, :double, Point.by_ref, :renderer_flip], :int
  ##
	#
	api :SDL_RenderReadPixels, [Renderer.by_ref, Rect.by_ref, :pixel_format, :pointer, :int], :int #TODO: Review linking.
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
	api :SDL_GL_BindTexture, [Texture.by_ref, FloatPointer.by_ref, FloatPointer.by_ref], :int
  ##
	#
	api :SDL_GL_UnbindTexture, [Texture.by_ref], :int
  

end