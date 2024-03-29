[![CircleCI](https://img.shields.io/circleci/build/github/markormesher/speedtest-to-mqtt)](https://app.circleci.com/pipelines/github/markormesher/speedtest-to-mqtt)
[![Releases on GHCR](https://img.shields.io/badge/releases-ghcr.io-green)](https://ghcr.io/markormesher/speedtest-to-mqtt)

# Speedtest to MQTT

A simple utility image to monitor your Internet speeds via [Speedtest.net](https://speedtest.net) and publish them to MQTT.

## Configuration

:point_right: See this project's base library, [X to MQTT](https://github.com/markormesher/x-to-mqtt), for configuration reference.

The default update interval is 3600 seconds (1 hour), which is also the minimum interval that can be set to avoid spamming the upstream service.

## MQTT Topics

- `${prefix}/state/ping_latency` - ping latency in milliseconds
- `${prefix}/state/ping_jitter` - ping jitter in milliseconds
- `${prefix}/state/download_speed` - download bandwidth in Bps
- `${prefix}/state/upload_speed` - upload bandwidth in Bps

:point_right: See [X to MQTT](https://github.com/markormesher/x-to-mqtt) for other values published under the `${prefix}/_meta` topic, like the upstream service status.
