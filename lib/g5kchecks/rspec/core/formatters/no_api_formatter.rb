require 'rspec/core/formatters/base_text_formatter'
require 'g5kchecks/utils/utils'
require 'yaml'
#binding.pry
module RSpec
  module Core
    module Formatters
      class NoApiFormatter < BaseTextFormatter

        attr_reader :output_hash, :yaml_hash

        def initialize(output)
          super
          @output_hash = {}
          @yaml_hash = Hash.new
        end

        def message(message)
          (@output_hash[:messages] ||= []) << message
        end

        def stop
          super
          @output_hash[:examples] = examples.each do |example|
            if e=example.exception
              array = e.message.split("\n")[0].split(', ')
              if array.size > 1
                index_empty_position = array.index("")
                if index_empty_position.nil?
                  index_empty_position = array.index("0")
                end
                if not index_empty_position.nil?
                  value_str = array.slice(0, index_empty_position).join(" ")
                  path = array.slice(index_empty_position + 1, array.length)
                  if path[0] == ""
                    # Remove an empty string from the path
                    path.delete_at(0)
                  end
                  add_to_yaml_hash(path, value_str, @yaml_hash)
                end
              end
            end
          end
        end

        def close
          # TODO change output filename here
          File.open(File.join("/tmp/",RSpec.configuration.node.hostname + ".yaml"), 'w' ) { |f|
            f.puts @yaml_hash.to_yaml
          }
          #File.open(File.join("/tmp/",RSpec.configuration.node.hostname + ".json"), 'w' ) { |f|
          #  f.puts @yaml_hash.to_json
          #}
        end

        def add_to_yaml_hash(array, value, hash)
          value = value.encode(Encoding.default_external)
          if array.size == 1
            # puts array[0]
            tmp = array[0].encode(Encoding.default_external)
            hash[tmp] = Utils.string_to_object(value)
            return hash
          else
            tmp = Utils.string_to_object(array.delete_at(0).encode(Encoding.default_external))
            if hash[tmp]
              add_to_yaml_hash(array,value, hash[tmp])
            else
              hash[tmp] = add_to_yaml_hash(array,value, Hash.new)
              return hash
            end
          end
        end

      end
    end
  end
end
