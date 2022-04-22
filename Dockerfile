FROM python:alpine3.15
WORKDIR /speedtest-to-mqtt
RUN pip3 install speedtest-cli
RUN apk add --no-cache mosquitto-clients jq bash
COPY ./run-test.sh ./
CMD ./run-test.sh
