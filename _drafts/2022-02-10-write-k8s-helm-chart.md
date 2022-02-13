---
layout: post
title: "Helm Series: Writing a Kubernetes Helm Chart"
categories: [Kubernetes]
tags: [kubernetes, helm, chart]
author: "Zaw Zaw"
image:
  src: /assets/images/featured-images/img_helm_kubernetes.png
  description: Helm Official Logo by Helm Community
---

In **Helm Series** articles, I will share about writing **Kubernetes Helm chart**, deep dive into YAML-based **Helm template
language** syntax, **Helm chart development** tips and tricks. In this article, I will focus on how to write a simple Helm Chart
to deploy web application on Kubernetes. I will demostrate with simple containerized Python Flask application
to write Helm Chart and deploy on Kubernetes cluster.

## Prerequisites
 - Kubernetes Cluster, You can use [minikube](https://minikube.sigs.k8s.io/docs) (or) any other tools for setup local Kubernetes cluser.
 - Helm CLI Tool, You need to install [Helm](https://helm.sh) Kubernetes package manager tool.
 - Kubernetes, You need to understand basic [Kubernetes objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects) 
 and [Workloads resources](https://kubernetes.io/docs/concepts/workloads).

## Introduction to Helm
Basically, [Helm](https://helm.sh) is a Kubernetes package manager that manages and deploys Helm charts.

[Helm Charts](https://artifacthub.io) are collection and packages of pre-configured application ressources which can be deployed as
one unit on Kubernetes. Helm charts help you **define**, **install**, **upgrade**, **rollback** and **deploy** applications easily on Kubernetes cluster.

Official Website: [https://helm.sh](https://helm.sh)

## Setup Local Kubernetes Cluster
In this article, I will use [minikube](https://minikube.sigs.k8s.io/docs) for setup local Kubernetes cluster on my Fedora Linux system.
You can use any other tools for setup Kubernetes cluster.

Download minikube CLI tool, it depends on your Operating System.

Please, see [https://minikube.sigs.k8s.io/docs/start](https://minikube.sigs.k8s.io/docs/start)

```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

Install minikube:

```sh
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Start local minikube Kubernetes cluster with containerd:

```sh
minikube start --container-runtime=containerd
```

```sh
😄  minikube v1.24.0 on Fedora 35
✨  Using the docker driver based on existing profile
❗  docker is currently using the btrfs storage driver, consider switching to overlay2 for better performance
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
🏃  Updating the running docker "minikube" container ...
📦  Preparing Kubernetes v1.22.3 on containerd 1.4.9 ...
🔎  Verifying Kubernetes components...
    ▪ Using image kubernetesui/dashboard:v2.3.1
    ▪ Using image k8s.gcr.io/metrics-server/metrics-server:v0.4.2
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
    ▪ Using image kubernetesui/metrics-scraper:v1.0.7
    ▪ Using image metallb/speaker:v0.9.6
    ▪ Using image metallb/controller:v0.9.6
🌟  Enabled addons: storage-provisioner, default-storageclass, metallb, metrics-server, dashboard
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

Check minikube status:

```sh
[zawzaw@redhat-linux:~]$ minikube status 
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

## Installation Helm
To install Helm with script, run simply like this:

```sh
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```
```sh
chmod +x get_helm.sh && ./get_helm.sh
```

 (OR)

You can install Helm via package manager tools:
 - [https://helm.sh/docs/intro/install/#from-apt-debianubuntu](https://download.lineageos.org)
 - [https://helm.sh/docs/intro/install/#from-snap](https://helm.sh/docs/intro/install/#from-snap)

## Containerize application
### Build and Push Docker container image
Before we write Kubernetes Helm chart, we need to containerize for your web application.

In this article, I will use open sourced pod-info-app: [https://gitlab.com/gitops-argocd-demo/webapp](https://gitlab.com/gitops-argocd-demo/webapp)
simple Python Flask application to demonstrate writing Helm chart and deploy it on Kubernetes cluster.

Download `pod-info-app` Git repository:

```sh
git clone https://gitlab.com/gitops-argocd-demo/webapp.git pod-info-app
```

This application's author has already written `Dockerfile` but we can update and customize `Dockerfile`
to update Python version and run gunicorn server with specific user.

Update port number in `PROJECT_ROOT/gunicorn-cfg.py` file like this:

```sh
# -*- encoding: utf-8 -*-
bind = '0.0.0.0:8080'
workers = 1
accesslog = '-'
loglevel = 'debug'
capture_output = True
```

Update and customize `PROJECT_ROOT/Dockefile` file like this:

```sh
FROM python:3.8-slim

ENV FLASK_APP run.py
ENV APP_WORKDIR=/app
ENV APP_USER=zawzaw
ENV APP_PORT=8080

RUN python -m pip install --upgrade pip

RUN useradd --create-home ${APP_USER}

WORKDIR ${APP_WORKDIR}

COPY . .

RUN chown ${APP_USER}:${APP_USER} -R ${APP_WORKDIR}

RUN pip install -r requirements.txt

USER ${APP_USER}

EXPOSE ${APP_PORT}

ENTRYPOINT ["gunicorn", "--config", "gunicorn-cfg.py", "run:app"]
```
Dockerfile is very simple. Install required Python packages with pip and serve Python Flask app with gunicorn server.

Build Docker container image locally:

```sh
docker build -t pod-info-app .
```

Run pod-info-app locally with Docker run:

```sh
docker run -p 8080:8080 -it --rm pod-info-app:latest
```

```sh
...
[2022-02-13 08:41:04 +0000] [1] [INFO] Starting gunicorn 20.0.4
[2022-02-13 08:41:04 +0000] [1] [DEBUG] Arbiter booted
[2022-02-13 08:41:04 +0000] [1] [INFO] Listening at: http://0.0.0.0:8080 (1)
[2022-02-13 08:41:04 +0000] [1] [INFO] Using worker: sync
[2022-02-13 08:41:04 +0000] [9] [INFO] Booting worker with pid: 9
[2022-02-13 08:41:04 +0000] [1] [DEBUG] 1 workers
```

Test application locally:

 - [http://0.0.0.0:8080](http://0.0.0.0:8080)

![Screenshot](/assets/images/screenshots/img_screenshot_pod-info-app.png)

Final step,
Build and Push Docker container image into your Docker Registry.

For example: My Docker Hub username is `zawzaww`. It depends on your Docker Hub user name.

```sh
docker build -t zawzaww/pod-info-app .
```

```sh
docker push zawzaww/pod-info-app:latest
```

```sh
The push refers to repository [docker.io/zawzaww/pod-info-app]
687ccfae7d0e: Pushed 
779e7681e9a7: Pushed 
f57ce0722888: Pushed 
34decbbd20d2: Pushed 
314e501bfdc5: Pushed 
9c81064245d9: Pushed 
87ea2744abf2: Mounted from library/python 
51f094ff7b94: Mounted from library/python 
1a40cb2669f8: Mounted from library/python 
32034715e5d4: Mounted from library/python 
7d0ebbe3f5d2: Mounted from library/python 
latest: digest: sha256:2f584b970b2bb5d9db9ece9d36cf8426ad7b9c4fc0dc1e059c6d1c02805c2395 size: 2629
```

