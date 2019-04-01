require "yabeda/puma/plugin/version"
require 'yabeda'

module Yabeda
  module Puma
    module Plugin
      class << self
        attr_accessor :control_url, :control_auth_token
      end
    end
  end
end
