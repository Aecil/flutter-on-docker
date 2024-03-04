FROM grafana/grafana:10.2.4
RUN /bin/bash -c 'grafana cli plugins install marcusolsson-json-datasource'
RUN /bin/bash -c 'grafana cli plugins install yesoreyeram-infinity-datasource'
