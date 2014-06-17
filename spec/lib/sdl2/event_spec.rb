require_relative '../../spec_helper'

describe SDL2::Event do
  before :each do
    SDL2.init!(:VIDEO)
    SDL2::Debug.enable(SDL2::Event)
  end
  
  
  it 'should provide event states' do
    SDL2::Event.should respond_to(:state)
    SDL2::Event.state(:KEYDOWN).should == true
    SDL2::Event.state(:KEYDOWN, :IGNORE).should == true # Because it was true
    SDL2::Event.state(:KEYDOWN).should == false # Because now it's disabled.
    SDL2::Event.state(:KEYDOWN, :ENABLE).should == false #getting it?
    SDL2::Event.state(:KEYDOWN).should == true
  end
  
  it 'should be able to filter events' do
    SDL2::Event.should respond_to(:filter)
    SDL2::Event.push(SDL2::Event.cast(SDL2::Event::Keyboard.cast({type: :KEYDOWN, keysym: {sym: :A}} )))
    count = 0
    SDL2::Event.filter do |data, event|
      count += 1      
    end
    count.should == 1
  end
  
  it 'should be able to flush an event type' do
    SDL2::Event.push SDL2::Event.cast(SDL2::Event::Keyboard.cast({type: :KEYDOWN, keysym: {sym: :A}} ))
    SDL2::Event.push SDL2::Event.cast(SDL2::Event::Keyboard.cast({type: :KEYUP, keysym: {sym: :B}} ))
    SDL2::Event.has?(:KEYDOWN).should == true
    SDL2::Event.has?(:KEYUP).should == true
    SDL2::Event.flush(:KEYDOWN)
    SDL2::Event.has?(:KEYDOWN).should == false
    SDL2::Event.has?(:KEYUP).should == true
  end
  
  it 'should be able to return the event filter' do
    skip 'unsure how to test right now'
    my_filter = lambda do |data, event|
      0 if event.type == :KEYDOWN
      1
    end
        
    SDL2::Event.filter.should == false
    SDL2::Event.filter= my_filter
    SDL2::Event.filter.should == my_filter
  end
  
  it 'should be able to peep events' do
    events = [
    SDL2::Event.cast(SDL2::Event::Keyboard.cast({type: :KEYDOWN,  keysym: {sym: :A}} )),
    SDL2::Event.cast(SDL2::Event::Keyboard.cast({type: :KEYUP,    keysym: {sym: :B}} )),
    SDL2::Event.cast(SDL2::Event::Keyboard.cast({type: :KEYDOWN,  keysym: {sym: :C}} )),
    SDL2::Event.cast(SDL2::Event::Keyboard.cast({type: :KEYUP,    keysym: {sym: :D}} )),
    ]
    events.each do |event|
      SDL2::Event.push(event)
    end
    SDL2::Event.should respond_to(:peep)
    retrieved = SDL2::Event.peep(nil, 3, :PEEK, :FIRSTEVENT, :LASTEVENT)
    # The SDL2::Events won't match since they are different pointers,
    # but hey, if we pull the values out we can see that they match just fine
    per = lambda do |e| 
      [e.type, e.key.keysym.sym]
    end
    retrieved.map(&per).should == events.map(&per).first(3)
  end
  
  it 'should be able to pump events' do
    SDL2::Event.should respond_to(:pump)
    # Count the number of events pumped.
    count = 0
    # Setup a filter to count the events pumped.
    SDL2::Event.filter= lambda do |data, event|
      count += 1
    end
    # Create some events and push
    [
        SDL2::Event::Keyboard.cast({type: :KEYDOWN,  keysym: {sym: :A}} ).to_event,
        SDL2::Event::Keyboard.cast({type: :KEYUP,    keysym: {sym: :B}} ).to_event,
        SDL2::Event::Keyboard.cast({type: :KEYDOWN,  keysym: {sym: :C}} ).to_event,
        SDL2::Event::Keyboard.cast({type: :KEYUP,    keysym: {sym: :D}} ).to_event,
    ].each {|e|SDL2::Event.push(e)}
    # Test the routine:
    SDL2::Event.pump
    count.should == 4 
  end
  
  it 'should indicate if an SDL::Event::Quit is in the Que' do
    SDL2::Event.should respond_to(:quit_requested?)
    #
    SDL2::Event.quit_requested?.should == false
    SDL2::Event.push SDL2::Event::Quit.cast({type: :QUIT}).to_event
    SDL2::Event.quit_requested?.should == true
  end
 
  after :each do
    SDL2.quit
  end
end