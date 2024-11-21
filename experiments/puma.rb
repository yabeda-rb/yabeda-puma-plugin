require 'yabeda/prometheus/mmap'
require 'yabeda/puma/plugin'

before_fork do
  Yabeda.configure!
end

activate_control_app 'unix:///var/run/pumactl.sock'
plugin :yabeda
plugin :yabeda_prometheus
