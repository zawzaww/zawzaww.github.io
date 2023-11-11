---
layout: post
title: Automating K3s Kubernetes Cluster Upgrades
categories: [Kubernetes]
tags: [kubernetes, k3s, automate, upgrade]
---

In this blog post, I will share about how to upgrade K3s and RKE2 Kubernetes cluster upgrades.
For automated Kubernetes cluster upgrades for both K3s and RKE2, we will use Rancher's [system upgrade controller](https://github.com/rancher/system-upgrade-controller).

## Overview of System Upgrade Controller

System Upgrade Controller aims to provide a general-purpose, Kubernetes-native upgrade controller
for Nodes. It introduces a new Custom Resource Definition Plan for defining
all of your upgrade requirements and a controller that schedules upgrades based on the configured plans.

GitHub Repository: [https://github.com/rancher/system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)

## Setup K3s/RKE2 Cluster

Firstly, we will setup and bootstrap the K3s/RKE2 cluster with installation script.
It's pretty simple to setup Server and Agent.

Learn more about K3s and RKE2:
 - [https://docs.k3s.io](https://docs.k3s.io)
 - [https://docs.rke2.io](https://docs.rke2.io)

