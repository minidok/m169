# m169

# Container mit Docker laufen lassen

Docker holt sich das image aus dem repository und lässt den Webserver NGINX auf Port 8081 laufen.
```
docker run --publish 8081:80 --name aWebserver nginx
```

Alle Container anzeigen
```
docker ps -a
```

Container stoppen
```
docker stop aWebserver
```

Container wegräumen
```
docker rm aWebserver
```

# Container und Volumes

Ein Volume erstellen
```
docker volume create aVolume
```
Volume untersuchen
```
docker volume inspect aVolume
```
Volumes auflisten
```
docker volume ls
```
Container mit Volume anbinden
```
docker run -d --name aContainerWithVolume -v aVolume:/app alpine:latest
```
