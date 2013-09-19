require 'em-http-request'

require 'fiber'
require 'uri'
require 'json'

require 'em/docker/client/container'
require 'em/docker/client/image'

module EventMachine
  class Docker
    class Client
      def initialize(opts={})
        @host      = opts[:host] || "127.0.0.1"
        @port      = opts[:port] || 4243
        @synchrony = opts[:synchrony] || true

        if opts[:synchrony] == false
          raise "Non-fibered execution is not yet supported by EM::Docker::Client."
        end
      end

      def info
        # GET /info
        res = _make_request( :method => 'GET', :path => '/info', :expect => 'json' )
        
        {
          :containers      => res["Containers"],
          :images          => res["Images"],
          :debug           => res["Debug"],
          :nfd             => res["NFd"],
          :ngoroutines     => res["NGoroutines"],
          :memory_limit    => res["MemoryLimit"],
          :swap_limit      => res["SwapLimit"],
          :ipv4_forwarding => res["IPv4Forwarding"], 
        }
      end

      def version
        # GET /version
        res = _make_request( :method => 'GET', :path => '/version', :expect => 'json' )
        
        {
          :version    => res["Version"],
          :git_commit => res["GitCommit"],
          :go_version => res["GoVersion"],
        }
      end

      def containers
        # GET /containers/json
        # returns array of EM::Docker::Client::Container objects
      end

      def create_container
        # POST /containers/create
        # EM::Docker::Client::Container.create()
        # return EM::Docker::Client::Container object
      end

      def container(id)
        # GET /containers/(id)/json
        # return EM::Docker::Client::Container object
      end

      def images
        # GET /images/json
        # returns array of EM::Docker::Client::Image objects
      end

      def create_image
        # POST /images/create
        # returns EM::Docker::Client::Image object
      end

      def image(name)
        # GET /images/(name)/json
        # returns EM::Docker::Client::Image object
      end

      def _make_request(opts)
        method = opts[:method].downcase
        path   = opts[:path]
        expect = opts[:expect] || 'json'

        uri = URI("http://#{@host}/")
        uri.port = @port
        uri.path = path

        full_path = uri.to_s

        f = Fiber.current

        http = EventMachine::HttpRequest.new(full_path).send(method)
        http.errback { f.resume(http) }
        http.callback { f.resume(http) }

        Fiber.yield 

        if http.error
          raise "request #{method.upcase} #{path} failed, error #{http.error}"
        end

        res = http.response

        if expect == 'json'
          return JSON.parse(res)
        else
          raise "unable to parse expected value #{expect}"
        end
      end
    end
  end
end
  