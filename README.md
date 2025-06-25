# 🛰️ VMetrics: Distributed Monitoring Architecture on Azure

**VMetrics** is a distributed monitoring solution built on a three-tier architecture, designed for scalable cloud environments. The system integrates **Prometheus** for metrics collection, **Grafana** for visualization, and a third component that exposes metrics via a standard `/metrics` endpoint.

This project was developed and tested on the **Azure** cloud platform, simulating a production-like multi-node environment.

---

## 🏗️ System Architecture

The architecture is composed of three virtual machines (VMs), each with a distinct role:

```
+------------------+
|     Grafana      |   <-- VM1: Visualization Layer
+------------------+
         |
         v
+------------------+
|    Prometheus    |   <-- VM2: Metrics Collection
+------------------+
         |
         v
+------------------+
|  Metrics App/Node|   <-- VM3: Exposes /metrics endpoint
+------------------+
```

- **VM1 (Grafana)**: Handles visualization of metrics collected by Prometheus.
- **VM2 (Prometheus)**: Periodically scrapes metrics from registered endpoints.
- **VM3 (Monitored App)**: Exposes metrics in Prometheus-compatible format.

---

## ⚙️ Technology Stack

- **Prometheus**: Time-series metrics collection engine.
- **Grafana**: Visualization and dashboard platform.
- **Azure VM**: Each component is hosted on an individual virtual machine.
- **Node Exporter / Custom App**: Used for metrics exposition.

---

## 🎯 Project Objectives

- **Distributed monitoring**: Clear separation between data collection, visualization, and metrics generation.
- **Scalability**: Each component can be independently scaled.
- **Security-aware**: Implements firewall rules, SSL certificates, authentication, and network segmentation.
- **Cloud-native observability**: Leverages widely adopted DevOps and SRE tools.

---

## 🔍 Key Features

- **Dynamic Prometheus configuration** to scrape from multiple targets.
- **Customizable Grafana dashboards**, supports existing templates.
- **Health checks and endpoint validation** via `/metrics` endpoint.
- **Security best practices**: NSG rules, SSH keypair access, HTTPS with reverse proxy.

---

## 📈 Use Cases

- **Microservice monitoring** in containerized or bare-metal environments.
- **Operational dashboards** for DevOps and SRE teams.
- **Scalability testing** on public cloud providers (Azure, AWS, etc.).
- **Production environment simulation** for academic or enterprise proof-of-concept projects.

---

## ✅ Outcomes

- Full multi-node setup successfully deployed on Azure.
- Live dashboards with real-time metrics ingestion.
- End-to-end pipeline validation from metric generation to visualization.
- Comprehensive documentation, replicable across cloud or on-premise environments.
