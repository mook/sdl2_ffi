require 'ffi'
require 'sdl2/init'
module SDL2
  extend FFI::Library

  # TODO: Review default/hard-coded load paths?
  ffi_lib ['libSDL2','/usr/local/lib/libSDL2.so']

  # SDL_Bool
  enum :bool, [:false, 0, :true, 1]

  def throw_error_unless(condition)
    throw get_error() unless condition
  end
end
