---
layout: post
title: "Automating K3s Kubernetes Cluster Upgrades"
categories: [Kubernetes]
tags: [kubernetes, k3s, automate, upgrade]
image:
  src: /assets/images/featured-images/img_k3s_kubernetes.png
  description: "Combined official K3s and Kubernetes logo by Author"
---

In this blog post, I will share how to setup and bootstrap K3s cluster and how to configure
automated upgrading for K3s Kubernetes cluster.

This article covers both how to setup multi-node K3s Kubernetes cluster and how to upgrade K3s
automatically using system upgrade controller.

Normally, we manually download K3s binary file from GitHub release page
and, install and upgrade it in K3s Server and Agent Kubernetes nodes. Instead, we can manage and configure
automated cluster upgrading for K3s using Rancher's [system upgrade controller](https://github.com/rancher/system-upgrade-controller)
and **Plan** CRD, Custom Resource Definition.

## Objectives

 - Setup K3s Kubernetes cluster
 - Explore System Upgrade Controller and how it works
 - Setup and install System Upgrade Controller on Kubernetes
 - Configure `Plan` CRD for automate K3s cluster upgrade
 - Monitor K3s System Upgrade `Plan` configuration and jobs status

## Prerequisites

 - Linux VMs (or) Physical machines
 - Basic understanding of Kubernetes
 - Familiar with `kubectl` command line tool

## Setup K3s Kubernetes Cluster

Firstly, we need to setup and bootstrap the K3s cluster with installation script.
It's simple to setup Server and Agent. In this article, I will use AWS EC2 instances to setup K3s cluster.

We have two AWS EC2 instances:

 - *k3s-dev-master (K3s Server)*
 - *k3s-dev-worker (K3s Agent)*

### K3s Server (ControlPlane/Master Node)

On `k3s-dev-master` instance,

run the following installation script to bootstrap K3s Server also known as Kubernetes ControlPlane/Master Node.

```sh
$ curl -sfL https://get.k3s.io | sh -s - server \
    --write-kubeconfig-mode 644 \
    --node-taint "CriticalAddonsOnly=true:NoExecute"
```

If you want to make your K3s server as ControlPlane/Master only,
make sure you add `CriticalAddonsOnly=true:NoExecute` Node taint when bootstraps K3s server.

OR

Alternatively, you can also add Node taints with `kubectl` command line tool.

```sh
$ kubectl taint node k3s-dev-master CriticalAddonsOnly=true:NoExecute
$ kubectl taint node k3s-dev-master node-role.kubernetes.io/master=true:NoSchedule
$ kubectl taint node k3s-dev-master node-role.kubernetes.io/control-plane=true:NoSchedule
```

### K3s Agent (Worker Node)

On `k3s-dev-worker` instance,

run the following installation script to bootstrap K3s Agent also known as Kubernetes Worker Node to join the ControlPlane/Master Node.

```sh
$ curl -sfL https://get.k3s.io | sh -s - agent \
    --server https://<172.16.x.x>:6443 \
    --token K10d47c3a1abbbc24647fc37f9531ee6d9145d485408dc19f0bf4964c82beeaf175::server:91d5e063491d81783cab2bf1e728e4f1
```

`--server`: Set your K3s Server's URL that includes IP address and port number.

`--token`: Set your K3s Server's token. You can find that token in your K3s Server's file path `/var/lib/rancher/k3s/server/node-token` or
`/var/lib/rancher/k3s/server/token`.

To get K3s Server's token,

```sh
$ cat /var/lib/rancher/k3s/server/node-token

K10d47c3a1abbbc24647fc37f9531ee6d9145d485408dc19f0bf4964c82beeaf175::server:91d5e063491d81783cab2bf1e728e4f1
```

Add label to mark Kubernetes Worker Node as Worker role.

```sh
kubectl label node k3s-dev-worker node-role.kubernetes.io/worker=true
```

Official K3s documentation: [https://docs.k3s.io](https://docs.k3s.io)

## System Upgrade Controller

System Upgrade Controller aims to provide a general-purpose, Kubernetes-native upgrade controller
for Nodes. It introduces a new Custom Resource Definition Plan for defining
all of your upgrade requirements and a controller that schedules upgrades based on the configured plans.

GitHub Repository: [https://github.com/rancher/system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)

![image](https://raw.githubusercontent.com/rancher/system-upgrade-controller/master/doc/architecture.png)

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

