require 'rack/lobster'
require 'prometheus/client'
require 'yabeda/prometheus'

use Yabeda::Prometheus::Exporter
use Rack::ShowExceptions
run Rack::Lobster.new
