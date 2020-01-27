require 'yabeda/puma/plugin/statistics'

module Yabeda
  module Puma
    module Plugin
      module Statistics
        class Parser
          attr_reader :clustered, :data

          def initialize(clustered:, data:)
            @clustered = clustered
            @data = data
          end

          def call
            [].tap { |result| parse(data, {}, result) }
          end

          private

          def parse(stats, labels, result)
            stats.each do |key, value|
              case key
              when 'worker_status'
                value.each { |s| parse(s, labels.merge(index: s['index']), result) }
              when 'last_status'
                parse(value, labels, result)
              else
                next unless metric?(key)

                l = clustered_metric?(key) ? labels : { index: 0 }.merge(labels)
                result << { name: key, value: value, labels: l }
              end
            end
          end

          def metric?(name)
            Statistics::METRICS.include?(name.to_sym) || clustered_metric?(name)
          end

          def clustered_metric?(name)
            clustered && Statistics::CLUSTERED_METRICS.include?(name.to_sym)
          end
        end
      end
    end
  end
end
