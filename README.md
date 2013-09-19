em-docker-client
==========

This gem provides an EventMachine-based fully non-blocking interface to the [Docker API](http://docs.docker.io/en/latest/api/docker_remote_api_v1.5/).

It currently only supports em-synchrony-like environments. This means that all of your code must be wrapped in a Fiber (if you use EM.synchrony instead of EM.new, this is done for you). Callbacks may be supported in the future.

Installation
------------

Add this line to your Gemfile:

```ruby
gem 'em-docker-client', :require => 'em/docker/client', :git => "https://github.com/ActiveState/em-docker-client.git"
```

Then run:

```shell
$ bundle install
```

Alternatively, if you wish to just use the gem in a script, you can run:

```shell
$ git clone https://github.com/ActiveState/em-docker-client.git
$ cd em-docker-client
$ gem build em-docker-client.gemspec
$ gem install em-docker-client
```

Then, add `require 'em/docker/client'` to the top of the file using this gem.

Usage
-----

```ruby
require 'em/docker/client'
require 'eventmachine'

EM.run do
  Fiber.new {
    client = EM::Docker::Client.new
    p client.info
    # => {:containers=>22,
    #  :images=>14,
    #  :debug=>true,
    #  :nfd=>9,
    #  :ngoroutines=>11,
    #  :memory_limit=>true,
    #  :swap_limit=>nil,
    #  :ipv4_forwarding=>true}

    p client.version
    # => {:version=>"0.6.1", :git_commit=>"5105263", :go_version=>"go1.1.2"}

    p client.containers
    # => [...]

    container = client.create_container( :image => 'ubuntu:12.04', :cmd => '/bin/echo' )
    p container.id
    # => "ae1e4a710e13"

    container.delete
  }.resume
end
