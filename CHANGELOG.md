# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## 0.7.1 - 2022-11-28

### Fixed

 - Error if exporter is stopped before creation. [@ollym][], [#27](https://github.com/yabeda-rb/yabeda-puma-plugin/pull/27)

## 0.7.0 - 2022-10-24

### Added

 - Puma 6.x support for `yabeda_prometheus` plugin. [@ollym][], [#25](https://github.com/yabeda-rb/yabeda-puma-plugin/pull/25)
 - Support phased restarts with standalone Prometheus exporter. [@botimer][], [#23](https://github.com/yabeda-rb/yabeda-puma-plugin/pull/23)
 - `on_prometheus_exporter_boot` hook in Puma config DSL. [@Envek][]

## 0.6.0 - 2021-02-05

### Changed

- “Most recent” aggregation mode specified for all gauge metrics. [@botimer], [#16](https://github.com/yabeda-rb/yabeda-puma-plugin/pull/16)

## 0.5.0 - 2020-11-13

### Changed

- Start Yabeda exporter on `on_booted` hook to support Puma 4.x daemon mode. [@Envek], [#14](https://github.com/yabeda-rb/yabeda-puma-plugin/pull/14)

## 0.4.0 - 2020-04-29

### Added

- `yabeda_prometheus` plugin to allow metrics export on separate port. [@jwhitcraft], [#11](https://github.com/yabeda-rb/yabeda-puma-plugin/pull/11)

## 0.3.0 - 2020-01-27

### Added

- Support for yabeda 0.2 (required by prometheus-client 1.0). [@Envek]

## 0.2.1 - 2019-12-16

### Fixed

- Fix undefined method in TCP socket. [@Neznauy], [#7](https://github.com/yabeda-rb/yabeda-puma-plugin/pull/7)

## 0.2.0 - 2019-12-12

### Added

- Support for TCP puma control panel url. [@dsalahutdinov]

## 0.1.0 - 2019-04-02

Initial release with basic metrics collection. [@dsalahutdinov]

[@ollym]: https://github.com/ollym "Oliver Morgan"
[@botimer]: https://github.com/botimer "Noah Botimer"
[@jwhitcraft]: https://github.com/jwhitcraft "Jon Whitcraft"
[@Neznauy]: https://github.com/Neznauy "Aleksandr Shlyakov"
[@Envek]: https://github.com/Envek "Andrey Novikov"
[@dsalahutdinov]: https://github.com/dsalahutdinov "Dmitry Salahutdinov"
