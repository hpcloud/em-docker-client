module EventMachine
  class Docker
    class Client
      class Util
        def self.gokeyname_to_ruby(k)
          if k.start_with?("IP")
            k = k.gsub("IP", "Ip") # ensure double-caps IP gets split properly
          end

          if k.is_a?(String)
            # this will turn something like "SysInitPath" into :sys_init_path
            return k.gsub(/([a-z])([A-Z])/, '\1_\2' ).downcase.to_sym
          else
            return k
          end
        end

        def self.process_go_hash(data)
          case data
          when Array
            data.map { |arg| process_go_hash(arg) }
          when Hash
            Hash[
              data.map { |key, value|
                k = gokeyname_to_ruby(key)
                v = process_go_hash(value)
                [k,v]
              }]
          else
            data
          end
        end
      end
    end
  end
end