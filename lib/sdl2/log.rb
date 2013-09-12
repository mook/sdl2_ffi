require 'sdl2'

module SDL2

  class Log
    private_class_method :new # Disable creation

    def self.<<(msg, *args)
      SDL2.log(msg, *args)
    end
    
    def self.critical(category, msg, *args)
      SDL2.log_critical(category, msg, *args)
    end
    
    def self.debug(category, msg, *args)
      SDL2.log_debug(category, msg, *args)
    end
    
    def self.error(category, msg, *args)
      SDL2.log_error(category, msg, *args)
    end
    
    def self.warn(category, msg, *args)
      SDL2.log_warn(category, msg, *args)      
    end
    
    def self.verbose(category, msg, *args)
      SDL2.log_verbose(category, msg, *args)
    end
    
    def self.set_priority(category, priority)
      SDL2.log_set_priority(category, priority)
    end
    
    def self.get_priority(category)
      SDL2.log_get_priority(category)
    end
  end

  enum :log_priority, [:verbose, 1, :debug, :info, :warn, :error, :critical]

  enum :log_category, [
    :application, :error, :assert, :system, :audio, :video, :render, :input, :test,
    :reserved1,:reserved2,:reserved3,:reserved4,:reserved5,
    :reserved6,:reserved7,:reserved8,:reserved9,:reserved10,
    :custom
  ]
  
  
  
  callback :log_output_function, [:pointer, :log_category, :log_priority, :string], :void

  api :SDL_Log, [:string, :varargs], :void
  api :SDL_LogCritical, [:log_category, :string, :varargs], :void
  api :SDL_LogDebug, [:log_category, :string, :varargs], :void
  api :SDL_LogError, [:log_category, :string, :varargs], :void
  api :SDL_LogInfo, [:log_category, :string, :varargs], :void
  api :SDL_LogVerbose, [:log_category, :string, :varargs], :void
  api :SDL_LogWarn, [:log_category, :string, :varargs], :void
  api :SDL_LogMessage, [:log_category, :log_priority, :string, :varargs], :void
  api :SDL_LogMessageV, [:log_category, :log_priority, :string, :varargs], :void
  api :SDL_LogResetPriorities, [], :void
  api :SDL_LogSetAllPriority, [:log_priority], :void
  api :SDL_LogGetOutputFunction, [:log_output_function, :pointer], :void
  api :SDL_LogSetOutputFunction, [:log_output_function, :pointer], :void
  api :SDL_LogSetPriority, [:log_category, :log_priority], :void
  api :SDL_LogGetPriority, [:log_category], :log_priority

end