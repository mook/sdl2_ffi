require 'sdl2'

module SDL2

  module POWERSTATE
    include EnumerableConstants
    UNKOWN
    ON_BATTERY
    NO_BATTERY
    CHARGING
    CHARGED
  end
  enum :powerstate, POWERSTATE.flatten_consts

  
  ##
	#
	api :SDL_GetPowerInfo, [TypedPointer::Int.by_ref, TypedPointer::Int.by_ref], :powerstate

end