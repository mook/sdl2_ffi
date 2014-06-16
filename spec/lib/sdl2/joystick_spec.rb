require_relative '../../spec_helper'

describe SDL2 do
  it 'should have the joystick API' do
    # Joystick API
    [
      :joystick_close,
      :joystick_event_state,
      :joystick_event_state?,
      :joystick_get_attached,
      :joystick_get_attached?,
      :num_joysticks,
      :num_joysticks!,
      :joystick_update,
      :joystick_open,
      :joystick_open!,
      :joystick_num_hats,
      :joystick_num_hats!,
      :joystick_num_buttons,
      :joystick_num_buttons!,
      :joystick_num_balls,
      :joystick_num_balls!,
      :joystick_num_axes,
      :joystick_num_axes!,
      :joystick_name_for_index,
      :joystick_name_for_index!,
      :joystick_name,
      :joystick_instance_id,
      :joystick_instance_id!,
      :joystick_get_hat,
      # TODO: Implement Joystick GUID helpers?
      :joystick_get_guid_string,
      :joystick_get_guid_from_string,
      :joystick_get_guid,
      :joystick_get_device_guid,
      :joystick_get_button,
      :joystick_get_ball,
      :joystick_get_axis,
      :joystick_get_axis!,
    ].each do |method|
      SDL2.should respond_to(method)
    end
  end
  
  describe SDL2::Joystick do
    before :each do
      SDL2.init(:JOYSTICK)
      joy_count = SDL2.num_joysticks 
      skip "There are no Joysticks" if joy_count < 1
      
      @joysticks = joy_count.times.map {|idx| SDL2::Joystick.open(idx)}
    end
    
    
    it 'should have a name' do
      @joysticks.each{|j|j.name.should be_a(String)}
    end 
    
    it 'should have an event state' do
      @joysticks.each do |joystick|
        joystick.event_state(:IGNORE)
        joystick.event_state.should == false
        joystick.event_state(:ENABLE)
        joystick.event_state.should == true
      end
    end
    
    describe SDL2::Joystick::Buttons do            
      it 'should return a state for each button on each joystick' do
        @joysticks.delete_if{|js|js.buttons.count < 1}
        skip "no buttons" if @joysticks.empty?
        @joysticks.each do |joystick|          
          joystick.buttons.each do |button|            
            button.should be_a(Integer)
            button.should >= 0
            button.should <= 1
          end
        end
      end
    end
    
    describe SDL2::Joystick::Axes do
      it 'should return an integer for each axis' do
        @joysticks.delete_if{|js|js.axes.count < 1}
        skip "no axes" if @joysticks.empty?        
        @joysticks.each do |joystick|
          joystick.axes.each do |axis|
            axis.should be_a(Integer)
            axis.should >= -32768
            axis.should <= 32767
          end
        end
      end
    end
    
    describe SDL2::Joystick::Balls do
      it 'should return a delta x, delta y pair' do
        @joysticks.delete_if {|js|js.balls.count < 1}
        skip "no balls" if @joysticks.empty?
        @joysticks.each do |joystick|
          joystick.balls.each do |ball|
            ball.should be_a(Array)
            ball.count.should == 2
            ball.each do |value|
              value.should be_a(Integer)            
            end
          end          
        end
      end
    end
    
    describe SDL2::Joystick::Hats do
      it 'should return a valid SDL2::HAT value' do
        @joysticks.delete_if{|js|js.hats.count < 1}
        skip 'no hats' if @joysticks.empty?
        @joysticks.each do |joystick|
          joystick.hats.each do |hat|
            hat.should be_a(Integer)
            hat.should >= 0
            hat.should <= 12
          end
        end
      end
    end

    after :each do
      SDL2.quit
    end
  end
end