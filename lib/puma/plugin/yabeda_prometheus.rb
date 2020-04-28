# frozen_string_literal: true

require 'rack'
require 'yabeda/prometheus/exporter'

Puma::Plugin.create do
  def start(launcher)
    options = launcher.options
    events = launcher.events

    host = options[:prometheus_host] || ENV['PROMETHEUS_EXPORTER_BIND'] || '0.0.0.0'
    port = options[:prometheus_port] || ENV['PROMETHEUS_EXPORTER_PORT'] || 9393

    app = Yabeda::Prometheus::Exporter.rack_app

    metrics = Puma::Server.new app, events
    metrics.min_threads = 0
    metrics.max_threads = 1

    events.log "* Starting metrics server on #{host}:#{port}"
    metrics.add_tcp_listener host, port

    events.register(:state) do |state|
      if %i[halt restart stop].include?(state)
        metrics.stop(true) unless metrics.shutting_down?
      end
    end

    metrics.run
  end
end
