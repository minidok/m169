# Installation von Sock Shop via Docker Compose
Eine Installationsvariante mit Docker-Compose.

### Voraussetzungen
Installation Docker Engine und Docker-Compose
Weave Scope Verwendung ist keine Voraussetzung

### Clone aus Gitrepo
    git clone https://github.com/minidok/m169.git
oder wenn schon mal ausgeführt nur noch:

    git pull

Wechseln sie in das Verzeichnis m169

    cd m169

### Branch im Repo umstellen
    git checkout BFSU-Microservices-Socks-shop
    cd microservices-demo

### Installation von Waeve Scope
    sudo curl -L git.io/scope -o /usr/local/bin/scope
    sudo chmod a+x /usr/local/bin/scope
    scope launch
Es wird ein Container gestartet und die URL angezeigt:

````Scope probe started
Weave Scope is listening at the following URL(s):
  * http://172.22.0.1:4040/
  * http://172.25.0.1:4040/
  * http://172.20.0.1:4040/
  * http://172.18.0.1:4040/
  * http://172.19.0.1:4040/
  * http://192.168.106.129:4040/
````

### Microservices starten "socks shop" 
    docker-compose -f ./deploy/docker-compose/docker-compose.yml up -d

### Monitoring Grafana
#### Einmalige Anpassungen
Script berechtigen zur Ausführung:

    chmod +x ./deploy/docker-compose/grafana/import.sh
Container erzeugen und einmalig mit JSON Konfigurtionen für Grafana-Dashboard versorgen

    docker-compose \
    -f ./deploy/docker-compose/docker-compose.monitoring.yml \
    run \
    --entrypoint /opt/grafana-import-dashboards/import.sh \
    --rm \
    importer 

In diesem Schritt wurden die Konfigurationen für das Dashboard und die Datenquelle in Grafana elegant in den Docker Container Grafana kopiert. 🎉
Falls es einen Fehler gibt, löschen sie den Container Grafana nochmals und führen den vorherigen Schritt erneut aus.

### Grafana und Prometheus deployen
    docker-compose -f ./deploy/docker-compose/docker-compose.monitoring.yml up -d

Prüfen sie, ob alle Services bereit sind:

    docker-compose -f ./deploy/docker-compose/docker-compose.monitoring.yml ps

#### URL und Ports
Port | Service
--------|--------
22  | ssh
27017 | mongo
3000 | Grafana
80 | Frontend
8080 | Traeffik Router
9090 | Prometheus
9093 | Prom. alertnamager
9100 | Prometheus Node Exporter

#### Benutzer
Username	|Password
---------|-----------
admin | foobar
user	|password
user1	|password
Eve_Berger	|eve


### Cleaning up
    docker-compose -f ./deploy/docker-compose/docker-compose.yml down
