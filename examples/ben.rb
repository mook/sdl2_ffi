#!/usr/bin/env ruby
require 'sdl2/application'
require 'sdl2/image'
include SDL2

@app = Application.new(title: "My first game")



# The SDL memory surface that drawing occurs on, possibly on video card
@screen = @app.window.surface

# First things first, load a loading image:
@app.images[:loading].blit_out(@screen)
@app.window.update_surface()
 
# Load and play some music while we load the rest:
@app.music[:muzak].play()
 
# Load and Optimize images for drawing to screen format:
@background = @app.images[:background]

# This is a single sheet of RPG character images that are each
# Each line has three character images and represents a direction the character
# is pointing.  The middle image in each line is the standing position. Each image is 32x32
@character_sheet = @screen.convert(Image.load!('character.png'))
@char_pos = Point.create({x: 10, y: 10})
 
# This is an array of arrays of Rectangles.  Each one represents a single
# part of the character_sheet.  The outer array length is 4, to represent the
# 4 directions the character can face, N,S,E,W
# by providing a do |param| ... end, we are dynamically specifying it's contents
# at creation.
@char_clips = Array.new(4) do |line_num| #starts counting at zero
  Array.new(3) do |cell_num| #starts counting at zero
    Rect.create(x: cell_num * 32,   y: line_num * 32,    w: 32,   h: 32)
  end
end
 
# Direction constants
UP = 0 #line 1
RIGHT = 1
DOWN = 2
LEFT = 3
 
# The middle cell is standing, other two are walk animations
STANDING = 1
 
# What direction is the char facing?
@char_dir = UP
# Is it walking?
@walking = false
 
# Load Sound Effects and Game bg music
@step = Mixer::Chunk.load('step.wav')
@music = Mixer::Music.load('eerie.mp3')
 
# Load the font used by the game:
@font = TTF::Font.open('gamefont.ttf')
 

@app.music.crossfade(:muzak, :music, 300.ms)
 
# When @app.quit() is called, it will also call this in reverse of the order that they were added.
@app.on_quit do
  @music.stop()
end
 
# This animates a walking character, or updates it to standing and stops running.
@animator = @app.every(500.ms, start: false) do |ticks|
  if @walking
    @char_cell = (@char_cell + 1) % 3 # Add one, wrapping around every 3
    true # keep animating
  else
    @char_cell = CELL_STANDING
    false # stop animating
  end
end
 
# We can bind many handlers to individual events.  Both this, and one of the other handlers will be called
# if any arrow key is pressed.  This will also be called on any key tho, so you could watch the char walk in place.
# When a "on(xxEventxx) do" handler returns true, the event will no longer be processed and immediately dropped
@app.on({type: KEYDOWN}) do |event|
  @walking = true
  @animator.start # this does nothing if it is already started
  false#we did not fully handle the event, look for other handlers
end
 
# Stop the character whenever 
@app.on({type: :KEYUP}) do |event|
  @walking = false
  true#don't keep looking for handlers
end
 
# Up arrow key
@app.on({type: :KEYDOWN, key: {keysym: {sym: :UP}}}) do |event|
  @char_pos.y += 10
  @char_dir = UP
  @step.play()
  true
end
 
# Down arrow key
@app.on({type: :KEYDOWN, key: {keysym: {sym: :DOWN}}}) do |event|
  @char_pos.y -= 10
  @char_dir = DOWN
  @step.play()
  true
end
 
# Left arrow key
@app.on({type: :KEYDOWN, key: {keysym: {sym: :LEFT}}}) do |event|
  @char_pos.x -= 10
  @char_dir = LEFT
  @step.play()
  true
end
 
# Right arrow key
@app.on({type: :KEYDOWN, key: {keysym: {sym: :RIGHT}}}) do |event|
  @char_pos.x += 10
  @char_dir = RIGHT
  @step.play()
  true
end
 
# When app needs to paint
@app.painter do |surface|
  #clear the surface
  @background.blit_out(surface)
  # Draw (blit) the part of the character sheet specified by clips[dir][cell] 
  # to surface at char_pos  
  @character.blit_out(surface, @char_pos, @char_clips[@char_dir][@char_cell])
  # Render Text and Draw to Screen:
  @font.render_text_blended("X: #{@char_pos.x}, Y: #{@char_pos.y}").blit_out(surface)  
  # Ruby returns whatever was last evaluated, and @app expects a true signal
  # to know if it should update the window_surface with new content:  
  true
end
 
# Run the application:
@app.loop()