# Nextcloud + Grafana Monitoring — Installationsanleitung

> **Modul:** M169 — Services mit Containern bereitstellen  
> **Repository:** [github.com/minidok/m169](https://github.com/minidok/m169)

---

## Systemübersicht

<svg width="100%" viewBox="0 0 680 520" role="img" xmlns="http://www.w3.org/2000/svg">
  <title>Nextcloud Monitoring mit Grafana — Architektur</title>
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
      <path d="M2 1L8 5L2 9" fill="none" stroke="context-stroke" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
    </marker>
  </defs>

  <!-- Nextcloud -->
  <rect x="40" y="60" width="160" height="56" rx="8" fill="#E6F1FB" stroke="#378ADD" stroke-width="0.5"/>
  <text x="120" y="83" text-anchor="middle" font-size="14" font-weight="500" fill="#0C447C" font-family="sans-serif">Nextcloud</text>
  <text x="120" y="101" text-anchor="middle" font-size="12" fill="#185FA5" font-family="sans-serif">App + /metrics Endpunkt</text>
  <text x="120" y="145" text-anchor="middle" font-size="11" fill="#888" font-family="sans-serif">:8088</text>

  <!-- Nextcloud Exporter -->
  <rect x="40" y="160" width="160" height="56" rx="8" fill="#E1F5EE" stroke="#1D9E75" stroke-width="0.5"/>
  <text x="120" y="183" text-anchor="middle" font-size="14" font-weight="500" fill="#085041" font-family="sans-serif">nextcloud-exporter</text>
  <text x="120" y="201" text-anchor="middle" font-size="12" fill="#0F6E56" font-family="sans-serif">Prometheus-Adapter</text>
  <text x="120" y="228" text-anchor="middle" font-size="11" fill="#888" font-family="sans-serif">:9205</text>

  <!-- Arrow Nextcloud to Exporter -->
  <line x1="120" y1="116" x2="120" y2="158" stroke="#378ADD" stroke-width="1" marker-end="url(#arrow)"/>

  <!-- Prometheus -->
  <rect x="260" y="110" width="160" height="56" rx="8" fill="#FAEEDA" stroke="#BA7517" stroke-width="0.5"/>
  <text x="340" y="133" text-anchor="middle" font-size="14" font-weight="500" fill="#633806" font-family="sans-serif">Prometheus</text>
  <text x="340" y="151" text-anchor="middle" font-size="12" fill="#854F0B" font-family="sans-serif">Metriken speichern</text>
  <text x="340" y="97" text-anchor="middle" font-size="11" fill="#888" font-family="sans-serif">:9090</text>

  <!-- Arrow Exporter to Prometheus -->
  <line x1="200" y1="188" x2="258" y2="148" stroke="#1D9E75" stroke-width="1" marker-end="url(#arrow)"/>
  <text x="224" y="162" text-anchor="middle" font-size="11" fill="#555" font-family="sans-serif">scrape</text>

  <!-- Grafana -->
  <rect x="260" y="270" width="160" height="56" rx="8" fill="#FAECE7" stroke="#993C1D" stroke-width="0.5"/>
  <text x="340" y="293" text-anchor="middle" font-size="14" font-weight="500" fill="#4A1B0C" font-family="sans-serif">Grafana</text>
  <text x="340" y="311" text-anchor="middle" font-size="12" fill="#993C1D" font-family="sans-serif">Dashboards &amp; Alerts</text>
  <text x="340" y="258" text-anchor="middle" font-size="11" fill="#888" font-family="sans-serif">:3003</text>

  <!-- Arrow Prometheus to Grafana -->
  <line x1="340" y1="166" x2="340" y2="268" stroke="#BA7517" stroke-width="1.5" marker-end="url(#arrow)"/>
  <text x="358" y="222" text-anchor="start" font-size="11" fill="#555" font-family="sans-serif">PromQL</text>

  <!-- Alertmanager -->
  <rect x="480" y="110" width="160" height="56" rx="8" fill="#FCEBEB" stroke="#A32D2D" stroke-width="0.5"/>
  <text x="560" y="133" text-anchor="middle" font-size="14" font-weight="500" fill="#501313" font-family="sans-serif">Alertmanager</text>
  <text x="560" y="151" text-anchor="middle" font-size="12" fill="#791F1F" font-family="sans-serif">E-Mail, Slack, PD</text>
  <text x="560" y="97" text-anchor="middle" font-size="11" fill="#888" font-family="sans-serif">:9093</text>

  <!-- Arrow Prometheus to Alertmanager -->
  <line x1="420" y1="138" x2="478" y2="138" stroke="#BA7517" stroke-width="1" marker-end="url(#arrow)"/>

  <!-- Node Exporter -->
  <rect x="40" y="290" width="160" height="56" rx="8" fill="#F1EFE8" stroke="#5F5E5A" stroke-width="0.5"/>
  <text x="120" y="313" text-anchor="middle" font-size="14" font-weight="500" fill="#2C2C2A" font-family="sans-serif">node_exporter</text>
  <text x="120" y="331" text-anchor="middle" font-size="12" fill="#5F5E5A" font-family="sans-serif">CPU, RAM, Disk</text>
  <text x="120" y="358" text-anchor="middle" font-size="11" fill="#888" font-family="sans-serif">:9100</text>

  <!-- DB Exporter -->
  <rect x="40" y="390" width="160" height="56" rx="8" fill="#EEEDFE" stroke="#534AB7" stroke-width="0.5"/>
  <text x="120" y="413" text-anchor="middle" font-size="14" font-weight="500" fill="#26215C" font-family="sans-serif">DB Exporter</text>
  <text x="120" y="431" text-anchor="middle" font-size="12" fill="#3C3489" font-family="sans-serif">MySQL / PostgreSQL</text>

  <!-- MariaDB -->
  <rect x="480" y="270" width="160" height="56" rx="8" fill="#EAF3DE" stroke="#3B6D11" stroke-width="0.5"/>
  <text x="560" y="293" text-anchor="middle" font-size="14" font-weight="500" fill="#173404" font-family="sans-serif">MariaDB</text>
  <text x="560" y="311" text-anchor="middle" font-size="12" fill="#3B6D11" font-family="sans-serif">Nextcloud Datenbank</text>

  <!-- Redis -->
  <rect x="480" y="370" width="160" height="56" rx="8" fill="#FCEBEB" stroke="#A32D2D" stroke-width="0.5"/>
  <text x="560" y="393" text-anchor="middle" font-size="14" font-weight="500" fill="#501313" font-family="sans-serif">Redis</text>
  <text x="560" y="411" text-anchor="middle" font-size="12" fill="#791F1F" font-family="sans-serif">Session-Cache / Locking</text>

  <!-- Arrow Node Exporter to Prometheus (dashed) -->
  <path d="M200 318 L340 318 L340 166" fill="none" stroke="#888" stroke-width="1" stroke-dasharray="4 3" marker-end="url(#arrow)"/>

  <!-- Arrow DB Exporter to Prometheus (dashed) -->
  <path d="M200 418 L350 418 L350 166" fill="none" stroke="#888" stroke-width="1" stroke-dasharray="4 3" marker-end="url(#arrow)"/>

  <!-- Arrow Nextcloud to MariaDB (dashed) -->
  <line x1="200" y1="82" x2="478" y2="290" stroke="#3B6D11" stroke-width="0.8" stroke-dasharray="4 3" marker-end="url(#arrow)"/>

  <!-- Arrow Nextcloud to Redis (dashed) -->
  <line x1="200" y1="100" x2="478" y2="388" stroke="#A32D2D" stroke-width="0.8" stroke-dasharray="4 3" marker-end="url(#arrow)"/>

  <!-- Legend -->
  <line x1="260" y1="468" x2="295" y2="468" stroke="#888" stroke-width="1" stroke-dasharray="4 3"/>
  <text x="302" y="472" font-size="11" fill="#666" font-family="sans-serif">optional / empfohlen</text>
  <line x1="440" y1="468" x2="475" y2="468" stroke="#BA7517" stroke-width="1.5"/>
  <text x="482" y="472" font-size="11" fill="#666" font-family="sans-serif">Hauptpfad</text>
  <text x="340" y="505" text-anchor="middle" font-size="11" fill="#aaa" font-family="sans-serif">Nextcloud + Grafana Monitoring Stack — M169</text>
</svg>

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

- Windows 11 mit installiertem Hypervisor (Hyper-V oder VirtualBox)
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

# Monitoring-Token (optional)
NC_METRICS_TOKEN=secret-monitoring-token
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
