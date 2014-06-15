
module SDL2
  ##
  # A struct helper provides member_reader/member_writer helpers for quickly accessing those damn members.
  # This is extended into sdl2_ffi's usage of Structs, ManagedStructs, and Unions. Do I know exatcly what I'm
  # doing, no... but teach me what I'm doing wrong.
  module StructHelper
    # Define a set of member readers
    # Ex1: `member_readers [:one, :two, :three]`
    # Ex2: `member_readers *members`
    def member_readers(*members_to_define)
      members_to_define.each do |member|
        define_method member do
          self[member]
        end
      end

    end

    # Define a set of member writers
    # Ex1: `member_writers [:one, :two, :three]`
    # Ex2: `member_writers *members`
    def member_writers(*members_to_define)
      members_to_define.each do |member|
        define_method "#{member}=".to_sym do |value|
          self[member]= value
        end
      end
    end

  end
end