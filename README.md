# sdl2_ffi

[![Gem Version](https://badge.fury.io/rb/sdl2_ffi.png)](http://badge.fury.io/rb/sdl2_ffi)

The sdl2_ffi makes SDL2 fun and easy, eventually. This is still a new project
and I am still implementing major sections of it.  Check out the 
[approvals](https://github.com/BadQuanta/sdl2_ffi/tree/master/spec/fixtures/approvals)
to get an idea of how much is working.  These are screen-shots of SDL generated
content.  Approval testing is used to validate functionality.


The "Object Oriented" part of this interface has barely started.

# Documentation/API Reference:

For the latest released gem, [rubydoc.info](http://rubydoc.info/) has the
[automatically generated documentation](http://rubydoc.info/gems/sdl2_ffi/frames).

Otherwise, you can use RDoc to generate current source documentation.
 
# How to start:

    
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
