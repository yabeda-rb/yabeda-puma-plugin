require 'rack'

run do |_env|
  # do some hard work
  number = (0..9_999_990).to_a.map { |i| i * 2 }.sum

  [200, {}, ["Result #{number}"]]
end
