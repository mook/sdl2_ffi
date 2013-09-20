require 'sdl2'
require 'sdl2/joystick'

module SDL2
  enum :controller_bindtype, [:NONE, 0, :BUTTON, :AXIS, :HAT]

  class GameController < Struct

    class ButtonBind < Struct

      class ValueUnion < FFI::Union

        class HatStruct < FFI::Struct
          layout :hat, :int, :hat_mask, :int
        end #HatStruct

        layout :button, :int,
        :axis, :int,
        :hat, HatStruct
      end#ValueUnion

      layout :bindType, :controller_bindtype,
      :value, ValueUnion
    end#ButtonBind
    
    #GameController
    def self.release(pointer)
      SDL2.game_controller_close(pointer)
    end

  end#GameController
  
  api :SDL_GameControllerAddMapping, [:string], :int
  api :SDL_GameControllerMappingForGUID, [JoystickGUID.by_value], :string
  api :SDL_GameControllerMapping, [GameController.by_ref], :string
  api :SDL_IsGameController, [:joystick_index], :bool
  api :SDL_GameControllerNameForIndex, [:joystick_index], :string
  api :SDL_GameControllerOpen, [:joystick_index], :string
  api :SDL_GameControllerName, [GameController.by_ref], :string
  api :SDL_GameControllerGetAttached, [GameController.by_ref], :bool
  api :SDL_GameControllerGetJoystick, [GameController.by_ref], Joystick.by_ref
  api :SDL_GameControllerEventState, [:int], :int
  api :SDL_GameControllerUpdate, [], :void
  
  enum :game_controller_axis, [:INVALID, -1, :LEFTX, :LEFTY, :RIGHTX, :RIGHTY, :TRIGGERLEFT, :TRIGGERRIGHT, :MAX]
  
  api :SDL_GameControllerGetAxisFromString, [:string], :game_controller_axis  
  api :SDL_GameControllerGetStringForAxis, [:game_controller_axis], :string
  api :SDL_GameControllerGetBindForAxis, [GameController.by_ref, :game_controller_axis], GameController::ButtonBind
  api :SDL_GameControllerGetAxis, [GameController.by_ref, :game_controller_axis], :int16
  
  enum :game_controller_button, [:INVLIAD, -1, 
    :A, :B, :X, :Y, :BACK, :GUIDE, :START, 
    :LEFTSTICK, :RIGHTSTICK, :LEFTSHOULDER, :RIGHTSHOULDER, 
    :DPAD_UP, :DPAD_DOWN, :DPAD_LEFT, :DPAD_RIGHT]
    
  api :SDL_GameControllerGetButtonFromString, [:string], :game_controller_button
  api :SDL_GameControllerGetStringForButton, [:game_controller_button], :string
  api :SDL_GameControllerGetBindForButton, [GameController.by_ref, :game_controller_button], GameController::ButtonBind
  api :SDL_GameControllerGetButton, [GameController.by_ref, :game_controller_button], :uint8
  api :SDL_GameControllerClose, [GameController.by_ref], :void
end