require 'sdl2'

module SDL2
  
  Powerstate = enum :powerstate, [:UNKOWN, :ON_BATTERY, :NO_BATTERY, :CHARGING, :CHARGED]
  
  api :SDL_GetPowerInfo, [IntStruct.by_ref, IntStruct.by_ref], :powerstate
  
end