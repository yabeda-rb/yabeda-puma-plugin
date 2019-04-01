<a href="https://amplifr.com/?utm_source=uibook">
  <img width="100" height="140" align="right"
    alt="Sponsored by Amplifr" src="https://amplifr-direct.s3-eu-west-1.amazonaws.com/social_images/image/37b580d9-3668-4005-8d5a-137de3a3e77c.png" />
</a>

# Yabeda::Puma

Built-in metrics for [Puma](https://github.com/puma/puma) web server monitoring out of the box! Part of the [yabeda](https://github.com/yabeda-rb/yabeda) suite.

## Metrics

Works as the Puma plugin and provides following metrics:
 - `puma_workers` - the number of running puma workers
 - `puma_booted_workers` - the number of booted puma workers
 - `puma_old_workers` - the number of old puma worker

 - `puma_pool_capacity` - the capacity of each worker (segmented by the worker number)
 - `puma_running` - the number of running thread for any puma worker (segmented by the worker number)
 - `puma_max_threads` - the maximum number of worker threads (segmented by the worker number)
 - `puma_backlog` - the number of backlog threads (segmented by the worker number)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yabeda-puma'
```

And then execute:

    $ bundle

## Usage

Add those 2 lines of code to your `config/puma.rb` file:
```ruby
activate_control_app
plugin :yabeda
```
It will activate default puma control application working over the unix socket, and runs the `yabeda` puma plugin, for registering and collecting the metrics.

## Roadmap (TODO or Help wanted)

- Collect also `control-gc` puma metrics

## Development with Docker

Get local development environment working and tests running is very easy with docker-compose:
```bash
docker-compose run app bundle
docker-compose run app bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yabeda-puma.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
