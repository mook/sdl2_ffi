module SDL2
  ##
  # BadQuanta says: "Even FFI::Unions can be helped."
  class Union < FFI::Union
    extend StructHelper
  end
end