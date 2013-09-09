require_relative '../../test_helper'

require 'sdl2/log'

describe SDL2 do
 
  OUTPUT_CALLBACK = Proc.new do |ptr, category, priority, msg|
    @@last_output = msg
  end
  
  it 'has the log API' do    
    [
      :log, :log_critical, :log_debug, :log_error, :log_get_output_function,
      :log_get_priority, :log_info, :log_message, :log_message_v, :log_reset_priorities,
      :log_set_all_priority, :log_set_output_function, :log_set_priority, :log_verbose, :log_warn
    ].each do |function|
      assert_respond_to SDL2, function
    end
  end
  
  it 'logs messages' do    
    SDL2.log('Hello World %d', :int, 6384) # API Version  
    SDL2::Log << 'Hello World' # Object Oriented Version
            
    SDL2.log_critical(:application, 'Test %d', :int, 1234)
    SDL2::Log.critical(:error, 'Test %f', :float, 2.0)
    
    SDL2.log_debug(:assert, 'Test %s', :string, 'String')
    SDL2::Log.debug(:system, 'Test %c', :char, 'C'.chr().to_i)
    
    SDL2.log_error(:audio, 'Test %d', :int, 2)
    SDL2::Log.error(:video, 'Test %f', :float, 63.84)
    
    SDL2.log_warn(:render, 'Test %d', :int, 6)
    SDL2::Log.warn(:input, 'Test %f', :float, 88.21212)
    
    SDL2.log_verbose(:input, 'Test %d', :int, 8)
    SDL2::Log.verbose(:test, 'Test %f', :float, 1234.5)      
  end
  
  it 'lets you get the output function and data pointer' do
  
    skip
    callback_ptr = FFI::MemoryPointer.new FFI::Function, 1
    data = FFI::MemoryPointer.new :pointer, 1 
    SDL2.log_get_output_function(callback_ptr, data)
    callback = FFI::Function.new(:void, [:pointer, :int, :int, :string], callback_ptr)
    callback.call(data, 1, 1, "Hello There!")
  
    
  end
  
  TestFunc = Proc.new do ||
    puts "Test Function Called!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  end
  
  TEST_DATA = FFI::Pointer.new :string, 1
  
  
  it 'lets you set the output function and data pointer' do
    SDL2.log_set_output_function(TestFunc, TEST_DATA)
  end
  
  it 'lets you set the log priority' do
    [
      :application, :error, :assert, :system,
      :audio, :video, :render, :input, :test, :custom
    ].each do |category|
      [
        :verbose, :debug, :info, :warn, :error, :critical      
      ].each do |priority|
        SDL2::Log.set_priority(category, priority)
        assert_equal priority, SDL2::Log.get_priority(category)
      end 
      
    end
    SDL2::Log.set_priority(:application, :verbose)
    
  end
  
end