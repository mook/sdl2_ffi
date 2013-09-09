require 'sdl2'

module SDL2
  
  
  def screen_saver?
    is_screen_saver_enabled == :true
  end
end