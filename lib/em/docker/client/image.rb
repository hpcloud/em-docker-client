module EventMachine
  class Docker
    class Client
      class Image
        attr_reader :id, :repository, :tags, :created, :size, :virtual_size

        def self.create()
          # XXX          
        end

        def self.from_hash(hash)
          new(hash[:id], hash)
        end

        def initialize(id, opts={})
          @id = id

          @client = opts[:client]

          @repository  = opts[:repository]
          @tags        = opts[:tags]
          @created     = opts[:created]
          @size        = opts[:size]
          @virtual_size = opts[:virtual_size]
        end

        def info
          # GET /images/(name)/json
        end

        def history
          # GET /images/(name)/history
        end

        def push
          # POST /images/(name)/push
        end

        def tag
          # POST /images/(name)/tag
        end

        def delete
          # DELETE /images/(name)
        end
      end
    end
  end
end