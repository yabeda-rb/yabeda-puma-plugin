require 'puma/plugin/yabeda'
require 'puma/plugin/yabeda_prometheus'
require 'yabeda'
require 'yabeda/prometheus'

workers 2
threads 1, 1
activate_control_app
plugin 'yabeda'
plugin 'yabeda_prometheus'
prometheus_exporter_url "tcp://127.0.0.1:9394/metrics"

before_fork do
  Yabeda.configure!
end

on_prometheus_exporter_boot do
  Process.kill(:USR1, Integer(ENV.fetch("TEST_RUNNER_PID")))
end
