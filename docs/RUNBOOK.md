# Runbook — Journal de progression

## 1. Provisioning VM (Ansible)
- 2 VM Ubuntu 22.04 : vmone (control-plane) / vmtwo (worker)
- SSH clé publique/privée configuré vmone → vmtwo
- Rôles Ansible : docker, kubernetes (kubeadm/kubelet/kubectl), trivy
- Validé : `ansible all -m ping` OK sur les deux nœuds

## 2. Cluster Kubernetes
- Fix appliqué : reconfiguration containerd (SystemdCgroup=true) sur les deux VM
- `kubeadm init` sur vmone (pod-network-cidr 10.244.0.0/16)
- CNI Calico installé (fix CIDR appliqué : 192.168.0.0/16 → 10.244.0.0/16)
- `kubeadm join` réussi sur vmtwo
- Statut : les deux nœuds `Ready`

## 3. Sanity check cluster (en cours)
- Namespace `hirely` créé
- Test déploiement nginx (2 replicas) : vérification répartition scheduler + ClusterIP/DNS interne

## Prochaines étapes
- Jenkins + SonarQube (Docker, sur vmone)
- Premier vrai service K8s (MySQL avec PVC + Secret)
- Jenkinsfile complet (checkout → build → sonar → docker → trivy → deploy)
- Migration Azure (AKS + Terraform) une fois le pipeline local validé
