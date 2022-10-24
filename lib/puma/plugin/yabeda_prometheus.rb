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

    def on_prometheus_exporter_boot(&block)
      @options[:prometheus_exporter_boot_hooks] ||= []
      @options[:prometheus_exporter_boot_hooks] << block
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

    server = nil
    logger = events
    banner = "Yabeda Prometheus metrics exporter on http://#{host}:#{port}#{path}"

    create_server = -> {
      app = Yabeda::Prometheus::Exporter.rack_app(Yabeda::Prometheus::Exporter, path: path)
      internal_events = Puma::Events.respond_to?(:null) ? Puma::Events.null : Puma::Events.new
      server = Puma::Server.new app, internal_events, min_threads: 0, max_threads: 1
      logger = server.respond_to?(:log_writer) ? server.log_writer : events

      server.add_tcp_listener host, port
      if server.respond_to?(:min_threads=)
        server.min_threads = 0
        server.max_threads = 1
      end

      internal_events.register(:state) do |state|
        next unless state == :running
        hooks = launcher.options.fetch(:prometheus_exporter_boot_hooks, [])
        hooks.each(&:call)
      end

      [server, logger]
    }

    events.on_booted do
      unless server&.running
        server, logger = create_server.call
        logger.log "* Starting #{banner}"
        server.run
      end
    end

    events.on_stopped do
      unless server&.shutting_down?
        logger.log "* Stopping #{banner}"
        server.stop(true)
      end
    end

    events.on_restart do
      logger.log "* Restarting #{banner}"
      server.stop(true)
      server, logger = create_server.call
      server.run
    end
  end
end
