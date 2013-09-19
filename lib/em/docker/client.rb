require 'em-http-request'

require 'em/docker/client/container'
require 'em/docker/client/image'

module EventMachine
  class Docker
    class Client
      def initialize(opts={})
        @host = opts[:host] || "127.0.0.1"
        @port = opts[:port] || 4243
      end

      def info
        # GET /info
      end

      def version
        # GET /version
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
    end
  end
end
  