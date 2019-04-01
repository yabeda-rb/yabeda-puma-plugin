module Yabeda
  module Puma
    module Plugin
      module Statistics
        METRICS = [:backlog, :running, :pool_capacity, :max_threads, :workers]
        CLUSTERED_METRICS = [:booted_workers, :old_workers]
      end
    end
  end
end
