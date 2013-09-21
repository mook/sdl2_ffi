require 'ffi'

module SDL2

  # Extensions to FFI::Library
  module Library

    # This converts the SDL Function Prototype name "SDL_XxxYyyyyZzz" to ruby's
    # "xxx_yyyy_zzz" convetion
    def api(func_name, args, type, options = {})

      options = {
        :error => false,
        :filter => type == :bool ? TRUE_WHEN_TRUE : TRUE_WHEN_ZERO
      }.merge(options)

      # TODO: Review ugly hack:
      remove_part = case self.to_s
      when "SDL2"
        "SDL_"
      when "SDL2::Image"
        "IMG_"
      when "SDL2::TTF"
        "TTF_"
      when "SDL2::Mixer"
        "Mix_"
      else
        $stderr.puts("Library#api does not know how to handle module: #{self.to_s}")
        /[A-Z][A-Z|0-9]*_/
      end

      camelCaseName = func_name.to_s.gsub(remove_part,'')
      methodName = ActiveSupport::Inflector.underscore(camelCaseName).to_sym

      attach_function methodName, func_name, args, type
            
      metaclass.instance_eval do
        alias_method func_name, methodName
      end
      alias_method func_name, methodName

      if options[:error]
        returns_error(methodName, options[:filter])
      end

      if type == :bool
        boolean?(methodName)
      end

      return methodName
    end

    # Returns the 'singleton class' so we can define class-level methods on the
    # fly.
    # There may be a better place to put this.
    def metaclass

      class << self; self; end
    end

    # Generates an alternative version of methodName that will raise a SDL Error
    # when the return value fails the filter test.  The alternative version has
    # the same name, but with an exclamation mark ("!") at the end, indicating the
    # danger.
    def returns_error(methodName, filter)
      metaclass.instance_eval do
        define_method "#{methodName}!".to_sym do |*args|
          result = send(methodName, *args)
          raise_error_unless filter.call(result)
          result
        end
      end
    end

    # Generates an alternative ? version for methodName.
    def boolean?(methodName, filter = nil)
      metaclass.instance_eval do
        if filter.nil?
          alias_method "#{methodName}?".to_sym, methodName
        else
          define_method("#{methodName}?".to_sym) do |*args|
            filter.call(send(methodName, *args))
          end
        end
      end
    end

    # Raise the current error value as a RuntimeException
    def raise_error
      raise "SDL Error: #{SDL2.get_error()}"
    end

    # Conditionally raise an error, unless true
    def raise_error_unless(condition)
      raise_error unless condition
    end

    # Conditionally raise an error, unless false
    def raise_error_if(condition)
      raise_error if condition
    end
  end
end