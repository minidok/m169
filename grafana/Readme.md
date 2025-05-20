# Grafana
https://grafana.com bietet die Möglichkeit verschiedene System zu überwachen.
Für das Monitoring benötigt Grafana eine Datasource und kann die Daten (Metriken) daraus grafisch abbilden oder auch nummerisch überwachen.
Grafana verwendet dazu Dashboards, welche mit verschiedenen grafischen elementen ausgestattet werden können.


## 1 Laboraufbau für die Überwachung ihrer Docker Instanz
Holen sie sich als erstes eine frische Kopie meines Repos aus github. Wechseln sie in das Verzeichnis, wo sie mein Repo gepullt haben.
z.B. /home/benutzer/docker/m169
und führen ein git pull aus, um die aktuellen Daten abzurufen:

    git clone https://github.com/minidok/m169.git 
    oder aber
    git pull

Im Verzeichnis gibt es nun das Unterverzeichnis **./microservices-demo** .
Wechseln sie genau in dieses Verzeichnis.
### Services starten
Sie befinden sich nun im Unterverzeichnis ./microservoces-demo und starten die Services für das Monitoring mit folgendem Kommando:
    
    docker compose -f ./deploy/docker-compose/docker-compose.monitoring.yml up -d

:+1: _Ausgabe markiert mit grünem "done", wenn die Services ok sind nach dem Start:_
Creating network "docker-compose_default" with the default driver
Creating docker-compose_alertmanager_1 ... **done**
Creating nodeexporter                  ... done
Creating prometheus                    ... done
Creating docker-compose_grafana_1      ... done
Creating docker-compose_importer_1     ... done

### 2 Einmalige Anpassungen
Script berechtigen zur Ausführung:

    chmod +x ./deploy/docker-compose/grafana/import.sh
Container erzeugen und einmalig mit JSON Konfigurtionen für Grafana-Dashboard versorgen

    docker compose \
    -f ./deploy/docker-compose/docker-compose.monitoring.yml \
    run \
    --entrypoint /opt/grafana-import-dashboards/import.sh \
    --rm \
    importer  

### 3 Zugriff auf die Services
Im docker-compose.monitoring.yml finden sie die Ports auf die Services. Verwenden sie beim Aufruf die IP ihrer VM Debian und die vorgefundenen Ports für die SErvices:
* Prometheus
* Grafana

Das Login für Grafana ist admin und das PW foobar

Weiter geht es auf der Moodle Seite, Aufgabe zu Grafana
