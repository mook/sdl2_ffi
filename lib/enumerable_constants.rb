require 'ffi'
# This module adds a couple static-scope routines to
# any module that includes it, allowing them to enumerate
# the constants they define.  Please help me make it better
#
# An example:
#     module MyEnumeration
#       include EnumerableConstants
#       MY_FIRST_CONSTANT = next_const_value # defaults to 0
#       MY_NEXT_CONSTANT = next_const_value # will be 1
#       MY_THIRD_CONSTANT = next_const_value # will be 2, and the next would be 3 unless
#       MY_FOURTH_CONSTANT = 100 # you assign a value.
#       MY_FIFTH_CONSTANT = next_const_value # will be 101
#       MY_SIXTH_CONSTANT = MY_THIRD_CONSTANT # There are no rules against duplicate values.
#       MY_SEVENTH_CONSTANT = next_const_value # will be 3, be careful you don't unintentionally reuse values.
#     end
#
# With this module, you can:
#
#     MyEnumeration.by_name #=> {:MY_FIRST_CONSTANT=>0,:MY_NEXT_CONSTANT=>1,:MY_...}
#
# This is actually a standard function, nothing I added:
#
#     MyEnumeration.constants #=> [:MY_FIRST_CONSTANT,:MY_SECOND_CONSTANT]
#
# Get the last value defined:
#
#     MyEnumeration.last_const_value #=> 3, based on the example above.
#
# Get the next logical value, assuming the last value responds to .next,
# Otherwise, there will likely be an error.
# Note: This routine has no effect without assignment to a constant
# within this EnumerableConstants module/class. i.e.
#
#     MyEnumeration::MY_EIGTH_CONSTANT = MyEnumeration.next_const_value # 4
#
# However, successive calls to just `#next_const_value` will just result in
# the same value.
#     MyEnumeration.next_const_value # 5
#     MyEnumeration.next_const_value # 5
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
      
      # This routine returns a flattened array of alternating symbols and values.
      # The symbols are the CONSTANT names and values are the values defined by that constant.
      def self.flatten_consts
        by_name.to_a.flatten
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