require "net/http"
require "timeout"
require 'tempfile'
require "puma"
require "puma/events"
require "puma/detect"
require "puma/cli"
require 'rack'

RSpec.describe Yabeda::Puma::Plugin do
  def next_port(incr = 1)
    @next_port = 9000 if @next_port == nil
    @next_port += incr
  end

  before(:each) do
    @wait, @ready = IO.pipe

    if defined? Puma::LogWriter
      @events = Puma::Events.new
      @log_writer = Puma::LogWriter.strings
    else
      @events = Puma::Events.strings
    end

    @events.on_booted { @ready << "!" }
  end

  after(:each) do
    @wait.close
    @ready.close
  end

  def wait_booted
    @wait.sysread 1
  end

  describe '/metrics' do
    let(:port) { next_port }
    it do
      cli = Puma::CLI.new ["-b", "tcp://127.0.0.1:#{port}",
                           "-C", "spec/configs/puma.rb",
                           "spec/configs/lobster.ru"], *[@log_writer, @events].compact

      t = Thread.new do
        Thread.current.abort_on_exception = true
        Yabeda.configure!
        cli.run
      end

      wait_booted

      # wait until the first status ping has come through
      sleep(6)

      response = Net::HTTP.start('127.0.0.1', port) do |http|
        request = Net::HTTP::Get.new '/metrics'
        http.request request
      end

       expect(response.body).to match("puma_backlog\\\{index=\"\\\d+\\\"\\\} \\\d+")
       expect(response.body).to match("puma_running\\\{index=\"\\\d+\\\"\\\} \\\d+")
       expect(response.body).to match("puma_pool_capacity\\\{index=\"\\\d+\\\"\\\} \\\d+")
       expect(response.body).to match("puma_max_threads\\\{index=\"\\\d+\\\"\\\} \\\d+")

       expect(response.body).to include("puma_workers 2")
       expect(response.body).to include("puma_booted_workers 2")
       expect(response.body).to include("puma_old_workers 0")
    end
  end
end
