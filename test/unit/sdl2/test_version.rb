require_relative '../../test_helper'

require 'sdl2/init'
require 'sdl2/version'

describe SDL2 do
  
  it 'has the version API' do
    [:get_revision, :get_revision_number, :get_version].each do |function|
      assert_respond_to SDL2, function
    end
  end
  
  # I'll test further when I start to find bugs with this.
  
end