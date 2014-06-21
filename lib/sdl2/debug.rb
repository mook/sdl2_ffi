module SDL2
  # This class manages logging output
  module Debug

    ENABLED = Hash.new do 
      false # Always defaults to false
    end
    
    STATE = {
      log_to: STDERR,
      recursion: 0,
      last_caller: [],
    }
    
    ##
    # Returns true if the instance
    # It will return true if the object inherits from a class enabled for debugging.
    def self.enabled?(obj)
      # Immediately return true if we are debugging this instance specifically.
      return true if ENABLED[obj] 
      # Otherwise, check if the object is a class or get it's class.
      klass = obj.kind_of?(Class) ? obj : obj.class
      # And until there is no more superclass.
      until klass == nil
        # Return true if the class is enabled for debugging.
        return true if ENABLED[klass]
        # Otherwise keep searching.
        klass = klass.superclass
      end
      # If we got this far, it is a bust.
      false
    end
    
    ##
    # Takes an instance or a class to enable for debugging.
    # NOTE: If you only enable a single instance, then you will not see messages from the class-level.
    def self.enable(obj)
      ENABLED[obj] = true
    end

    ##
    # This will log a message from a method.
    # The source object is required (usually self) and this is how debugging is controlled.
    # The message must be specified in a block which will never be evaluated unless debugging is enabled for the source.
    # The source class will be identified along with the method name calling log in the output.
    def self.log(src, &msg_block)
      return unless klass = enabled?(src)
      method_name =  /.*`(.*)'/.match(caller.first)[1]
      is_class = src.kind_of?(Class)
      klass = is_class ? src : src.class
      msg_start = "#{klass.to_s}#{is_class ? '::' : '#'}#{method_name} >"     
      msg = msg_block.nil? ? "No message" : msg_block.call
      STATE[:log_to].puts(caller.first)
      STATE[:log_to].puts(msg_start + msg)
    end
  end

end