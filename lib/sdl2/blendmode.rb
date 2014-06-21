module SDL2
  module BLENDMODE
    include EnumerableConstants
    NONE = 0x00000000
    BLEND = 0x00000001
    ADD = 0x00000002
    MOD = 0x00000004
  end
  
  enum :blend_mode, BLENDMODE.flatten_consts

  class SDL2::TypedPointer::BlendMode < SDL2::TypedPointer
    layout :value, :blend_mode
  end

end