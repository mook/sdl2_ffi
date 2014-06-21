# sdl2_ffi June, 2014

[![Gem Version](https://badge.fury.io/rb/sdl2_ffi.png)](http://badge.fury.io/rb/sdl2_ffi)

A Ruby interface to the SDL2 dynamic libraries, with support for SDL2_ttf, SDL2_mixer(with smpeg2), SDL2_image.

# Documentation/API Reference:

The API's functionality [RSpecs](https://github.com/BadQuanta/sdl2_ffi/tree/master/spec) can be used as a reference.

For the latest released gem, [rubydoc.info](http://rubydoc.info/) has the
[automatically generated documentation](http://rubydoc.info/gems/sdl2_ffi/frames).

Otherwise, you can use RDoc to generate current source documentation.
 
## Testing

Specs define the scope of what interfaces have been written and tested.

Run the tests with rake:

    $ rake spec
    
Or:

    $ ./bin/rspec ./spec -fd
    
### Approval Testing

Parts of the API are verified via "Approvals" which are PNG captures of SDL Surfaces,
on each run of an "Approved" rendering, the dumped PNGs are compared against each other.
Feel free to update these tests and "approve" the new PNGs.
   
### Testing Under *nix & X11

If you are testing under some kind of unix system with X11 and have Xnest available,
I'd recommend starting up Xnest or Xephyr and changing your testing terminal DISPLAY value
so that the tests do not throw around a bunch of Windows on your screen.

## Usage

When you `require 'sdl2_ffi'`, it should give you the same things that
include 'SDL.h' would have done.  See the specs for examples.  There are C/C++
tutorials that have been translated as a means of validating functionality.


## Contributing

libSDL 2.0 is licensed under the 'zlib license', listed as compatible with the GNU GPL by [the gnu foundation](http://www.gnu.org/licenses/license-list.html).  The 'sdl_ffi' GEM is licensed under the MIT License.  Both encourage distribution and modification.  Please let me know about your work and I'll link it where appropriate. 

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

New Issues welcome.  
