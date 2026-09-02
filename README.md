# Hirely — Infrastructure & DevOps

Infrastructure as Code pour la plateforme Hirely (microservices Spring Boot + Angular).

## Architecture

- **vmone**  — control-plane Kubernetes, Ansible control node, Jenkins/SonarQube (à venir)
- **vmtwo**  — worker node Kubernetes

## Structure du repo

- `ansible/` — provisioning automatisé des VM (Docker, Kubernetes, Trivy)
- `k8s/` — manifests Kubernetes (namespaces, déploiements)
- `docs/` — documentation d'avancement (RUNBOOK.md)

## Repos liés

- Backend : https://github.com/zayedhamadi/microservice_intern
- Frontend : https://github.com/zayedhamadi/microservice_intern_front

## Stack

Ansible · Docker · Kubernetes (kubeadm) · Calico · Trivy · Jenkins · SonarQube (en cours)
