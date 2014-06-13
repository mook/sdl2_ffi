require 'sdl2'

module SDL2

  module Log

    module PRIORITY
      include EnumerableConstants

      VERBOSE = 1
      DEBUG   = next_const_value
      INFO    = next_const_value
      WARN    = next_const_value
      ERROR   = next_const_value
      CRITICAL= next_const_value

    end
    
    module CATEGORY
      include EnumerableConstants
      APPLICATION   = next_const_value
      ERROR         = next_const_value
      ASSERT        = next_const_value
      SYSTEM        = next_const_value
      AUDIO         = next_const_value
      VIDEO         = next_const_value
      RENDER        = next_const_value
      INPUT         = next_const_value
      TEST          = next_const_value
      RESERVED1     = next_const_value
      RESERVED2     = next_const_value
      RESERVED3     = next_const_value
      RESERVED4     = next_const_value
      RESERVED5     = next_const_value
      RESERVED6     = next_const_value
      RESERVED7     = next_const_value
      RESERVED8     = next_const_value
      RESERVED9     = next_const_value
      RESERVED10    = next_const_value      
      CUSTOM        = next_const_value
    end
    
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
    
    def self.with_temp_priority(level)
      raise "Block required" unless block_given?
      old_cat = self.get_priority(category)
    end
  end

  enum :log_priority, Log::PRIORITY.flatten_consts

  enum :log_category, Log::CATEGORY.flatten_consts

  callback :log_output_function, [:pointer, :log_category, :log_priority, :string], :void

  ##
  #
  api :SDL_Log, [:string, :varargs], :void
  ##
  #
  api :SDL_LogCritical, [:log_category, :string, :varargs], :void
  ##
  #
  api :SDL_LogDebug, [:log_category, :string, :varargs], :void
  ##
  #
  api :SDL_LogError, [:log_category, :string, :varargs], :void
  ##
  #
  api :SDL_LogInfo, [:log_category, :string, :varargs], :void
  ##
  #
  api :SDL_LogVerbose, [:log_category, :string, :varargs], :void
  ##
  #
  api :SDL_LogWarn, [:log_category, :string, :varargs], :void
  ##
  #
  api :SDL_LogMessage, [:log_category, :log_priority, :string, :varargs], :void
  ##
  #
  api :SDL_LogMessageV, [:log_category, :log_priority, :string, :varargs], :void
  ##
  #
  api :SDL_LogResetPriorities, [], :void
  ##
  #
  api :SDL_LogSetAllPriority, [:log_priority], :void
  ##
  #
  api :SDL_LogGetOutputFunction, [:log_output_function, :pointer], :void
  ##
  #
  api :SDL_LogSetOutputFunction, [:log_output_function, :pointer], :void
  ##
  #
  api :SDL_LogSetPriority, [:log_category, :log_priority], :void
  ##
  #
  api :SDL_LogGetPriority, [:log_category], :log_priority

end