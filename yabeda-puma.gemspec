
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yabeda/puma/version"

Gem::Specification.new do |spec|
  spec.name          = "yabeda-puma"
  spec.version       = Yabeda::Puma::VERSION
  spec.authors       = ["Salahutdinov Dmitry"]
  spec.email         = ["dsalahutdinov@gmail.com"]

  spec.summary       = %q{Collecting metrics of the puma web server.}
  spec.description   = %q{Extends Yabeda metrics with puma web server values by using puma plugin}
  spec.homepage      = "http://github.com/yabeda-rb/yabeda-puma"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "yabeda"
  spec.add_runtime_dependency "puma"
  spec.add_runtime_dependency "json"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rack"
end
