---
layout: post
title: Dynamic Storage Provisioning on Kubernetes
categories: [Kubernetes]
tags: [kubernetes, storage, provisioning]
---

In this article, I will share how dynamic storage provisioning on Kubernetes works and how to setup and configure it. We typically create *Persistent Volumes* manually using the [local volume](https://kubernetes.io/docs/concepts/storage/volumes/#local) on Kubernetes. But we can create and manage storage volumes dynamically using any storage provisioner. Basically, dynamic storage provisioning enables to create storage volumes on-demand (or) dynamically.

I will mainly focus on managing persistent storage on the Kubernetes On-premises cluster, also known as self-managed Kubernetes, in this article and also demonstrate how to configure the **local-path** and **NFS** storage provisioners and how to deploy *Persistent Volumes* dynamically using them on the Kubernetes cluster.

## Before We Begin

- [Kubernetes](https://kubernetes.io) Cluster

 - [kubectl](https://kubernetes.io/docs/reference/kubectl), a client CLI tool to communicate with the cluster

 - [Helm](https://helm.sh) package manager tool

 - Kubernetes Basics

   > Make sure you understand how to use basic Kubernetes objects and resources, and deploy them on the Kubernetes cluster. If you are not familiar with Kubernetes, you can learn [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics) tutorial that provides a hands-on practical guide on the basics of Kubernetes, container orchestration system.

## Introduction

### How Kubernetes manages Persistent Storage (Volumes)

First of all, we need to understand basic concepts on Kubernetes persistent storage and how Kubernetes creates and manages persistent volumes. So, we will explore the basics before we explore dynamic storage provisioning on Kubernetes.

Basically, Kubernetes has the following two API resources to manage persistent storage.

 - *PersistentVolume (PV)*
 - *PersistentVolumeClaim (PVC)*



Dynamic storage provisioning enables and allows to create Persistent Volumes on-demand or dynamically on the Kubernetes cluster based on the *StorageClass* API object. Basically, the *StorageClass* defines which storage provisioner should be used when creating persistent volumes on Kubernetes.

For example, Rancher's local-path provisioner

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
parameters: {}
provisioner: rancher.io/local-path
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```


## Setup NFS Server
Install NFS server package. It depends on your Linux distribution. We will install it on Ubuntu Linux.

```sh
sudo apt update
sudo apt install -y nfs-server
```

Configure NFS server `/etc/exports` configuration to access control list for filesystems which may be exported to NFS clients.

Note that IP addr or hostname is your NFS clients IP addresses.

Format,

```sh
/mount/path          ip_addr_or_hostname(rw,sync,no_subtree_check,no_root_squash)
```

For example,

```sh
# /etc/exports: the access control list for filesystems which may be exported
#               to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/data/nfs          172.16.x.1(rw,sync,no_subtree_check,no_root_squash)
/data/nfs          172.16.x.2(rw,sync,no_subtree_check,no_root_squash)
/data/nfs          172.16.x.3(rw,sync,no_subtree_check,no_root_squash)
```

## Install NFS Client on Worker Nodes

Before setup NFS storage provisioner, make sure you install NFS client tool.

On Debian-based Linux systems,

```sh
sudo apt install -y nfs-common
```

On RHEL-based Linux systems, for example: Fedora Linux,

```sh
sudo dnf install -y nfs-utils
```

## Install NFS Dynamic Provisioner

Add Helm repository and install NFS storage dynamic provisioner.

[https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)

```sh
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
```

```sh
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --create-namespace \
    --namespace nfs-provisioner \
    --set nfs.server=ip_addr_or_hostname \
    --set nfs.path=/exported/path
```

Check StorageClass with kubectl.

```
[zawzaw@fedora-linux:~]$ kubectl get storageclass
NAME                        PROVISIONER                                                     RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
nfs-client                  cluster.local/nfs-provisioner-nfs-subdir-external-provisioner   Delete          Immediate              true                   3d10h
```

## Deploy an App with NFS Storage

Create PVC and Pod resources.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: "nfs-client"
  resources:
    requests:
      storage: 8Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox-nfs
  annotations:
    nfs.io/storage-path: "/data/nfs"
spec:
  containers:
    - name: busybox
      image: busybox:latest
      imagePullPolicy: IfNotPresent
      command:
        - sh
        - -c
        - 'date >> /data/nfs/date.txt; hostname >> /data/nfs/hostname.txt; sync; sleep 5; sync; tail -f /dev/null;'
      volumeMounts:
        - name: nfs-vol
          mountPath: /data/nfs
  volumes:
    - name: nfs-vol
      persistentVolumeClaim:
        claimName: pvc-nfs
```

Check persistence volume claim and persistence volume.

```sh
[zawzaw@fedora-linux:~]$ kubectl get pvc --namespace debug
NAME                                                         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-nfs                                                      Bound    pvc-2b3a13c2-5647-4b03-a2dc-2e14e8379076   8Gi        RWX            nfs-client     3d21h
```

```sh
[zawzaw@fedora-linux:~]$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                              STORAGECLASS      REASON   AGE
pvc-2b3a13c2-5647-4b03-a2dc-2e14e8379076   8Gi        RWX            Delete           Bound    debug/pvc-nfs                                                      nfs-client                 3d21h
```

Check mounted and created files.
```sh
kubectl exec -it busybox-nfs --namespace debug -- sh
```

```sh
/ # cat /data/nfs/date.txt
Thu May  5 05:19:17 UTC 2022

/ # cat /data/nfs/hostname.txt
busybox-nfs
```

