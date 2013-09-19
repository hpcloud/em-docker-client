class EventMachine
  class Docker
    class Client
      class Container
        def self.create()
          # XXX
        end

        def initialize(id)
          @id = id
        end

        def info
          # GET /containers/(id)/info
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

        def start
          # POST /containers/(id)/start
        end

        def stop
          # POST /containers/(id)/stop
        end

        def restart
          # POST /containers/(id)/restart
        end

        def kill
          # POST /containers/(id)/kill
        end

        def attach
          # POST /containers/(id)/attach
          # this is a stream
        end
        
        def wait
          # POST /containers/(id)/wait
        end

        def delete
          # DELETE /containers/(id)
        end

        def copy_out
          # POST /containers/(id)/copy
          # streams back contents of files/dirs
        end
      end
    end
  end
end