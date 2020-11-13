# frozen_string_literal: true

begin
  require 'yabeda/prometheus/exporter'
rescue LoadError
  raise LoadError, 'Please add either yabeda-prometheus or yabeda-prometheus-mmap gem into your Gemfile to use yabeda/prometheus/exporter!'
end

require 'uri'
require 'rack'

module Puma
  class DSL
    def prometheus_exporter_url(uri)
      @options[:prometheus_exporter_url] = uri
    end
  end
end

Puma::Plugin.create do
  def start(launcher)
    events = launcher.events

    uri = launcher.options.fetch(:prometheus_exporter_url, 'tcp://0.0.0.0:9394/metrics')
    uri = URI.parse(ENV.fetch('PROMETHEUS_EXPORTER_URL', uri))
    host = ENV.fetch('PROMETHEUS_EXPORTER_BIND', uri.host)
    port = Integer(ENV.fetch('PROMETHEUS_EXPORTER_PORT', uri.port))
    path = ENV.fetch('PROMETHEUS_EXPORTER_PATH', uri.path)

    events.on_booted do
      app = Yabeda::Prometheus::Exporter.rack_app(Yabeda::Prometheus::Exporter, path: path)

      metrics = Puma::Server.new app, events
      metrics.min_threads = 0
      metrics.max_threads = 1

      events.log "* Starting Yabeda Prometheus metrics exporter on http://#{host}:#{port}#{path}"
      metrics.add_tcp_listener host, port

      events.register(:state) do |state|
        if %i[halt restart stop].include?(state)
          metrics.stop(true) unless metrics.shutting_down?
        end
      end

      metrics.run
    end
  end
end
