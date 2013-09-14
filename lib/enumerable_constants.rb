# This module adds a couple static-scope routines to
# any module that includes it, allowing them to enumerate
# the constants they define.  Please help me make it better
module EnumerableConstants

  # This is the method that injects the new static-scope routines.
  def self.included(base)
    base.module_eval do

      ##
      # Return the defined constants in a hash keyed by name.
      def self.by_name
        result = {}
        self.constants.each do |constant|
          result[constant] = self.const_get(constant)
        end
        return result
      end

      ##
      # Get the last defined value.
      def self.last_const_value
        if self.constants.empty?
          return 0
        else
          return self.const_get(self.constants.last)
        end
      end

      ##
      # Get the next value in order.
      def self.next_const_value
        last_const_value.next
      end

    end
  end

end