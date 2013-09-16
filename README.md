# sdl2_ffi

[![Gem Version](https://badge.fury.io/rb/sdl2_ffi.png)](http://badge.fury.io/rb/sdl2_ffi)

This is a simple interface to SDL2 for Ruby using FFI.  
It also supports SDL_image and SDL_ttf.
While a lot of the SDLlib, SDL_image, and SDL_ttf are linked, not all prototypes
have been tested.  Large sections, such as "SDL_opengl<x>.h" have not been translated
at all.

The "Object Oriented" part of this interface has barely started.

# Documentation/API Reference:

For the latest released gem, [rubydoc.info](http://rubydoc.info/) has the
[automatically generated documentation](http://rubydoc.info/gems/sdl2_ffi/frames).

Otherwise, you can use RDoc to generate current source documentation.
 
# How to start:

The GEM is organized to the same structure as the SDL header files.  Where in C/C++ you would need to:

    include 'SDL'
    include 'SDL_image'
    include 'SDL_ttf'
    
with this rubygem, you would instead:

    require 'sdl2'
    require 'sdl2/image'
    require 'sdl2/ttf'
    
The SDL2 module is defined and it is where the raw SDL API is loaded and linked.  The Raw API can be called like so:

    SDL2.init!(:EVERYTHING)
	SDL2.was_init?(:EVERYTHING)
    
## More Examples:

As a means of validating functionality, I am in the process of translating
existing SDL Examples into Minitest [functional tests](https://github.com/BadQuanta/sdl2_ffi/tree/master/test/functional/examples).  


## Dependencies

* Obviously, ruby
* SDL2 Runtime (Development files are not needed.)

## Installation

Add this line to your application's Gemfile:

    gem 'sdl2_ffi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sdl2_ffi
    
## Testing

Minitests are being written to validate functionality. Not SDL's functionality, but that the GEM has been linked properly and that the Object Oriented wrapper functions as intended.

Run the tests with rake:

    $ rake test
    
Verbose options are nice:

    $ rake test TESTOPTS="--verbose"

   
### Testing Under *nix & X11

If you are testing under some kind of unix system with X11 and have Xnest available,
I'd recommend starting up Xnest and changing your testing terminal DISPLAY value
so that the tests do not throw around a bunch of Windows on your scren.


    
### I need your help!

I'm just starting to implement the Object Oriented Wrapper.  I'll need help identifying mistakes, especially in memory management.  Bug-reports submitted with tests will be looked at before bug-reports without tests, as a way to encourage tests being written.

Thanks for reading this!

## Usage

The interface is intended to be modular and follows (roughly) SDL's header files.

## Contributing

libSDL 2.0 is licensed under the 'zlib license', listed as compatible with the GNU GPL by [the gnu foundation](http://www.gnu.org/licenses/license-list.html).  The 'sdl_ffi' GEM is licensed under the MIT License.  Both encourage distribution and modification.  Please let me know about your work and I'll link it where appropriate. 

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

I specifically need help writing the minitest code.  
