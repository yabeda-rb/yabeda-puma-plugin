require 'yabeda/puma.rb'

Puma::Plugin.create do
  def start(launcher)
    clustered = (launcher.options[:workers] || 0) > 0

    control_url = launcher.options[:control_url]
    raise StandardError, "Puma control app is not activated" if control_url == nil

    Yabeda::Puma.tap do |puma|
      puma.control_url = control_url
      puma.control_auth_token = launcher.options[:control_auth_token]
    end

    Yabeda.configure do
      group :puma
      
      gauge :backlog, comment: 'Number of established but unaccepted connections in the backlog'
      gauge :running, comment: 'Number of running worker threads'
      gauge :pool_capacity, comment: 'Number of allocatable worker threads'
      gauge :max_threads, comment: 'Maximum number of worker threads'
      gauge :workers, comment: 'Number of configured workers'

      if clustered
        gauge :booted_workers, comment: 'Number of booted workers'
        gauge :old_workers, comment: 'Number of old workers'
      end

      collect do
        require 'yabeda/puma/statistics/fetcher'
        stats = Yabeda::Puma::Statistics::Fetcher.call
        require 'yabeda/puma/statistics/parser'
        Yabeda::Puma::Statistics::Parser.new(clustered: clustered, data: stats).call.each do |item|
          send("puma_#{item[:name]}").set(item[:labels], item[:value])
        end
      end
    end
  end
end

