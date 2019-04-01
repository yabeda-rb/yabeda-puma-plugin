require 'yabeda/puma/statistics'

module Yabeda
  module Puma
    module Statistics
      class Parser
        attr_reader :clustered, :data

        def initialize(clustered:, data:)
          @clustered = clustered
          @data = data
        end

        def call
          Array.new.tap { |result| parse(data, result) }
        end

        private

        def parse(stats, labels = {}, result)
          stats.each do |key, value|
            value.each { |s| parse(s, labels.merge(index: s['index']), result) } if key == 'worker_status'
            parse(value, labels, result) if key == 'last_status'
            result << {name: key, value: value, labels: labels} if metric?(key)
          end
        end

        def metric?(name)
          Statistics::METRICS.include?(name.to_sym) || (Statistics::CLUSTERED_METRICS.include?(name.to_sym) && clustered)
        end
      end
    end
  end
end
