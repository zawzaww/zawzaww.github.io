---
layout: post
title: A Hands-on Practical Guide to K8s Persistent Storage
categories: [Kubernetes]
tags: [kubernetes, storage, provisioning]
image:
  src: /assets/images/featured-images/img_kubernetes_storage.png
  description: "Kubernetes Storage Featured Image by Zaw Zaw"
---

In Kubernetes, we typically need to create and use *Persistent Volumes* for stateful applications such as database servers, cache store servers, and so on. In this article, I will share how storage provisioning on Kubernetes works and how to deploy *Persistent Volumes* dynamically using storage provisioners on the Kubernetes cluster.

In this article. I will mainly focus on configuring the **Local-Path** and **NFS** storage provisioners and managing persistent storage on the Kubernetes On-premises cluster, also known as self-managed Kubernetes.

## Key Points: What You'll Learn

You will learn the following things in this article:

 - Basic concepts of Kubernetes persistent storage.

 - Difference between *Static* storage provisioning and *Dynamic* storage provisioning.

 - How storage provisioning on Kubernetes works.

 - How to setup **Local-Path** and **NFS** storage provisioners on Kubernetes.

 - How to create and provision *Persistent Volumes* on-demand or dynamically on Kubernetes.

## Prerequisites

 - [Kubernetes](https://kubernetes.io) Cluster

 - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux), a client CLI tool to communicate with the cluster

 - [Helm](https://helm.sh) package manager tool

 - Kubernetes Basics
   > Make sure you are familiar with basic Kubernetes objects and resources. If you are a Kubernetes newcomer, you can learn [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics) tutorial that provides a hands-on practical guide on the basics of Kubernetes, container orchestration system.

## Background
### Introduction to Kubernetes Persistent Volumes

Firstly, we need to understand basic concepts on Kubernetes *Persistent Volumes* and how Kubernetes creates and manages persistent volumes. So, we will learn the basics before we setup and configure storage provisioners on the Kubernetes platform.

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

>
> 📝 But, please note that you need to deploy the provisioner on the Kubernetes cluster and we will explore how to setup in the next section.
>

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

## Setting Up Local Path Provisioner

Local Path Provisioner provides the ability to create the local persistent storage on-demand or dynamically in each Kubernetes node. Basically, it uses [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) or [local](https://kubernetes.io/docs/concepts/storage/volumes/#local) to create and deploy local persistent volumes on the Kubernetes node automatically. It's simpler to provision local persistent volumes.

Documentation is available at [https://github.com/rancher/local-path-provisioner/blob/master/README.md](https://github.com/rancher/local-path-provisioner/blob/master/README.md)

### Installation

In this article, we will use Rancher's local-path provisioner on a self-managed Kubernetes cluster.

Local Path Provisioner: [https://github.com/rancher/local-path-provisioner](https://github.com/rancher/local-path-provisioner)

Install with kubectl,

```sh
$ kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.30/deploy/local-path-storage.yaml
```

The provisioner will be installed in the `local-path-storage` namespace by default. After installation, check the provisioner pod and storageclass.

```sh
$ kubectl get pods --namespace local-path-storage
NAME                                                  READY   STATUS      RESTARTS         AGE
local-path-provisioner-5cffd47f7-42nbw                1/1     Running     0                5d20h
```

>
> 📝 The StorageClass resource is a cluster-wide resource and has no namespace scope. You just need to run the `kubectl get storageclass` command.
>

```sh
$ kubectl get storageclass
NAME                   PROVISIONER                    RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path             rancher.io/local-path          Delete          WaitForFirstConsumer   false                  5d20h
```

### Using Local Path Provisioner

In this section, we will test creating a *PersistentVolume* for a *Pod* automatically using PVC with the *local-path* storageclass. I will demonstrate it using the Busybox container image.

Create a YAML named `local-storage-busybox.yaml`.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-local-example
  namespace: sandbox
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 8Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: local-storage-example
  namespace: sandbox
spec:
  containers:
    - name: busybox
      image: busybox:latest
      imagePullPolicy: IfNotPresent
      command:
        - sh
        - '-c'
        - >-
          while true; do
            echo "$(date) [$(hostname)] Hello from Local Persistent Volume." >> /data/local/greet.txt
            sleep $((RANDOM % 5 + 300))
          done
      volumeMounts:
        - name: vol-pvc-local
          mountPath: /data/local
  volumes:
    - name: vol-pvc-local
      persistentVolumeClaim:
        claimName: pvc-local-example
```

Then, install with the kubectl command-line tool like this:

```sh
$ kubectl apply -f local-storage-busybox.yaml
```

### How it Works

![k8s-local-path-storage](/assets/images/featured-images/img_k8s_storage_local.png)

#### PersistentVolumeClaim (PVC)

In the **PersistentVolumeClaim**,
configured with the *local-path* storageclass, access mode is set to *ReadWriteOnce* and 8Gi storage is requested. But, please NOTE that *local* or *hostPath* only supports *ReadWriteOnce* access mode.

For the detailed information about **Access Modes**, please see the [Access Modes in NFS storage section](#how-it-works-1).

Then, it will be provisioned a PV (PersistentVolume) automatically by **Local Path Provisioner** via *StorageClass* because we've installed it and configured PVC (PersistentVolumeClaim) using the *local-path* storage class. So, it's called dynamic storage provisioning and we only need to configure PVC (PersistentVolumeClaim) with storage class.

>
> 📝 The PV resource is a cluster-wide resource and has no namespace scope. You just need to run the `kubectl get pv` command.
>

Check PV with the kubectl command-line tool like this,

```sh
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-7e22e4b8-09d8-4553-88fc-1aefeb7c1ac3   8Gi        RWO            Delete           Bound    sandbox/pvc-local-example    local-path         <unset>                          54m
```

---

#### Busybox Pod (Workload)

In the **Pod**, created a volume mount path, `/data/local` using the PersistentVolumeClaim (PVC) named *pvc-local-example* with the Busybox container image. Basically, Pod's command or script creates a file named *greet.txt*, writes date and hostname data to this file every 5m.

You can check the data by executing into the Pod shell.

```sh
$ kubectl exec -it local-storage-example --namespace sandbox -- sh
$ cd /data/local/
$ cat greet.txt
```

Output:

```sh
Sun Jan 19 05:31:11 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
Sun Jan 19 05:36:14 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
Sun Jan 19 05:41:16 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
Sun Jan 19 05:46:16 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
Sun Jan 19 05:51:18 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
```

#### Worker Node

The actual data *greet.txt* file will be stored on the worker node's local-path provisioner mount path and the mount path on the worker node depends on the provisioner. For example, Rancher's local-path provisioner mount path is `/var/lib/rancher/k3s/storage/` by default.

Then, check if the data *greet.txt* file is stored on the worker node correctly or not.

 - Log in to the worker node with SSH.

 - Then, go to the `/var/lib/rancher/k3s/storage/` path and check the data by running the following commands.

   ```sh
   root@k8s-worker:/var/lib/rancher# cd /var/lib/rancher/k3s/storage
   root@k8s-worker:/var/lib/rancher/k3s/storage# ls -l pvc-7e22e4b8-09d8-4553-88fc-1aefeb7c1ac3_sandbox_pvc-local-example
   total 52
   -rw-r--r-- 1 root root 45657 Jan 21 00:28 greet.txt
   ```

   ```sh
   $ cd pvc-7e22e4b8-09d8-4553-88fc-1aefeb7c1ac3_sandbox_pvc-local-example
   $ cat greet.txt
   Sun Jan 19 05:31:11 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
   Sun Jan 19 05:36:14 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
   Sun Jan 19 05:41:16 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
   Sun Jan 19 05:46:16 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
   Sun Jan 19 05:51:18 UTC 2025 [local-storage-example] Hello from Local Persistent Volume.
   ```

The data directory name or persistent volume data on the worker node is provisioned in the following format.

```
{pv_name}-{namespace}{pvc_name}
```

```
pvc-7e22e4b8-09d8-4553-88fc-1aefeb7c1ac3_sandbox_pvc-local-example
```

## Setting up NFS Provisioner

NFS (Network File System) is a distributed file system protocol that allows you to store and mount data on the remote server, also known as the NFS server. That means a client user can access data over a network and server-client way to manage data storage.

In Kubernetes, we will use [NFS Subdir External Provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner) for provisioning persistent volumes on the NFS server. Basically, *NFS subdir external provisioner*, is a dynamic provisioner that uses the already configured NFS server to provision and create Kubernetes persistent volumes automatically on its NFS server using the PVC (PersistentVolumeClaim) and storage class.

Documentation at available at [https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/blob/master/README.md](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/blob/master/README.md)

Before you deploy the NFS provisioner on Kubernetes, make sure you install both the NFS server and client tool.

### Setup NFS Server

Install the NFS server package. It depends on your Linux distribution. In this article, we will install it on Ubuntu Linux.

```sh
sudo apt update
sudo apt install -y nfs-server
```

Configure the NFS server `/etc/exports` configuration for access control list for filesystems that may be exported to NFS clients.

>
> 📝 IPv4 address or hostname is your NFS clients IP addresses.
>

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

### Install NFS Client on Worker Nodes

Before you setup NFS storage provisioner, make sure you install the NFS client tool on the Kubernetes Worker nodes.

On Debian-based Linux systems,

```sh
sudo apt install -y nfs-common
```

On RHEL-based Linux systems, for example: Fedora Linux,

```sh
sudo dnf install -y nfs-utils
```

### Install NFS Subdir External Provisioner

In this section,
we will install the *NFS subdir external provisioner* with the Helm package manager.

Helm Repo URL: [https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner](https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner)

Add a Helm repository,

```sh
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
```

Install the *NFS subdir external provisioner* with Helm like this,

Format:

```sh
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --create-namespace \
    --namespace nfs-provisioner \
    --set nfs.server=ip_addr_or_hostname \
    --set nfs.path=/exported/path
```

Example:

```sh
helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --create-namespace \
    --namespace nfs-provisioner \
    --set nfs.server=127.0.0.1 \
    --set nfs.path=/data/nfs
```

`nfs.server=127.0.0.1` Replace the IP address with your NFS IP address.

`nfs.path=/data/nfs` Replace the mount path with your exported path or mount path on the NFS server.

The *NFS subdir external provisioner* will be installed in the *nfs-provisioner* namespace. After installation, check the NFS provisioner's workload (Pods) and StorageClass with the kubectl command-line tool.

```sh
$ kubectl get pods --namespace nfs-provisioner
NAME                                                              READY   STATUS    RESTARTS       AGE
nfs-provisioner-infra-nfs-subdir-external-provisioner-665fhd2wn   1/1     Running   0              5d20h
```

> 📝 The StorageClass resource is a cluster-wide resource and has no namespace scope. You just need to run the `kubectl get storageclass` command.

```sh
$ kubectl get storageclass
NAME                        PROVISIONER                                                     RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
nfs-client                  cluster.local/nfs-provisioner-nfs-subdir-external-provisioner   Delete          Immediate              true                   5d20h
```

### Using the NFS Subdir External Provisioner

In this section, we will test creating and provisioning a *PersistentVolume (PV)* for a *Pod* automatically using *PersistentVolumeClaim (PVC)* with the `nfs-client` storage class. I will demonstrate it using the Busybox container image.

Create a YAML file named `nfs-storage-busybox.yaml` that includes PersistentVolumeClaim (PVC) and Pod resources.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nfs-example
  namespace: sandbox
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: nfs-client
  resources:
    requests:
      storage: 8Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: nfs-storage-example
  namespace: sandbox
spec:
  containers:
    - name: busybox
      image: busybox:latest
      imagePullPolicy: IfNotPresent
      command:
        - sh
        - -c
        - >-
          while true; do
            echo "$(date) [$(hostname)] Hello from NFS Persistent Volume." >> /app/data/greet.txt
            sleep $((RANDOM % 5 + 300))
          done
      volumeMounts:
        - name: vol-pvc-nfs
          mountPath: /app/data
  volumes:
    - name: vol-pvc-nfs
      persistentVolumeClaim:
        claimName: pvc-nfs-example
```

Then, install with the `kubectl` command-line tool like this,

```sh
$ kubectl apply -f nfs-storage-busybox.yaml
```

### How it Works

![k8s-nfs-storage](/assets/images/featured-images/img_k8s_storage_nfs.png)

#### PersistentVolumeClaim (PVC)

In the **PersistentVolumeClaim**,
configured with the `nfs-client` storage class, access mode is set to *ReadWriteMany* and 8Gi storage is requested.

`spec.accessModes` Set accessModes to `ReadWriteMany`. Basically, an access mode defines how a PV (PersistentVolume) can be accessed by Pods. That specifies *Who* can mount the volume (one or multi Kubernetes nodes) and *How* the volume can be accessed (read-only or read-write).

Documentation is also available at [https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)

The available access modes are *ReadWriteOnce*, *ReadOnlyMany*, *ReadWriteMany* and *ReadWriteOncePod*. *But it depends on storage providers, and we need to check which access mode is supported.*

 - **ReadWriteOnce (RWO)**: The persistent volume can be mounted as read-write by a single node at a time.

 - **ReadOnlyMany (ROX)**: The persistent volume can be mounted as read-only by multi nodes simultaneously.

 - **ReadWriteMany (RWX)**: The persistent volume can be mounted as read-write by multi nodes at the same time.

 - **ReadWriteOncePod (RWOP) - Kubernetes v1.22+**: The persistent volume can be mounted by only one *Pod* at a time.

| Access Mode             | Multi Nodes          | Read-Write     | Common Storage Types                                        |
|-------------------------|----------------------|----------------|-------------------------------------------------------------|
| ReadWriteOnce (RWO)     | ❌ No                | ✅ Yes         | e.g; Rancher's local-path, AWS EBS                            |
| ReadOnlyMany (ROX)      | ✅ Yes               | ❌ No          | e.g; NFS, CephFS                                            |
| ReadWriteMany (RWX)     | ✅ Yes               | ✅ Yes         | e.g; Azure Files, CephFS, NFS, Longhorn, OpenEBS and etc... |
| ReadWriteOncePod (RWOP) | ❌ No (Only one Pod) | ✅ Yes         | e.g; Block storage like RWO but single Pod restriction      |

>
> 📝 The *ReadWriteOncePod* access mode is only supported for CSI volumes and Kubernetes version 1.22 and up.
>

`spec.storageClassName` Set storageClassName to *nfs-client*. It depends on what storage class you want to use.

`spec.resources.requests.storage` Set storage size that PVC (PersistentVolumeClaim) requests storage from a PV (PersistentVolume).

After deploying the above PVC (PersistentVolumeClaim) named `pvc-nfs-example`, it will be provisioned a PV (PersistentVolume) by the *NFS subdir external provisioner* using the `nfs-client` storage class.

Then, check PV (PersistentVolume) resource with the kubectl command-line tool,

```sh
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                     STORAGECLASS       VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-edf39de5-42e2-453a-a23f-c4f5f58cf69a   8Gi        RWX            Delete           Bound    sandbox/pvc-nfs-example   nfs-client         <unset>                          6h46m
```

---

#### Busybox Pod (Workload)

In the **Pod**,
created a volume mount path, `/app/data` using the PersistentVolumeClaim (PVC) named *pvc-nfs-example* with the Busybox container image. Basically, Pod’s command or script creates a file named *greet.txt*, writes *date and hostname* data to this file every 5m.

Then, you can check the data by executing into the Pod shell.

```sh
$ kubectl exec -it nfs-storage-example --namespace sandbox -- sh
$ cd /app/data
$ cat greet.txt
```

Output:
```
Tue Jan 28 23:10:38 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
Tue Jan 28 23:15:42 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
Tue Jan 28 23:20:44 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
Tue Jan 28 23:25:47 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
Tue Jan 28 23:30:48 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
```

---

#### NFS Server

The actual data *greet.txt* file will be stored on the NFS server's mount path, `/data/nfs/` and the mount path is specified when you set up the NFS server and the NFS subdir external provisioner.

Then, check if the data *greet.txt* file is stored on the NFS server correctly or not.

 - Log in to the NFS server with SSH.

 - Then, go to the NFS mount path `/data/nfs/` and check the data by running the `ls` and `cat` commands.

   ```sh
   zawzaw@nfs-dev-server:~$ cd /data/nfs/
   zawzaw@nfs-dev-server:/data/nfs$ ls -l sandbox-pvc-nfs-example-pvc-edf39de5-42e2-453a-a23f-c4f5f58cf69a/
   total 12
   -rw-r--r-- 1 root root 10795 Jan 29 16:14 greet.txt
   ```

   ```sh
   $ cd sandbox-pvc-nfs-example-pvc-edf39de5-42e2-453a-a23f-c4f5f58cf69a
   $ cat greet.txt
   Tue Jan 28 23:10:38 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
   Tue Jan 28 23:15:42 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
   Tue Jan 28 23:20:44 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
   Tue Jan 28 23:25:47 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
   Tue Jan 28 23:30:48 UTC 2025 [nfs-storage-example] Hello from NFS Persistent Volume.
   ```

The data directory or persistent volume data on the NFS server is provisioned as the following format.

```
{namespace}-{pvc_name}-{pv_name}
```

```
sandbox-pvc-nfs-example-pvc-edf39de5-42e2-453a-a23f-c4f5f58cf69a
```

