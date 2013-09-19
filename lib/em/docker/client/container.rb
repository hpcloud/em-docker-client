require 'date'

module EventMachine
  class Docker
    class Client
      class Container
        attr_reader :id, :image, :command, :created, :status, :size_rw, :size_rootfs

        def self.create()
          # XXX
        end

        def self.from_hash(hash)
          new(hash[:id], hash)
        end

        def initialize(id, opts={})
          @id = id

          @client = opts[:client]

          @image       = opts[:image]
          @command     = opts[:command]
          @created     = opts[:created]
          @status      = opts[:status]
          @size_rw     = opts[:size_rw]
          @size_rootfs = opts[:size_rootfs]
        end

        def info
          # GET /containers/(id)/json
          res = @client._make_request( :method => 'GET', :path => "/containers/#{@id}/json" )

          # res is a very large hash, so we'll do minimal (mostly automated) processing on it
          res = EM::Docker::Client::Util.process_go_hash(res)
          res[:created] = DateTime.iso8601( res[:created] ).to_time

          if res[:state][:started_at]
            res[:state][:started_at] = DateTime.iso8601( res[:state][:started_at] ).to_time
          end

          res
        end

        def processes
          # GET /containers/(id)/top
        end

        def changes
          # GET /containers/(id)/changes
        end

        def export
          # GET /containers/(id)/export
          # streams back export data
        end

        def start(opts={})
          # POST /containers/(id)/start

          req_hash = {}

          req_hash["Binds"] = opts[:binds] if opts[:binds]

          if opts[:lxc_conf]
            req_hash["LxcConf"] = []
            opts[:lxc_conf].each do |k,v|
              req_hash << { "Key" => k, "Value" => v }
            end
          end

          @client._make_request( :method => "POST", :path => "/containers/#{@id}/start", :data => req_hash, :content_type => "application/json", :expect => 'boolean')
        end

        def stop(opts={})
          # POST /containers/(id)/stop
          query_params = @client._parse_query_params( ["t"], opts )

          @client._make_request( :method => "POST", :path => "/containers/#{@id}/stop", :query_params => query_params, :expect => 'boolean')
        end

        def restart
          # POST /containers/(id)/restart
          query_params = @client._parse_query_params( ["t"], opts )

          @client._make_request( :method => "POST", :path => "/containers/#{@id}/restart", :query_params => query_params, :expect => 'boolean')
        end

        def kill
          # POST /containers/(id)/kill

          @client._make_request( :method => "POST", :path => "/containers/#{@id}/kill", :expect => 'boolean')
        end

        def attach
          # POST /containers/(id)/attach
          # this is a stream
        end
        
        def wait
          # POST /containers/(id)/wait

          res = @client._make_request( :method => "POST", :path => "/containers/#{@id}/wait", :expect => 'json')
          return res["StatusCode"]
        end

        def delete
          # DELETE /containers/(id)
          query_params = @client._parse_query_params( ["v"], opts )

          @client._make_request( :method => "DELETE", :path => "/containers/#{@id}", :query_params => query_params, :expect => 'boolean')
        end

        def copy_out
          # POST /containers/(id)/copy
          # streams back contents of files/dirs
        end
      end
    end
  end
end