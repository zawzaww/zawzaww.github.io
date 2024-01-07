---
layout: post
title: "Automating K3s Kubernetes Cluster Upgrades"
categories: [Kubernetes]
tags: [kubernetes, k3s, automate, upgrade]
image:
  src: /assets/images/featured-images/img_k3s_kubernetes.png
  description: "Combined official K3s and Kubernetes logo by Author"
---

In this blog post, I will share how to setup and bootstrap K3s cluster, and how to configure
automated upgrading for K3s Kubernetes cluster.

Normally, we manually download K3s binary file from GitHub release page
and, install and upgrade it in K3s Server and Agent Kubernetes node. Instead, we can manage and configure
automated cluster upgrading for K3s using Rancher's [system upgrade controller](https://github.com/rancher/system-upgrade-controller)
and **Plan** CRD, custom resource definition.

## Objectives

 - Setup K3s Kubernetes cluster
 - Explore System Upgrade Controller and how it works
 - Setup and install System Upgrade Controller on Kubernetes
 - Configure `Plan` CRD for automate K3s cluster upgrade
 - Monitor K3s System Upgrade `Plan` configuration and jobs status

## Introduction to System Upgrade Controller

System Upgrade Controller aims to provide a general-purpose, Kubernetes-native upgrade controller
for Nodes. It introduces a new Custom Resource Definition Plan for defining
all of your upgrade requirements and a controller that schedules upgrades based on the configured plans.

GitHub Repository: [https://github.com/rancher/system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)

## Setup K3s Kubernetes Cluster

Firstly, we need to setup and bootstrap the K3s cluster with installation script.
It's pretty simple to setup Server and Agent.

Setup K3s Server (also known as) Kubernetes ControlPlane/Master Node.

```sh
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_CHANNEL=stable \
  INSTALL_K3S_EXEC='server --disable traefik servicelb --write-kubeconfig-mode 644'  sh -
```

Setup K3s Agent (also known as) Kubernetes Worker Node to join ControlPlane/Master Node.

```sh
curl -sfL https://get.k3s.io | \
  K3S_URL=https://172.x.x.x:6443 \
  K3S_TOKEN=K10d22154c1ce98c27127147dfa6ec466b5ad2aad7e24334f3cd6e277d5fca8c750::server:64a5b2d9165d6af58aed25e306e6896a sh -
```

**NOTE**: Please, replace your K3s Server IP address and token in `K3S_URL` and `K3S_TOKEN` enviornment variable.

Learn more about K3s
 - [https://docs.k3s.io](https://docs.k3s.io)
 - [https://docs.k3s.io/quick-start](https://docs.k3s.io/quick-start)

## Install System Upgrade Controller

Install the `system-upgrade-controller` with kubectl.

```sh
kubectl apply -f https://github.com/rancher/system-upgrade-controller/releases/latest/download/system-upgrade-controller.yaml
```

## Configure K3s System Upgrade Plans

Create a Kubernetes resource file using `Plan` CRD named `plan-k3s-upgrade.yaml` like the following example configuration. YAML filename can be as you like.

```yaml
apiVersion: upgrade.cattle.io/v1
kind: Plan
metadata:
  name: plan-k3s-server-upgrade
  namespace: system-upgrade
spec:
  concurrency: 1
  cordon: true
  tolerations:
    - effect: NoSchedule
      operator: Exists
    - key: CriticalAddonsOnly
      operator: Exists
    - effect: NoExecute
      operator: Exists
    - effect: NoSchedule
      key: node-role.kubernetes.io/controlplane
      operator: Exists
    - effect: NoExecute
      key: node-role.kubernetes.io/etcd
      operator: Exists
  nodeSelector:
    matchExpressions:
      - key: node-role.kubernetes.io/master
        operator: In
        values:
          - "true"
  serviceAccountName: system-upgrade
  upgrade:
    image: rancher/k3s-upgrade
  channel: https://update.k3s.io/v1-release/channels/stable
  version: v1.25.6+k3s1
---
apiVersion: upgrade.cattle.io/v1
kind: Plan
metadata:
  name: plan-k3s-agent-upgrade
  namespace: system-upgrade
spec:
  concurrency: 1
  cordon: true
  nodeSelector:
    matchExpressions:
      - key: node-role.kubernetes.io/worker
        operator: In
        values:
          - "true"
  serviceAccountName: system-upgrade
  upgrade:
    image: rancher/k3s-upgrade
  channel: https://update.k3s.io/v1-release/channels/stable
  version: v1.25.6+k3s1
```

Deploy the `Plan` resource with kubectl. Make sure you deploy `system-upgrade-controller` and `Plan` in same `system-upgrade` namesapce.

```sh
kubect apply -f k3s-system-upgrade.yaml
```

Then, the controller will pick them up and begin to upgrade K3s cluster to latest stable Kubernetes version from K3s stable channel.

Check and monitor the progress of an upgrade by viewing `Plan` and `Jobs` with kubectl.

```sh
kubectl get plans --namespace system-upgrade -o yaml
kubectl get jobs --namespace system-upgrade -o yaml
```

