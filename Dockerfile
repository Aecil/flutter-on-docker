FROM grafana/grafana:latest
RUN /bin/bash -c "grafana-cli plugins install marcusolsson-json-datasource yesoreyeram-infinity-datasource"
