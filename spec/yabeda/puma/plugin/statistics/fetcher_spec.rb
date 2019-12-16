require 'spec_helper'
require 'support/http_server'
require 'yabeda/puma/plugin/statistics/fetcher'

RSpec.describe Yabeda::Puma::Plugin::Statistics::Fetcher do
  describe '#call' do
    let(:fetcher) { described_class }
    let(:metrics) { {metric_1: 1, metric_2: 2} }

    context 'when unix socket' do
      let(:unix_addr) { '/tmp/sock_test' }
      
      before { Yabeda::Puma::Plugin.control_url = "unix://#{unix_addr}" }

      after { system("rm #{unix_addr}") }

      it do
        server = HttpServer.new(UNIXServer.new(unix_addr), metrics.to_json)
        
        Thread.new { server.start }

        expect(fetcher.call).to eq metrics.transform_keys(&:to_s)
      end
    end

    context 'when tcp socket' do
      let(:port) { 4000 }

      before { Yabeda::Puma::Plugin.control_url = "tcp://0.0.0.0:#{port}" }

      it do
        server = HttpServer.new(TCPServer.new(port), metrics.to_json)
        
        Thread.new { server.start }

        expect(fetcher.call).to eq metrics.transform_keys(&:to_s)
      end
    end

    context 'when invalid address' do
      let(:addr) { 'invalid_addr' }

      before { Yabeda::Puma::Plugin.control_url = addr }

      it do
        expect{fetcher.call}.to raise_error(ArgumentError)
      end
    end
  end
end
