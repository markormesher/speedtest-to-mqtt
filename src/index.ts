import { XToMqtt, logger, registerRepeatingUpdate } from "@markormesher/x-to-mqtt";
import speedtest from "speedtest-net";

const mqttWrapper = new XToMqtt();

registerRepeatingUpdate({ runImmediately: true, defaultIntervalSeconds: 3600, minIntervalSeconds: 3600 }, () => {
  logger.info("Starting speed test");
  speedtest({ acceptLicense: true, acceptGdpr: true })
    .then((result) => {
      logger.info("Speed test finished");
      mqttWrapper.updateUpstreamStatus("okay");
      mqttWrapper.publish("state/ping_latency", result.ping.latency);
      mqttWrapper.publish("state/ping_jitter", result.ping.jitter);
      mqttWrapper.publish("state/download_speed", result.download.bandwidth);
      mqttWrapper.publish("state/upload_speed", result.upload.bandwidth);
    })
    .catch((error) => {
      console.log(error);
      logger.error("Speed test failed", { error: error as Error });
      mqttWrapper.updateUpstreamStatus("errored");
    });
});
