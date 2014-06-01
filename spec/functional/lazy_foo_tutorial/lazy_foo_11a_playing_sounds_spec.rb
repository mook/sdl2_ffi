require_relative 'lazy_foo_helper'

require 'sdl2/mixer'
require 'sdl2/application'
require 'sdl2/ttf'

#ORIGINAL: http://lazyfoo.net/SDL_tutorials/lesson11/index.php
# Adapted for Ruby & SDL 2.0 as functional test by BadQuanta

describe "LazyFoo.net: Lesson 11: Playing sounds" do

  class PlayingSoundsEngine < SDL2::Engine

    def initialize(opts = {})
      # Initialize our engine
      super(opts)

      # Music & Sound
      Mixer::init!(:FLAC)
      Mixer::open_audio!(MIX::DEFAULT_FREQUENCY, MIX::DEFAULT_FORMAT, 2, 4096)
      # Text/Fonts
      SDL2::TTF::init!()

      @background = Image.load!(img_path('background.png'))

      @font = TTF::Font.open(fixture('fonts/GaroaHackerClubeBold.otf'), 30)
            
      @music = Mixer::Music.load(fixture('music/beat.wav'))

      @scratch = Mixer::Chunk.load_wav(fixture('sounds/scratch.wav'))
      @high = Mixer::Chunk.load_wav(fixture('sounds/high.wav'))
      @med = Mixer::Chunk.load_wav(fixture('sounds/medium.wav'))
      @low = Mixer::Chunk.load_wav(fixture('sounds/low.wav'))

      on({type: :KEYDOWN, key: {keysym: {sym: :N1}}}) do |event|
        puts "Playing Scratch!"
        puts "Played on Channel: #{@scratch.play}"
        true
      end

      on({type: :KEYDOWN, key: {keysym: {sym: :N2}}}) do |event|
        puts "Playing High!"
        puts "Played on Channel: #{@high.play}"
        true
      end

      on({type: :KEYDOWN, key: {keysym: {sym: :N3}}}) do |event|
        puts "Playing Medium!"
        puts "Played on Channel: #{@med.play}"

        true
      end

      on({type: :KEYDOWN, key: {keysym: {sym: :N4}}}) do |event|
        puts "Playing Low!"
        puts "Played on Channel: #{@low.play}"
        true
      end

      # Play/Pause/Resume music
      on({type: :KEYDOWN, key: {keysym: {sym: :N9}}}) do |event|
        puts "Play/Pause/Resume Music!"
        unless Mix::Music.playing?
          Mix::play_music!(@music, -1)
        else
          if Mix::Music.paused?
            Mix::Music.resume()
          else
            Mix::Music.pause()
          end
        end
        true
      end
      # Stop the music.
      on({type: :KEYDOWN, key: {keysym: {sym: :N0}}}) do |event|
        puts "Stop Music!"
        Mix::halt_music!()
        true
      end
    end#initialize

    def paint_to(surface)
      unless @painted
        @background.blit_out(surface)
        @painted = true
      end
    end
  end

  before do

    @app = Application.new(title: subject)
    @app.engines << PlayingSoundsEngine.new()
    @screen = @app.window.surface
    @app.window.title = "Monitor Music"

  end

  after do

    @app.quit()

    Mix::close_audio()

    #TTF::quit()

    #SDL2::quit()

  end

  it 'loads' do
    @app.loop(nil, delay: 100)
    #pending "Don't know how to test this."
  end

end