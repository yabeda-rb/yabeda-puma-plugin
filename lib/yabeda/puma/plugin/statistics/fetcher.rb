require 'yabeda/puma/plugin/statistics'
require 'json'

module Yabeda
  module Puma
    module Plugin
      module Statistics
        class Fetcher
          def self.call
            body = Socket.unix(Yabeda::Puma::Plugin.control_url.gsub("unix://", '')) do |socket|
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
