module SDL2
  # This class manages logging output
  module Debug
    # Change this to true and we'll log everything.
    ALL = false

    CLASSES = Hash.new do |hsh, klass|
      if klass.kind_of?(Class)
        hsh[klass] = ALL
      end
    end
    
    STATE = {
      log_to: STDERR,
      recursion: 0,
      last_caller: [],
    }
    
    def self.enabled?(obj)
      klass = obj.kind_of?(Class) ? obj : obj.class
      until klass == nil
        return true if CLASSES[klass]
        klass = klass.superclass
      end
      return false
    end
    
    def self.enable(obj)
      klass = obj.kind_of?(Class) ? obj : obj.class
      CLASSES[klass] = true
    end

    def self.log(src, &msg_block)
      return unless enabled?(src)
      
      msg = msg_block.nil? ? "No message" : msg_block.call

      STATE[:log_to].puts(msg)

    end
  end

end