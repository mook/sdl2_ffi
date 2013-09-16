# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sdl2/gem_version'

Gem::Specification.new do |spec|
  spec.name          = 'sdl2_ffi'
  spec.version       = SDL2::GEM_VERSION
  spec.authors       = ['BadQuanta']
  spec.email         = ['BadQuanta@Gmail.com']
  spec.description   = %q{Foreign Function Interface to SDL2 in Ruby }
  spec.summary       = %q{Object Oriented wrapper for SDL2.  Help me test & debug my interface.}
  spec.homepage      = 'https://github.com/BadQuanta/sdl2_ffi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  
  spec.add_dependency 'ffi'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'minitest', '~> 5.0.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'yard'
  
  
end
