require 'socket'

class HttpServer
  def initialize(server, json)
    @server = server
    @json   = json
  end

  def start
    while session = server.accept
      request = session.gets

      session.print "HTTP/1.1 200\r\n"
      session.print "Content-Type: application/json\r\n"
      session.print "\r\n"
      session.print json

      session.close
    end
  end

  private

  attr_reader :server, :json
end
