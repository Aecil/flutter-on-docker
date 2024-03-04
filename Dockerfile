FROM grafana/grafana:latest
RUN /bin/bash -c 'grafana-cli plugins install marcusolsson-json-datasource'
RUN /bin/bash -c 'grafana-cli plugins install yesoreyeram-infinity-datasource'
