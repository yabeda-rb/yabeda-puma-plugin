require "net/http"

# on_stopped hook was added in Puma 5.1 in https://github.com/puma/puma/commit/288a4cf756852a4837c77ee70d7fdcca1edb8e82
return if Gem::Version.new(Puma::Const::PUMA_VERSION) < Gem::Version.new("5.1")

RSpec.describe "Standalone Prometheus Exporter" do
  before(:each) do
    cmd = <<~EOF
      bundle exec puma \
        -b tcp://127.0.0.1:9222 \
        -C spec/configs/puma_standalone.rb \
        spec/configs/standalone.ru
    EOF
    @io = IO.popen cmd, err: [:child, :out]
    @pid = @io.pid
    sleep 0.5
  end

  after(:each) do
    Process.kill "INT", @pid 
    Process.wait @pid
  end

  it 'serves app on configured port' do
    res = get 9222, "/"
    expect(res.body).to match(/Lobstericious/)
  end

  it 'serves metrics on exporter url' do
    res = get 9394, "/metrics"
    expect(res.body).to match(/^# TYPE puma_workers gauge/)
  end

  it 'serves metrics after hot restart' do
    Process.kill("USR2", @pid)
    sleep 0.5
    res = get 9394, "/metrics"
    expect(res.body).to match(/^# TYPE puma_workers gauge/)
  end

  it 'serves metrics after phased restart' do
    Process.kill("USR1", @pid)
    sleep 0.5
    res = get 9394, "/metrics"
    expect(res.body).to match(/^# TYPE puma_workers gauge/)
  end

  def get(port, path = "/")
    retries = 3
    begin
      Net::HTTP.start("127.0.0.1", port, open_timeout: 3) do |http|
        req = Net::HTTP::Get.new path
        return http.request req
      end
    rescue Errno::ECONNREFUSED
      if retries > 0
        retries -= 1
        sleep 1
        retry
      else
        raise "Connection failed too many times for http://127.0.0.1:#{port}#{path}"
      end
    end
    nil
  end
end
