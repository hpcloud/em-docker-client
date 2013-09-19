class EventMachine
  class Docker
    class Client
      class Image
        def self.create()
          # XXX          
        end

        def initialize(id)
          @id = id
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