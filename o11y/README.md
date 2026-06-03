# README for Observability Stack

This directory contains Kubernetes manifests for deploying an observability stack (Prometheus, Grafana, Loki, Promtail) for the skills_app and infrastructure.

## Components
- **Prometheus**: Metrics collection and monitoring
- **Grafana**: Metrics and logs visualization
- **Loki**: Log aggregation
- **Promtail**: Log shipping from nodes to Loki

## Setup
1. Create the monitoring namespace (if not already present):
   ```sh
   kubectl apply -f prometheus.yaml
   kubectl apply -f grafana.yaml
   kubectl apply -f loki.yaml
   kubectl apply -f promtail.yaml
   ```
2. Access Prometheus: `kubectl get svc -n monitoring prometheus` (default port 9090)
3. Access Grafana: `kubectl get svc -n monitoring grafana` (default port 3000, password: admin)
4. Add Prometheus as a data source in Grafana (URL: http://prometheus:9090)
5. Add Loki as a data source in Grafana (URL: http://loki:3100)

## Notes
- Prometheus is configured to scrape the skills-tracker-service on port 5000.
- You may need to adjust service names or ports to match your cluster setup.
- For production, consider persistent storage and secure credentials.
