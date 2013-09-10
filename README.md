em-docker-client
==========

This gem provides an EventMachine-based non-blocking interface to the [Docker API](http://docs.docker.io/en/latest/api/docker_remote_api_v1.5/).

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

TBD
