require 'yabeda/puma/plugin.rb'

Puma::Plugin.create do
  def start(launcher)
    clustered = (launcher.options[:workers] || 0) > 0

    control_url = launcher.options[:control_url]
    raise StandardError, "Puma control app is not activated" if control_url == nil

    Yabeda::Puma::Plugin.tap do |puma|
      puma.control_url = control_url
      puma.control_auth_token = launcher.options[:control_auth_token]
    end

    Yabeda::Puma::Plugin.install!(clustered: clustered)
  end
end

