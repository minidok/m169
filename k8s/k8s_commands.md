# Modul 169: Kubernetes Grundlagen

## Voraussetzungen

### minikube Installation

    kommandos für installation von minikube ausführen mit driver = docker
    Varianten sind mit Virtualbox oder vmware

### Anleitung Installation gemäss k8s
    https://minikube.sigs.k8s.io/docs/start/
    https://kubernetes.io/docs/tasks/tools/

### K8s minikube innerhalb einer Shell installieren
    https://webme.ie/how-to-run-minikube-on-a-virtualbox-vm/

### K8s minikube starten aus shell
    minikube start

_____________________________

## Kubernetes lokal verwenden
### Kubernetes testen
    kubectl cluster-info

#### Systemausgabe:
    Kubernetes control plane is running at https://127.0.0.1:34476
    CoreDNS is running at https://127.0.0.1:34476/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

## Kubernetes context verwenden
### Aktueller Context ausgeben
    kubectl config current-context

### Alle contexts ausgeben
    kubectl config get-contexts

### Context wechseln
    kubectl config use-context [contextName]

### Context löschen
    kubectl config delete-context [contextName]

_________________

## Kubernetes Deployment
### Imperatives Deployment
    kubectl create deployment mynginx1 --image=nginx

#### Deyployment kontrollieren
    kubectl get deploy

#### Systemausgabe    
    NAME             READY   UP-TO-DATE   AVAILABLE   AGE
    mynginx1         1/1     1            1           23s

### Deklaratives Deployment
    kubectl create -f deploy.yaml

### Deployment Löschen
    kubectl delete deployment mynginx1