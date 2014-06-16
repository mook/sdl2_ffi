# sdl2_ffi June, 2014

[![Gem Version](https://badge.fury.io/rb/sdl2_ffi.png)](http://badge.fury.io/rb/sdl2_ffi)

A Ruby interface to the SDL2 dynamic libraries, with support for SDL2_ttf, SDL2_mixer(with smpeg2), SDL2_image.

# Documentation/API Reference:

For the latest released gem, [rubydoc.info](http://rubydoc.info/) has the
[automatically generated documentation](http://rubydoc.info/gems/sdl2_ffi/frames).

Otherwise, you can use RDoc to generate current source documentation.
 
## Major Sections:

### Full Initialization & Shutdown

SDL2 requires initialization and shutdown.  A call to `SDL2.init` is required as in:

	require 'sdl2_ffi'
	SDL2.init!(:EVERYTHING)
	// do some SDL work
	SDL2.quit()
	
The exclamation (!) mark represents the routine could fail and to handle that failure with an exception.  All failing methods attached directly to the SDL2 module should have a
bang, meaning error handling, alternative.  The `:EVERYTHING` symbol represents the same value as: `SDL2::INIT::EVERYTHING`, so doing the following is equivalent:

	require 'sdl2_ffi'
	SDL2.init!(SDL2::INIT::EVERYTHING)
	// do some SDL work
	SDL2.quit
	
You can combine `SDL2::INIT` values, for example:

	SDL2.init!(SDL2::INIT::VIDEO | SDL2::INIT::AUDIO | SDL2::INIT::JOYSTICK | SDL2::INIT::EVENT)
	
### Subsystem Initialization & Shutdown

SDL2 allows subsystems to be initialized and shutdown after SDL2 has been initialized through `SDL2#init_sub_system` and `SDL2#quit_sub_system`, for example:

	require 'sdl2_ffi`
	SDL2.init!(:VIDEO)
	// do video 
	SDL2.init_sub_system!(:AUDIO)
	// do audio & video
	SDL2.init_sub_system!(:JOYSTICK)
	// do audio, video, and joystick work
	SDL2.quit_sub_system(:AUDIO)
	// do video and joystick work
	SDL2.quit_sub_system(:VIDEO)
	// do joystick work
	SDL2.quit
	// all done


## Testing

Minitests are being written to validate functionality. Not SDL's functionality, but that the GEM has been linked properly and that the Object Oriented wrapper functions as intended.

Run the tests with rake:

    $ rake spec
    
Or:

    $ ./bin/rspec ./spec -fd
    
### Approval Testing

This project now uses Approval testing.  At the moment, I'm using a custom
'approvals' gem which is specified in the Gemfile, as opposed to the Gemspec.
This is only temporary.  The approved specifications are in the repository 
and can act as a repository of screen shots. :)

   
### Testing Under *nix & X11

If you are testing under some kind of unix system with X11 and have Xnest available,
I'd recommend starting up Xnest and changing your testing terminal DISPLAY value
so that the tests do not throw around a bunch of Windows on your screen.

## Usage

When you `require 'sdl2'`, it should give you the same things that
include 'SDL.h' would have done.  See the specs for examples.  There are C/C++
tutorials that have been translated as a means of validating functionality.


## Contributing

libSDL 2.0 is licensed under the 'zlib license', listed as compatible with the GNU GPL by [the gnu foundation](http://www.gnu.org/licenses/license-list.html).  The 'sdl_ffi' GEM is licensed under the MIT License.  Both encourage distribution and modification.  Please let me know about your work and I'll link it where appropriate. 

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

I specifically need help writing the minitest code.  
