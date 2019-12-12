require 'yabeda/puma/plugin/statistics'
require 'json'

module Yabeda
  module Puma
    module Plugin
      module Statistics
        class Fetcher
          def self.call
            control_url = Yabeda::Puma::Plugin.control_url

            if control_url.start_with? "unix://"
              path = control_url.gsub("unix://", '')
              sock = Socket.unix(path)
            elsif control_url.start_with? "tcp://"
              host, port = control_url.match(/^tcp:\/\/([a-z0-9\-._~%]+):([0-9]+)/).captures

              sock = Socket.tcp(host, port)
            else
              raise ArgumentError("Unknown puma control url type #{control_url}")
            end

            body = sock do |socket|
              socket << "GET /stats?token=#{Yabeda::Puma::Plugin.control_auth_token} HTTP/1.0\r\n\r\n"
              socket.read
            end

            JSON.parse(body.split("\n").last)
          end
        end
      end
    end
  end
end
