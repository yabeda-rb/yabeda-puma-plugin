require "yabeda/puma/version"
require 'yabeda'

module Yabeda
  module Puma
    class << self
      attr_accessor :control_url, :control_auth_token
    end
  end
end
