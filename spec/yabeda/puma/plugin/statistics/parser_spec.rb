require 'spec_helper'
require 'yabeda/puma/plugin/statistics/parser'

RSpec.describe Yabeda::Puma::Plugin::Statistics::Parser do

  describe '#parse' do
    subject(:statistics) { described_class.new(clustered: clustered, data: data).call }

    context 'when puma is clustered' do
      let(:clustered) { true }
      let(:data) do
        {
          "workers"=>2, "phase"=>0, "booted_workers"=>2, "old_workers"=>0,
          "worker_status"=>[
            {"pid"=>13, "index"=>0, "phase"=>0, "booted"=>true, "last_checkin"=>"2019-03-31T13:04:28Z",
             "last_status"=>{
              "backlog"=>0, "running"=>5, "pool_capacity"=>5, "max_threads"=>5
            }},
            {"pid"=>17, "index"=>1, "phase"=>0, "booted"=>true, "last_checkin"=>"2019-03-31T13:04:28Z",
             "last_status"=>{
              "backlog"=>0, "running"=>5, "pool_capacity"=>5, "max_threads"=>5
            }
            }
          ]
        }
      end

      it do
        expect(statistics).to match_array(
          [
            { name: 'booted_workers', labels: {}, value: 2 },
            { name: 'old_workers', labels: {}, value: 0 },
            { name: 'workers', labels: {}, value: 2 },

            { name: 'backlog', labels: {index: 0}, value: 0 },
            { name: 'running', labels: {index: 0}, value: 5 },
            { name: 'pool_capacity', labels: {index: 0}, value: 5 },
            { name: 'max_threads', labels: {index: 0}, value: 5 },

            { name: 'backlog', labels: {index: 1}, value: 0 },
            { name: 'running', labels: {index: 1}, value: 5 },
            { name: 'pool_capacity', labels: {index: 1}, value: 5 },
            { name: 'max_threads', labels: {index: 1}, value: 5 }
          ]
        )
      end
    end


    context 'when puma is unclustered' do
      let(:clustered) { false }
      let(:data) do
        {"backlog"=>0, "running"=>5, "pool_capacity"=>4, "max_threads"=>5}
      end

      it do
        expect(statistics).to match_array(
          [
            { name: 'backlog', labels: {index: 0}, value: 0 },
            { name: 'running', labels: {index: 0}, value: 5 },
            { name: 'pool_capacity', labels: {index: 0}, value: 4 },
            { name: 'max_threads', labels: {index: 0}, value: 5 }
          ]
        )
      end
    end
  end
end
