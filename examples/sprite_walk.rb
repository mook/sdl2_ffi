#!/usr/bin/env ruby
require 'sdl2/application'
require 'sdl2/image'
require 'weakref'

# Simple WeakRef based cache.
# Has some similarities to a hash.
class WeakCache

  def initialize()
    @cache = {}
  end

  # Only returns true if the WeakRef is alive.
  def has_key?(key)
    @cache.has_key?(key) and @cache[key].weakref_alive?
  end

  # Get the value cached, or nil if it is dead or not defined.
  def [](key)
    if has_key?(key)
      @cache[key].__getobj__
    else
      nil
    end
  end

  # Cache a WeakRef for value
  def []=(key, value)
    @cache[key] = WeakRef.new(value)
  end

  def to_hash
    r = {}

    @cache.each_pair do |k, v|
      r[k] = self[k]
    end

    return r
  end
end

class PathSearcher

  def initialize(opts = {})
    @paths = opts[:paths] || []
  end

  def <<(path)
    path = valid_path!(path)
    @paths << path
  end

  def paths_for(name, opts = {})    
    try_exts = opts[:try_exts] || ['']
    pre_glob = opts[:pre_glob] || ''
    pre_glob += '**/' if opts[:recursive]
    
    try_exts.map do |ext|
      ext = ".#{ext}" unless ext.blank? 
      "#{pre_glob}name#{ext}#{post_glob}"
    end.product(@paths).map do |path_name|
      File.expand_path(*path_name)
    end.reject do |path|
      not File.exist?(path)
    end
  end   

  private

  def valid_path(path)
    path = File.absolute_path(path)
    File.directory?(path) ? path : nil
  end

  def valid_path!(path)
    if valid = valid_path(path)
      return valid
    else
      raise "Path does not exist: #{path}"
    end
  end
  
  

end

class CachedLoader

  def self.search_paths
    @@search_paths ||= []
  end

  def self.find_first(path)
    [path].product(search_paths).map do |combo_ary|
      File.expand_path(*combo_ary)
    end.reject do |combo_path|
      puts combo_path
      (!File.exist?(combo_path) and !File.directory?(combo_path))
    end.first
  end

  def self.[](path)
    absolute_path = find_first(path)
    raise "No such file/dir: #{path}" unless absolute_path
    if (ptr = image_files[path.to_sym]).nil? or not ptr.weakref_alive?
      ptr = image_files[path.to_sym] = WeakRef.new(SDL2::Image.load!(absolute_path))
    end
    ptr.__getobj__
  end

  private

  def self.image_files
    @@image_files ||= WeakCache.new
  end

end

@app = SDL2::Application.new(title: "Sprite Walk")

@screen = @app.window.surface

CachedLoader.search_paths << File.expand_path('../images', __FILE__)
CachedLoader.search_paths << File.expand_path('../../spec/fixtures/images', __FILE__)

@background = CachedLoader['background.jpg']

@background.blit_out(@screen)

@app.window.update_surface

@app.loop()

@app.quit