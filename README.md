# sdl2_ffi

This is a simple interface to SDL2 for Ruby using FFI.  It also supports SDL_image and SDL_ttf.
Most of the procedural API has been linked with a few large exceptions like SDL_opengl.
The "Object Oriented" part of this interface has barely started.

# Documentation/API Reference:

The documentation is embedded within the code.  Generate the RDoc 

# How to start:

The GEM is organized to the same structure as the SDL header files.  Where in C/C++ you would need to:

    include 'SDL.h'
    include 'SDL_video.h'
    
with this rubygem, you would instead:

    require 'sdl2'
    require 'sdl2/video'
    
The SDL2 module is defined and it is where the raw SDL API is loaded and linked.  The Raw API can be called like so:

    SDL2.init(SDL2::INIT_EVERYTHING)
    

    
### Gotchas:

* Remember that SDL uses the 'SDL_Bool' enum instead of actual ruby Boolean, so instead of 'true' and 'false', you get ':true' and ':false'
  * Whenever SDL returns an SDL_Bool in the RAW API, I will always endevour to ensure there is a xxx? equivalent helper that converts the response to Ruby Booleans.

## Updates

### Imported APIs

I'm working my way through the SDL API header files.  I am attempting to make this GEM as modular as the SDL header files themselves so that the developer can load only the enum, typedefs and link to only the functionality needed.

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
