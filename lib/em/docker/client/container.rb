require 'date'

module EventMachine
  class Docker
    class Client
      class Container
        attr_reader :id, :image, :command, :created, :status, :size_rw, :size_rootfs, :config

        def self.create(opts={})
          req_hash = {}

          mapping = {
            "Hostname" => {
              :source  => :host,
              :default => "",
            },
            "User" => {
              :source  => :user,
              :default => "",
            },
            "Memory" => {
              :source  => :memory,
              :default => 0,
            },
            "MemorySwap" => {
              :source  => :memory_swap,
              :default => 0,
            },
            "AttachStdin" => {
              :source => :attach_stdin,
              :default => false,
            },
            "AttachStdout" => {
              :source => :attach_stdout,
              :default => false,
            },
            "AttachStderr" => {
              :source => :attach_stderr,
              :default => false,
            },
            "PortSpecs" => {
              :source => :port_specs,
              :default => nil,
            },
            "Privileged" => {
              :source => :privileged,
              :default => false,
            },
            "Tty" => {
              :source => :tty,
              :default => false,
            },
            "OpenStdin" => {
              :source => :open_stdin,
              :default => false,
            },
            "StdinOnce" => {
              :source => :stdin_once,
              :default => false,
            },
            "Env" => {
              :source  => :env,
              :default => nil,
            },
            "Cmd" => {
              :source  => :cmd,
              :default => nil,
            },
            "Dns" => {
              :source  => :dns,
              :default => nil,
            },
            "Image" => {
              :source => :image,
            },
            "Volumes" => {
              :source => :volumes,
              :default => {},
            },
            "VolumesFrom" => {
              :source => :volumes_from,
              :default => ""
            },
            "WorkingDir" => {
              :source => :working_dir,
              :default => "",
            },
          }

          mapping.each do |k,v|
            if opts.key?( v[:source] )
              req_hash[k] = opts[ v[:source] ]
            else
              if v.key?(:default)
                req_hash[k] = v[:default]
              else
                raise ArgumentError, "#{k} must be specified when creating container"
              end
            end
          end

          if opts[:cmd]
            req_hash["Cmd"] = Shellwords.shellwords(opts[:cmd])
          end

          @client ||= opts[:client]
          res = @client._make_request( :method => 'POST', :path => "/containers/create", :expect => 'json', :content_type => 'application/json', :data => req_hash)
          container_id = res["Id"]

          new(container_id, { :client => @client })
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
          @config      = opts[:config]
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

          @created = res[:created]
          @config  = res[:config]
          @command = res[:path] + " " + res[:args].join(" ")

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

        def delete(opts={})
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