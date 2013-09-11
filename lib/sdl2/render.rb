require 'sdl2'
require 'sdl2/video'
require 'sdl2/renderer'
require 'sdl2/texture'
require 'sdl2/point'

module SDL2
  # lines 64~73
  enum :renderer_flags, [
    :software, Renderer::SOFTWARE,
    :accelerated, Renderer::ACCELERATED,
    :present_vsync, Renderer::PRESENTVSYNC,
    :target_texture, Renderer::TARGETTEXTURE
  ]
  # lines 91~96
  enum :texture_access, [:static, :streaming, :target]
  # lines 101~106
  enum :texture_modulate, [:none, 0x00000000, :color, 0x00000001, :alpha, 0x00000002]
  # lines 111~116
  enum :renderer_flip, [:none, 0x00000000, :horizontal, 0x00000001, :vertical, 0x00000002]
    
  typedef :int, :render_driver_index
  attach_function :get_num_render_drivers, :SDL_GetNumRenderDrivers, [], :int
  attach_function :get_render_driver_info, :SDL_GetRenderDriverInfo, [:render_driver_index, RendererInfo.by_ref], :int
  attach_function :create_window_and_renderer, :SDL_CreateWindowAndRenderer, [:int, :int, :window_flags, Window.by_ref, Renderer.by_ref], :int
  attach_function :create_renderer, :SDL_CreateRenderer, [Window.by_ref, :render_driver_index, :renderer_flags], Renderer.auto_ptr
  attach_function :create_software_renderer, :SDL_CreateSoftwareRenderer, [Surface.by_ref], Renderer.auto_ptr
  attach_function :get_renderer, :SDL_GetRenderer, [Window.by_ref], Renderer.auto_ptr
  attach_function :get_renderer_info, :SDL_GetRendererInfo, [Renderer.by_ref, RendererInfo.by_ref], :int
  attach_function :get_renderer_output_size, :SDL_GetRendererOutputSize, [Renderer.by_ref, IntStruct.by_ref, IntStruct.by_ref], :int
  attach_function :create_texture, :SDL_CreateTexture, [Renderer.by_ref, :pixel_format, :texture_access, :int, :int], Texture.auto_ptr
  attach_function :create_texture_from_surface, :SDL_CreateTextureFromSurface, [Renderer.by_ref, Surface.by_ref], Texture.auto_ptr
  attach_function :query_texture, :SDL_QueryTexture, [Texture.by_ref, UInt32Struct.by_ref, IntStruct.by_ref, IntStruct.by_ref, IntStruct.by_ref], :int
  attach_function :set_texture_color_mod, :SDL_SetTextureColorMod, [Texture.by_ref, :uint8, :uint8, :uint8], :int
  attach_function :get_texture_color_mod, :SDL_GetTextureColorMod, [Texture.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref, UInt8Struct.by_ref], :int
  attach_function :set_texture_alpha_mod, :SDL_SetTextureAlphaMod, [Texture.by_ref, :uint8], :int
  attach_function :get_texture_alpha_mod, :SDL_GetTextureAlphaMod, [Texture.by_ref, UInt8Struct.by_ref], :int
  attach_function :set_texture_blend_mode, :SDL_SetTextureBlendMode, [Texture.by_ref, :blend_mode], :int
  attach_function :get_texture_blend_mode, :SDL_GetTextureBlendMode, [Texture.by_ref, BlendModeStruct.by_ref], :int
  attach_function :update_texture, :SDL_UpdateTexture, [Texture.by_ref, Rect.by_ref, :pointer, :int], :int
  attach_function :lock_texture, :SDL_LockTexture, [Texture.by_ref, Rect.by_ref, :pointer, IntStruct.by_ref], :int
  attach_function :unlock_texture, :SDL_UnlockTexture, [Texture.by_ref], :void
  attach_function :render_target_supported, :SDL_RenderTargetSupported, [Renderer.by_ref], :bool
  attach_function :get_render_target, :SDL_GetRenderTarget, [Renderer.by_ref], Texture.by_ref
  attach_function :set_render_target, :SDL_SetRenderTarget, [Renderer.by_ref, Texture.by_ref], :int
  attach_function :render_set_logical_size, :SDL_RenderSetLogicalSize, [Renderer.by_ref, :int, :int],:int
  attach_function :render_get_logical_size, :SDL_RenderGetLogicalSize, [Renderer.by_ref, IntStruct.by_ref, IntStruct.by_ref], :void
  attach_function :render_set_viewport, :SDL_RenderSetViewport, [Renderer.by_ref, Rect.by_ref], :int
  attach_function :render_get_viewport, :SDL_RenderGetViewport, [Renderer.by_ref, Rect.by_ref], :int
  attach_function :render_set_clip_rect, :SDL_RenderSetClipRect, [Renderer.by_ref, Rect.by_ref], :int
  attach_function :render_get_clip_rect, :SDL_RenderGetClipRect, [Renderer.by_ref, Rect.by_ref], :int
  attach_function :render_set_scale, :SDL_RenderSetScale, [Renderer.by_ref, :float, :float], :int
  attach_function :render_get_scale, :SDL_RenderGetScale, [Renderer.by_ref, FloatStruct.by_ref, FloatStruct.by_ref], :int
  attach_function :set_render_draw_color, :SDL_SetRenderDrawColor, [Renderer.by_ref, :uint8, :uint8, :uint8, :uint8], :int
  attach_function :get_render_draw_color, :SDL_GetRenderDrawColor, [Renderer.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :int
  attach_function :set_render_draw_blend_mode, :SDL_SetRenderDrawBlendMode, [Renderer.by_ref, :blend_mode], :int
  attach_function :get_render_draw_blend_mode, :SDL_GetRenderDrawBlendMode, [Renderer.by_ref, BlendModeStruct.by_ref], :int
  attach_function :render_clear, :SDL_RenderClear, [Renderer.by_ref], :int
  attach_function :render_draw_point, :SDL_RenderDrawPoint, [Renderer.by_ref, :int, :int], :int
  attach_function :render_draw_points, :SDL_RenderDrawPoints, [Renderer.by_ref, Point.by_ref, :count], :int
  attach_function :render_draw_line, :SDL_RenderDrawLine, [Renderer.by_ref, :int, :int, :int, :int], :int
  attach_function :render_draw_lines, :SDL_RenderDrawLines, [Renderer.by_ref, Point.by_ref, :count], :int
  attach_function :render_draw_rect, :SDL_RenderDrawRect, [Renderer.by_ref, Rect.by_ref], :int
  attach_function :render_draw_rects, :SDL_RenderDrawRects, [Renderer.by_ref, Rect.by_ref, :count], :int
  attach_function :render_fill_rect, :SDL_RenderFillRect, [Renderer.by_ref, Rect.by_ref], :int
  attach_function :render_fill_rects, :SDL_RenderFillRects, [Renderer.by_ref, Rect.by_ref, :count], :int
  attach_function :render_copy, :SDL_RenderCopy, [Renderer.by_ref, Texture.by_ref, Rect.by_ref, Rect.by_ref], :int
  attach_function :render_copy_ex, :SDL_RenderCopyEx, [Renderer.by_ref, Texture.by_ref, Rect.by_ref, Rect.by_ref, :double, Point.by_ref, :renderer_flip], :int
  attach_function :render_read_pixels, :SDL_RenderReadPixels, [Renderer.by_ref, Rect.by_ref, :pixel_format, :pointer, :int], :int #TODO: Review linking.
  attach_function :render_present, :SDL_RenderPresent, [Renderer.by_ref], :void
  attach_function :destroy_texture, :SDL_DestroyTexture, [Texture.by_ref], :void
  attach_function :destroy_renderer, :SDL_DestroyRenderer, [Renderer.by_ref], :void
  attach_function :gl_bind_texture, :SDL_GL_BindTexture, [Texture.by_ref, FloatStruct.by_ref, FloatStruct.by_ref], :int
  attach_function :gl_unbind_texture, :SDL_GL_UnbindTexture, [Texture.by_ref], :int
  

end