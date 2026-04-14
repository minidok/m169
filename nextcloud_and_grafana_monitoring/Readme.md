# Nextcloud + Grafana Monitoring
> **Modul:** M169 — Services mit Containern bereitstellen  
> **Repository:** [github.com/minidok/m169](https://github.com/minidok/m169)

---

## Systemübersicht

![Architektur-Diagramm](./systemuebersicht.svg)

| Dienst | Image | Port | Aufgabe |
|--------|-------|------|---------|
| Nextcloud | `nextcloud:29-apache` | 8088 | Filehosting-Plattform |
| MariaDB | `mariadb:11` | intern | Datenbank für Nextcloud |
| Redis | `redis:7-alpine` | intern | Session-Cache / File-Locking |
| nextcloud-exporter | `xperimental/nextcloud-exporter` | 9205 | Nextcloud → Prometheus Adapter |
| node-exporter | `prom/node-exporter` | 9100 | Host-Metriken (CPU, RAM, Disk) |
| Prometheus | `prom/prometheus` | 9090 | Metriken sammeln & speichern |
| Grafana | `grafana/grafana` | 3003 | Dashboards & Visualisierung |

---

## Voraussetzungen

Folgendes wird als bereits vorhanden angenommen:

- Windows 11 mit installiertem Hypervisor
- Debian-VM läuft und ist per SSH erreichbar
- Docker und Docker Compose sind auf der VM installiert

---

## Verzeichnisstruktur

```
nextcloud_and_grafana_monitoring/
├── compose.yaml
├── .env                          ← Passwörter und Konfiguration
├── prometheus/
│   ├── prometheus.yml            ← Scrape-Konfiguration
│   └── alerts.yml                ← Alert-Regeln
└── grafana/
    └── provisioning/
        └── datasources/
            └── prometheus.yml    ← Datasource automatisch einbinden
```

---

## Schritt 1 — Nur den Unterordner aus dem Repository holen

Das Repository `minidok/m169` enthält mehrere Projekte. Mit `sparse-checkout` wird nur der benötigte Unterordner heruntergeladen:

```bash
# Leeres Repository initialisieren (kein vollständiger Download)
git clone --no-checkout --depth=1 --filter=blob:none \
  https://github.com/minidok/m169.git
cd m169

# Nur den Monitoring-Unterordner auschecken
git sparse-checkout init --cone
git sparse-checkout set nextcloud_and_grafana_monitoring
git checkout main

# In den Stack-Ordner wechseln
cd nextcloud_and_grafana_monitoring
```

Danach liegt nur der Unterordner `nextcloud_and_grafana_monitoring/` lokal vor — der Rest des Repositories wird nicht heruntergeladen.

---

## Schritt 2 — Umgebungsvariablen konfigurieren

Die Datei `.env` enthält alle Passwörter und Konfigurationswerte. **Vor dem ersten Start anpassen:**

```bash
nano .env
```

Inhalt der `.env`:

```env
# Nextcloud
NC_TRUSTED_DOMAINS=localhost nextcloud <IP-der-VM>
NC_ADMIN_USER=admin
NC_ADMIN_PASSWORD=sicheres-passwort

# Datenbank
MYSQL_PASSWORD=sicheres-db-passwort
MYSQL_ROOT_PASSWORD=sicheres-root-passwort

# Grafana
GF_ADMIN_USER=admin
GF_ADMIN_PASSWORD=sicheres-grafana-passwort

```

> **Wichtig:** Die Trusted Domains müssen die IP-Adresse der VM enthalten, damit der nextcloud-exporter Nextcloud erreichen kann. Mehrere Domains mit Leerzeichen trennen.

---

## Schritt 3 — Stack starten

```bash
docker compose up -d
```

Docker lädt alle Images herunter und startet die Dienste. Der erste Start dauert **2–3 Minuten**, da Nextcloud die Datenbank initialisiert.

Status prüfen:

```bash
docker compose ps
```

Alle Dienste sollten `running` oder `healthy` anzeigen.

Logs verfolgen:

```bash
docker compose logs -f nextcloud
```

---

## Schritt 4 — Nextcloud aufrufen

Nextcloud ist erreichbar unter:

```
http://<IP-der-VM>:8088
```

Login mit den Werten aus der `.env`:
- **Benutzer:** Wert von `NC_ADMIN_USER`
- **Passwort:** Wert von `NC_ADMIN_PASSWORD`

---

## Schritt 5 — Trusted Domain setzen (falls nötig)

Falls der nextcloud-exporter `status code 400` meldet, die interne Docker-Domain als Trusted Domain eintragen:

```bash
docker exec --user www-data nextcloud_and_grafana_monitoring-nextcloud-1 \
  php occ config:system:set trusted_domains 1 --value="nextcloud"
```

Aktuelle Trusted Domains prüfen:

```bash
docker exec --user www-data nextcloud_and_grafana_monitoring-nextcloud-1 \
  php occ config:system:get trusted_domains
```

---

## Schritt 6 — Grafana aufrufen

Grafana ist erreichbar unter:

```
http://<IP-der-VM>:3003
```

Login:
- **Benutzer:** Wert von `GF_ADMIN_USER`
- **Passwort:** Wert von `GF_ADMIN_PASSWORD`

Die Prometheus-Datasource ist bereits automatisch konfiguriert (via Provisioning).

---

## Schritt 7 — Dashboards importieren

In Grafana: **Dashboards → New → Import**

| Dashboard ID | Name | Beschreibung |
|-------------|------|--------------|
| **9632** | Nextcloud | Hauptdashboard: Nutzer, Speicher, Shares, Auth-Fehler |
| **11033** | Nextcloud Exporter | Detaillierte Zeitreihen aller Nextcloud-Metriken |
| **1860** | Node Exporter Full | Host-Metriken: CPU, RAM, Disk, Netzwerk |

**Beim Import von Dashboard 9632:**

1. ID `9632` eingeben → **Load**
2. Im Feld **DS_PROMETHEUS** die Datasource `PROMETHEUS` auswählen
3. **Import** klicken

Falls das Dashboard nach dem Import `Datasource ${DS_PROMETHEUS} was not found` meldet, per API patchen:

```bash
curl -s http://admin:PASSWORT@localhost:3003/api/dashboards/uid/$(
  curl -s "http://admin:PASSWORT@localhost:3003/api/search?query=nextcloud" |
  python3 -c "import json,sys; print(json.load(sys.stdin)[0]['uid'])"
) | python3 -c "
import json, sys
data = json.load(sys.stdin)
text = json.dumps(data['dashboard']).replace('\${DS_PROMETHEUS}', 'PROMETHEUS')
payload = {'dashboard': json.loads(text), 'overwrite': True, 'folderId': 0}
print(json.dumps(payload))
" | curl -s -X POST http://admin:PASSWORT@localhost:3003/api/dashboards/db \
  -H "Content-Type: application/json" -d @-
```

---

## Schritt 8 — Prometheus und Alerts prüfen

```
http://<IP-der-VM>:9090/targets   ← alle Targets müssen UP sein
http://<IP-der-VM>:9090/alerts    ← Alert-Regeln anzeigen
```

Konfigurierte Alerts:

| Alert | Bedingung | Severity |
|-------|-----------|----------|
| `NextcloudDown` | Nextcloud nicht erreichbar seit 2 Min. | critical |
| `NextcloudDiskCritical` | Freier Speicher < 2 GB | critical |
| `NextcloudDiskWarning` | Freier Speicher < 2 TB | warning |
| `HighCPULoad` | CPU-Last > 85% für 10 Min. | warning |
| `TestAlert` | Immer aktiv (zum Testen) | info |

Alerts neu laden ohne Neustart:

```bash
curl -X POST http://localhost:9090/-/reload
```

---

## Fehlerbehebung

### nextcloud-exporter meldet `status code 400`

```bash
docker exec --user www-data nextcloud_and_grafana_monitoring-nextcloud-1 \
  php occ config:system:set trusted_domains 1 --value="nextcloud"
```

### nextcloud-exporter meldet `too many requests`

Brute-Force-Schutz ausgelöst — IP des Exporters entsperren:

```bash
# IP des Exporters herausfinden
docker inspect nextcloud_and_grafana_monitoring-nextcloud-exporter-1 | grep IPAddress

# Sperre aufheben
docker exec --user www-data nextcloud_and_grafana_monitoring-nextcloud-1 \
  php occ security:bruteforce:reset <IP-des-Exporters>
```

### Stack komplett neu aufsetzen

```bash
docker compose down -v   # Achtung: löscht alle Daten
docker compose up -d
```

### Nur Nextcloud-Daten zurücksetzen

```bash
docker compose down
docker volume rm nextcloud_and_grafana_monitoring_nextcloud_data
docker volume rm nextcloud_and_grafana_monitoring_nextcloud_db
docker compose up -d
```

---

## Nützliche Befehle

```bash
# Container-Status
docker compose ps

# Logs eines Dienstes
docker compose logs -f <dienstname>

# nextcloud_up prüfen (1 = OK, 0 = Fehler)
docker exec nextcloud_and_grafana_monitoring-nextcloud-exporter-1 \
  wget -qO- http://localhost:9205/metrics | grep nextcloud_up

# occ-Befehl in Nextcloud ausführen
docker exec --user www-data nextcloud_and_grafana_monitoring-nextcloud-1 \
  php occ <befehl>

# Stack stoppen (Daten bleiben erhalten)
docker compose down

# Stack starten
docker compose up -d
```

---

## Ports Übersicht

| Dienst | URL |
|--------|-----|
| Nextcloud | `http://<IP>:8088` |
| Grafana | `http://<IP>:3003` |
| Prometheus | `http://<IP>:9090` |
| nextcloud-exporter Metriken | `http://<IP>:9205/metrics` |
| node-exporter Metriken | `http://<IP>:9100/metrics` |
