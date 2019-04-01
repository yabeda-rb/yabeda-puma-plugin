require 'yabeda/puma/statistics'
require 'json'

module Yabeda
  module Puma
    module Statistics
      class Fetcher
        def self.call
          body = Socket.unix(Yabeda::Puma.control_url.gsub("unix://", '')) do |socket|
            socket << "GET /stats?token=#{Yabeda::Puma.control_auth_token} HTTP/1.0\r\n\r\n"
            socket.read
          end

          JSON.parse(body.split("\n").last)
        end
      end
    end
  end
end
