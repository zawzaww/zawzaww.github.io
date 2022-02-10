---
layout: post
title: "Helm Series: Writing a Simple Kubernetes Helm Chart"
categories: [Kubernetes]
tags: [kubernetes, helm]
author: "Zaw Zaw"
---

This Helm Series articles include Part (1) and Part (2). In this article, Part (1), I will focus on how to
write a simple Helm Chart to deploy web application on Kubernetes. I will demostrate with simple containerized Python Flask
application to write Helm Chart and deploy on Kubernetes cluster.

# Introduction
Basically, **Helm** is a Kubernetes package manager CLI tool that manages and deploys Helm charts.
**Helm Charts** are collection and packages of pre-configured application ressources which can be deployed as
one unit. Helm charts help you define, install, upgrade and deploy applications easily on Kubernetes cluster.

Official Website: https://helm.sh

# Before You Begin
 - Kubernetes Cluster
 - Helm CLI Tool
 - Basic Understanding of Kubernetes Objects

# Installation Helm
To install Helm with script, run simply like this:
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```
```
chmod 700 get_helm.sh && ./get_helm.sh
```
 (OR)

You can install Helm via package manager tools:
 - https://helm.sh/docs/intro/install/#from-apt-debianubuntu
 - https://helm.sh/docs/intro/install/#from-snap

