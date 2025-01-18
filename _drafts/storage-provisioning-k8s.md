---
layout: post
title: A Hands-on Practical Guide to K8s Persistent Storage
categories: [Kubernetes]
tags: [kubernetes, storage, provisioning]
---

In Kubernetes, we typically need to create and use *Persistent Volumes* for stateful apps such as database engines, cache store servers and so on. I will share how storage provisioning on Kubernetes works and how to configure *Persistent Volumes* for statefulset apps.

I will mainly focus on managing persistent storage on the Kubernetes On-premises cluster, also known as self-managed Kubernetes in this article, and also demonstrate how to configure the **local-path** and **NFS** storage provisioners and how to deploy *Persistent Volumes* dynamically using them on the Kubernetes cluster.

## Before We Begin

 - [Kubernetes](https://kubernetes.io) Cluster

 - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux), a client CLI tool to communicate with the cluster

 - [Helm](https://helm.sh) package manager tool

 - Kubernetes Basics

   > Make sure you are familiar with basic Kubernetes objects and resources. If you are a Kubernetes newcomer, you can learn [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics) tutorial that provides a hands-on practical guide on the basics of Kubernetes, container orchestration system.

## Background
### Introduction to Kubernetes Persistent Volumes

Firstly, we need to understand basic concepts on Kubernetes persistent volume and how Kubernetes creates and manages persistent volumes. So, we will learn the basics before we setup and configure storage provisioning on the Kubernetes platform.

Basically, Kubernetes has the following main two API resources to manage persistent storage.

 - *PersistentVolume (PV)*
 - *PersistentVolumeClaim (PVC)*

**PersistentVolume (PV)** represents a piece of storage in the Kubernetes cluster. PVs can be provisioned manually by a cluster administrator or dynamically provisioned using PersistentVolumeClaim (PVC) with a storage class, and PVs can be filesystems (physical disks) and cloud storage services such as Amazon EBS and Azure disk.

**PersistentVolumeClaim (PVC)** represents a request for storage, such as the storage size, access mode, and storage class. Persistent Volumes can be provisioned dynamically using PVC and storage class with any storage provisioner.

It's a simple introduction. I will explain more details on persistent volumes with examples and demonstrate how to use them in the next sections.

## Storage Provisioning on Kubernetes

Basically, Kubernetes has two ways of provisioning persistent volumes.

 - *Static*
 - *Dynamic*

### Static Storage Provisioning

Static storage provisioning creates persistent volumes manually for apps that require data persistence. In this approach, a cluster administrator needs to create PVs manually on the Kubernetes cluster.

For example,
create PV and PVC manually for data persistence of the MySQL database server.

PersistentVolume:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-mysql-example
spec:
  storageClassName: manual # Set storageclass name to "manual" or empty.
  capacity:
    storage: 8Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/data/mysql"
```

PersistentVolumeClaim:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-mysql-example
  namespace: sandbox
spec:
  storageClassName: manual # Set storageclass name to "manual" or empty.
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
```

MySQL Pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql-example
  namespace: sandbox
spec:
  containers:
    - name: mysql-example
      image: mysql:latest
      ports:
        - name: mysql-tcp
          protocol: TCP
          containerPort: 3306
      volumeMounts:
        - mountPath: "/data/mysql"
          name: vol-mysql-data
  volumes:
    - name: vol-mysql-data
      persistentVolumeClaim:
        claimName: pvc-mysql-example
...
```

You can use the default `manual` class name that does not require any storage provisioner. It can be used to create PersistentVolume, PVs manually. See tutorial, [https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)

Kubernetes supports `hostPath` persistent volume for development and local testing.
In this approach, you need to create PV and PVC manually, and create volume mounts using PVC `pvc-mysql-example` in the MySQL Pod. And then MySQL data will be stored in the `/data/mysql` path on the local Kubernetes node.

### Dynamic Storage Provisioning

Dynamic storage provisioning enables and allows to create persistent volumes on-demand or dynamically on the Kubernetes cluster based on the *StorageClass* API object. Basically, *StorageClass* defines which storage provisioner should be used when creating persistent volumes on Kubernetes.

> But, please note that you need to deploy the provisioner on the Kubernetes cluster and we will explore how to setup in the next section.

In this approach, you can use any StorageClass when you configure PersistentVolumeClaim (PVC), and then it will automatically create PersistentVolume (PV) on the Kubernetes cluster.

For example,

PersistentVolumeClaim (PVC) with local-path storageclass:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-mysql-example
  namespace: sandbox
spec:
  storageClassName: local-path
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
```

MySQL Pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql-example
  namespace: sandbox
spec:
  containers:
    - name: mysql-example
      image: mysql:latest
      ports:
        - name: mysql-tcp
          protocol: TCP
          containerPort: 3306
      volumeMounts:
        - mountPath: "/data/mysql"
          name: vol-mysql-data
  volumes:
    - name: vol-mysql-data
      persistentVolumeClaim:
        claimName: pvc-mysql-example
...
```

In the above example, it creates volume mounts using PVC `pvc-mysql-example` in the MySQL Pod. And then MySQL data will be stored in the path specified by the provisioner on the Kubernetes node.

It depends on the provisioner you deployed and the provisioner's mount path configuration. For example, the default path of Rancher's local-path provisioner on the Kubernetes node is `/var/lib/rancher/k3s/storage/`.

In the next section, we will learn how to setup the *local-path* and *NFS* provisioners on the Kubernetes cluster.

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

