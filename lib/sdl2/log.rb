require 'sdl2'
 
module SDL2
  enum :log_priority, [:verbose, 1, :debug, :info, :warn, :error, :critical]
    
  enum :log_category, [
    :application, :error, :assert, :system, :audio, :video, :render, :input, :test,
    :reserved1,:reserved2,:reserved3,:reserved4,:reserved5,
    :reserved6,:reserved7,:reserved8,:reserved9,:reserved10,
    :custom
  ]
              
  callback :log_output_function, [:pointer, :log_category, :log_priority, :string], :void
    
  attach_function :log,           :SDL_Log, [:string, :varargs], :void
  attach_function :log_critical,  :SDL_LogCritical, [:log_category, :string, :varargs], :void
  attach_function :log_debug,     :SDL_LogDebug, [:log_category, :string, :varargs], :void
  attach_function :log_error,     :SDL_LogError, [:log_category, :string, :varargs], :void
  attach_function :log_info,      :SDL_LogInfo, [:log_category, :string, :varargs], :void
  attach_function :log_verbose,   :SDL_LogVerbose, [:log_category, :string, :varargs], :void
  attach_function :log_warn,      :SDL_LogWarn, [:log_category, :string, :varargs], :void
  attach_function :log_message,   :SDL_LogMessage, [:log_category, :log_priority, :string, :varargs], :void
  attach_function :log_reset_priorities, :SDL_LogResetPriorities, [], :void
  attach_function :log_set_all_priority, :SDL_LogSetAllPriority, [:log_priority], :void      
  attach_function :log_get_output_function, :SDL_LogGetOutputFunction, [:log_output_function, :pointer], :void 
  attach_function :log_set_output_function, :SDL_LogSetOutputFunction, [:log_output_function, :pointer], :void  
  attach_function :log_set_priority, :SDL_LogSetPriority, [:log_category, :log_priority], :void
  attach_function :log_get_priority, :SDL_LogGetPriority, [:log_category], :log_priority
    
  
end