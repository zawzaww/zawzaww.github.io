---
layout: post
title: "Setting up NFS Storage Provisioner on Kubernetes"
categories: [Kubernetes]
tags: [kubernetes, storage, k8s]
---

This blog post focuses on how to setup NFS, Network Filesystem Server and deploy persistent volume claims, PVCs
with NFS storage dynamic provisioner on Kubernetes cluster.

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

