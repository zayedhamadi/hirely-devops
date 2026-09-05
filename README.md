# Hirely — Infrastructure & DevOps

Infrastructure as Code pour la plateforme Hirely (microservices Spring Boot + Angular).

## Architecture

- **vmonee** (192.168.100.14) — control-plane K3s, Ansible control node, Jenkins/SonarQube (à venir)
- **vmtwo** (192.168.100.10) — worker node K3s

## Structure du repo

- `ansible/` — provisioning automatisé des VM (Docker, K3s, Calico, Trivy, déploiement .env)
- `k8s/` — manifests Kubernetes applicatifs (namespaces, MySQL, microservices, observability)
- `ci/` — pipeline Jenkins (à venir)
- `docs/` — documentation d'avancement (RUNBOOK.md)

## Repos liés

- Backend : https://github.com/zayedhamadi/microservice_intern
- Frontend : https://github.com/zayedhamadi/microservice_intern_front

## Stack

Ansible · Docker · K3s · Calico · Trivy · Jenkins (à venir) · SonarQube (à venir) · Ansible Vault (secrets)
