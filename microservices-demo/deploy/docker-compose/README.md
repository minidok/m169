# Installation von Sock Shop via Docker Compose
Eine Installationsvariante mit Docker-Compose.

### Voraussetzungen
Installation Docker Engine und Docker-Compose
Weave Scope Verwendung ist keine Voraussetzung

### Clone aus Gitrepo
    git clone https://github.com/minidok/m169.git
    
### Branch im Repo umstellen
    git checkout BFSU-Microservices-Socks-shop
    cd microservices-demo

### Installation von Waeve Scope
    sudo curl -L git.io/scope -o /usr/local/bin/scope
    sudo chmod a+x /usr/local/bin/scope
    scope launch

### Microservices starten "socks shop" 
    docker-compose -f deploy/docker-compose/docker-compose.yml up -d

### Monitoring deployen
    docker-compose -f ./deploy/docker-compose/docker-compose.monitoring.yml up -d

### Monitoring Grafana
Einmalige Konfiguration für Grafana
[Folgen sie Abschnitt 2 unter diesem Link](https://github.com/minidok/m169/blob/main/grafana/Readme.md#2-einmalige-anpassungen)

### Cleaning up
docker-compose -f deploy/docker-compose/docker-compose.yml down