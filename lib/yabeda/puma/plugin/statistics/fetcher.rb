require 'yabeda/puma/plugin/statistics'
require 'json'

module Yabeda
  module Puma
    module Plugin
      module Statistics
        class Fetcher
          def self.call
            control_url = Yabeda::Puma::Plugin.control_url

            body = if control_url.start_with? "unix://"
              path = control_url.gsub("unix://", '')
              Socket.unix(path, &socket_block)
            elsif control_url.start_with? "tcp://"
              host, port = control_url.match(/^tcp:\/\/([a-z0-9\-._~%]+):([0-9]+)/).captures
              Socket.tcp(host, port, &socket_block)
            else
              raise ArgumentError.new("Unknown puma control url type #{control_url}")
            end

            JSON.parse(body.split("\n").last)
          end

          private

          def self.socket_block
            Proc.new do |s|
              s << "GET /stats?token=#{Yabeda::Puma::Plugin.control_auth_token} HTTP/1.0\r\n\r\n"
              s.read
            end
          end
        end
      end
    end
  end
end
