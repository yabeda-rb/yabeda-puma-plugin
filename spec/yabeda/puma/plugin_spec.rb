require 'spec_helper'

RSpec.describe Yabeda::Puma::Plugin do
  it "has a version number" do
    expect(Yabeda::Puma::Plugin::VERSION).not_to be nil
  end

  describe '.install!' do
    let(:collectors) { [] }
    let(:configurators) { [] }

    before do
      allow(Yabeda).to receive(:collectors).and_return(collectors)
      allow(Yabeda).to receive(:configurators).and_return(configurators)
    end

    it 'adds a collector and a configurator' do
      expect do
        described_class.install!
      end.to change { Yabeda.collectors.size }.by(1)
        .and change { Yabeda.configurators.size }.by(1)
    end

    it 'collects Puma metrics for single mode' do
      described_class.install!

      yabeda_double = double('Yabeda')

      expect(yabeda_double).to receive(:group).with(:puma)

      expect(yabeda_double).to receive(:gauge).with(:backlog, any_args)
      expect(yabeda_double).to receive(:gauge).with(:running, any_args)
      expect(yabeda_double).to receive(:gauge).with(:pool_capacity, any_args)
      expect(yabeda_double).to receive(:gauge).with(:max_threads, any_args)

      expect(yabeda_double).to receive(:collect)

      configurator = configurators.first.last
      yabeda_double.instance_eval(&configurator)
    end

    it 'collects clustered Puma metrics' do
      described_class.install!(clustered: true)

      yabeda_double = double('Yabeda')

      expect(yabeda_double).to receive(:group).with(:puma)

      expect(yabeda_double).to receive(:gauge).with(:backlog, any_args)
      expect(yabeda_double).to receive(:gauge).with(:running, any_args)
      expect(yabeda_double).to receive(:gauge).with(:pool_capacity, any_args)
      expect(yabeda_double).to receive(:gauge).with(:max_threads, any_args)

      expect(yabeda_double).to receive(:gauge).with(:workers, any_args)
      expect(yabeda_double).to receive(:gauge).with(:booted_workers, any_args)
      expect(yabeda_double).to receive(:gauge).with(:old_workers, any_args)

      expect(yabeda_double).to receive(:collect)

      configurator = configurators.first.last
      yabeda_double.instance_eval(&configurator)
    end
  end
end
