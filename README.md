![CircleCI](https://img.shields.io/circleci/build/github/markormesher/speedtest-to-mqtt)

# speedtest-to-mqtt

A simple utility image to monitor your internet speeds via [speedtest-cli](https://pypi.org/project/speedtest-cli/).

:rocket: Jump to [quick-start example](#quick-start-docker-compose-example).

:whale: See releases on [ghcr.io](https://ghcr.io/markormesher/speedtest-to-mqtt).

## Configuration via Environment Variables

All arguments are required if they do not have a default value listed below.

- `MQTT_HOST` - must include the `mqtt://...` prefix and any non-default port number.
- `MQTT_TOPIC_PREFIX` - MQTT topic prefix (default: `speedtest/state`).
- `INTERVAL` - how often, in seconds, to repeat the test (default: 3600).

## MQTT Topics and Messages

### System Information

```
${prefix}/last_seen = ISO datetime string of the last time journeys were published
```

### Speed Information

```
${prefix}/journey_${rowNum}/ping_latency (unit: ms)
${prefix}/journey_${rowNum}/download_speed (unit: Bps)
${prefix}/journey_${rowNum}/upload_speed (unit: Bps)
```

## Quick-Start Docker-Compose Example

```yaml
services:
  speedtest-to-mqtt:
    image: ghcr.io/markormesher/speedtest-to-mqtt
    environment:
      - MQTT_HOST=mqtt://my-mqtt-host
      - TOPIC_PREFIX=speedtest/state
      - INTERVAL=3600
```
