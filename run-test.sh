#!/usr/bin/env bash
set -euo pipefail

MQTT_HOST=${MQTT_HOST}
MQTT_TOPIC_PREFIX=${MQTT_TOPIC_PREFIX:-speedtest}
INTERVAL=${INTERVAL:-3600}

while true; do
  attempt=1
  while true; do
    echo "Starting speed test @ $(date) (attempt #${attempt})"

    test_time=$(date -Iseconds)
    set +e
    result=$(/usr/local/bin/speedtest-cli --json)
    exit_code="$?"
    set -e

    if [[ "${exit_code}" != 0 ]]; then
      echo "Attempt #${attempt} failed at $(date) with exit code ${exit_code}"
      echo "Result was ${result}"
      attempt=$(( attempt + 1 ))
      if [[ "${attempt}" -gt 3 ]]; then
        echo "Giving up @ $(date)"
        break
      else
        echo "Sleeping 30s before trying again"
        sleep 30s
      fi
    else
      latency="$(echo "${result}" | jq -rc '.ping')"
      download="$(echo "${result}" | jq -rc '.download')"
      upload="$(echo "${result}" | jq -rc '.upload')"
      echo "Results: ${upload} up / ${download} down, ${latency} ping"

      echo "Posting results @ $(date)"
      mosquitto_pub -h "${MQTT_HOST}" -t "${MQTT_TOPIC_PREFIX}/last_seen" -m "${test_time}"
      mosquitto_pub -h "${MQTT_HOST}" -t "${MQTT_TOPIC_PREFIX}/ping_latency" -m "${latency}"
      mosquitto_pub -h "${MQTT_HOST}" -t "${MQTT_TOPIC_PREFIX}/download_speed" -m "${download}"
      mosquitto_pub -h "${MQTT_HOST}" -t "${MQTT_TOPIC_PREFIX}/upload_speed" -m "${upload}"
      echo "Finished posting results @ $(date)"
      break
    fi
  done

  echo "Testing again in ${INTERVAL} seconds"
  sleep "${INTERVAL}"
done
