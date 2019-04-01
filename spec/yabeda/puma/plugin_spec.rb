require 'spec_helper'

RSpec.describe Yabeda::Puma::Plugin do
  it "has a version number" do
    expect(Yabeda::Puma::Plugin::VERSION).not_to be nil
  end
end
