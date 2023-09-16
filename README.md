[![CircleCI](https://img.shields.io/circleci/build/github/markormesher/speedtest-to-mqtt)](https://app.circleci.com/pipelines/github/markormesher/speedtest-to-mqtt)

# Speedtest to MQTT

A simple utility image to monitor your Internet speeds via [Speedtest.net](https://speedtest.net) and publish them to MQTT.

:package: See container versions on [ghcr.io](https://ghcr.io/markormesher/speedtest-to-mqtt).

## Configuration

:point_right: See this project's base library, [X to MQTT](https://github.com/markormesher/x-to-mqtt), for configuration reference.

The default update interval is 3600 seconds (1 hour), which is also the minimum interval that can be set to avoid spamming the upstream service.

## MQTT Topics

- `${prefix}/ping_latency` - ping latency in milliseconds
- `${prefix}/ping_jitter` - ping jitter in milliseconds
- `${prefix}/download_speed` - download bandwidth in Bps
- `${prefix}/upload_speed` - upload bandwidth in Bps

:point_right: See [X to MQTT](https://github.com/markormesher/x-to-mqtt) for other topics used for meta-results, like the upstream service status.
