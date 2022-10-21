source "https://rubygems.org"

gem 'yabeda-prometheus'

# Specify your gem's dependencies in yabeda-puma.gemspec
gemspec

puma_version = ENV.fetch("PUMA_VERSION", "~> 6.0")
puma_version = "~> #{puma_version}.0" if puma_version.match?(/^\d+$/)
gem "puma", puma_version
