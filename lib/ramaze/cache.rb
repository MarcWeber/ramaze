#          Copyright (c) 2009 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.
require 'innate/cache'

module Ramaze
  Cache = Innate::Cache

  #:nodoc:
  class Cache
    autoload :LRU,           'ramaze/cache/lru'
    autoload :LocalMemCache, 'ramaze/cache/localmemcache'
    autoload :MemCache,      'ramaze/cache/memcache'
    autoload :Sequel,        'ramaze/cache/sequel'
    autoload :Redis,         'ramaze/cache/redis'

    ##
    # Clears the cache after a file has been reloaded.
    #
    # @author Michael Fellinger
    # @since  17-07-2009
    #
    def self.clear_after_reload
      action.clear if respond_to?(:action)
      action_value.clear if respond_to?(:action_value)
    end
  end # Cache
end # Ramaze
