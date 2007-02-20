#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'timeout'

$:.unshift File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib')

require 'ramaze'

begin
  require 'rubygems'
rescue LoadError => ex
end

require 'spec'

require 'spec/spec_helper_simple_http'
require 'spec/spec_helper_requester'
require 'spec/spec_helper_context'

include Requester

module Spec::Runner::ContextEval::ModuleMethods

  # start up ramaze with a given hash of options
  # that will be merged with the default-options.

  def ramaze_start hash = {}
    options = {
      :mode         => :debug,
      :adapter      => :mongrel,
      :run_loose    => true,
      :error_page   => false,
      :port         => 7007,
      :host         => '127.0.0.1',
      :force        => true,
      :force_setup  => true,
    }.merge(hash)

    Ramaze.start(options)
  end

  alias ramaze ramaze_start

  # shutdown ramaze, this is not implemeted yet
  # (and might never be due to limited possibilites)

  def ramaze_teardown
    #Ramaze.teardown
  end
end


# require each of the following and rescue LoadError, telling you why it failed.

def testcase_requires(*following)
  following.each do |file|
    require(file.to_s)
  end
rescue LoadError => ex
  puts ex
  puts "Can't run #{$0}: #{ex}"
  puts "Usually you should not worry about this failure, just install the"
  puts "library and try again (if you want to use that feature later on)"
  exit
end