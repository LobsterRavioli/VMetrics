# VMetrics: Monitoraggio distribuito su Azure

**VMetrics** è un'architettura a 3 nodi progettata per il monitoraggio di applicazioni e infrastruttura, utilizzando **Prometheus**, **Grafana**, e una VM con una webapp metrica (es. app Python o altro linguaggio) che espone metriche Prometheus.

---

## 🏗️ Architettura

```
+------------------+
|     Grafana      |   <-- VM1: Visualizzazione
+------------------+
         |
         v
+------------------+
|    Prometheus    |   <-- VM2: Raccolta metriche
+------------------+
         |
         v
+------------------+
|    App Metriche  |   <-- VM3: Espone /metrics
+------------------+
```

- **VM1 (Grafana)**: visualizza i dati raccolti da Prometheus.
- **VM2 (Prometheus)**: effettua scraping delle metriche da uno o più target (tra cui la VM3).
- **VM3 (App)**: espone metriche Prometheus su `/metrics` (es. Flask app, Node.js, Go, nginx con exporter, ecc.).

---

## 🔧 Prerequisiti

- Tre macchine virtuali (o container) su Azure (o altro cloud).
- Porte aperte tra VM (es. 9090 per Prometheus, 3000 per Grafana, 9100+ per exporters).
- DNS o IP statici per ciascuna VM.

---

## ⚙️ Setup Dettagliato

### 1. VM3 – App con metriche

Espone un endpoint `/metrics` compatibile con Prometheus. Può essere:
- Una Flask app con `prometheus_client` (come quella che hai già).
- Node Exporter / nginx exporter / custom exporter.

Verifica che su `http://<IP_VM3>:PORT/metrics` risponda correttamente.

### 2. VM2 – Prometheus

#### Installazione:

```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar -xzf prometheus-*.tar.gz
cd prometheus-*/
```

#### Configurazione (`prometheus.yml`):

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'vmetrics-app'
    static_configs:
      - targets: ['<IP_VM3>:<PORT>']
```

#### Avvio Prometheus:

```bash
./prometheus --config.file=prometheus.yml
```

Assicurati che Prometheus sia raggiungibile da Grafana su `http://<IP_VM2>:9090`.

---

### 3. VM1 – Grafana

#### Installazione (su Debian/Ubuntu):

```bash
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install grafana
```

#### Avvio:

```bash
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

#### Accesso:

- URL: `http://<IP_VM1>:3000`
- Default login: admin / admin

#### Aggiunta sorgente Prometheus:

1. Vai su **Settings → Data Sources**
2. Aggiungi nuova → Tipo: Prometheus
3. URL: `http://<IP_VM2>:9090`
4. Salva e testa

---

## 📊 Dashboard consigliata

Puoi:
- Importare una dashboard personalizzata (JSON).
- Oppure usare template Grafana:
  - ID Dashboard per Flask: `11074`
  - ID Dashboard per Node Exporter: `1860`

---

## 🔐 Sicurezza (opzionale ma consigliata)

- Usa Azure NSG per limitare accesso per IP.
- Attiva HTTPS tramite Nginx + Certbot (Grafana/Prometheus).
- Autenticazione su Prometheus (via reverse proxy).
- SSH con keypair solo da IP affidabili.

---

## 🧪 Test rapido

1. Visita `http://<IP_VM3>:PORT/metrics` → endpoint risponde?
2. Visita `http://<IP_VM2>:9090` → vedi job attivo?
3. Visita `http://<IP_VM1>:3000` → dashboard aggiornata?

---

## 📄 Licenza

MIT – Usalo, modificalo e condividilo liberamente.
