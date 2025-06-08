---
layout: post
title: "Containers from Scratch: Deep Dive into Multi-Host Container Networking (Part II)"
categories: [Containerization]
tags: [containerization, containers, networking]
image:
  src: /assets/images/featured-images/img_container_networking.png
  description: "Container Networking Featured Photo"
---

This article is Part II of the previously published article, [Containers from Scratch: Deep Dive into Single-Host Container Networking](https://www.zawzaw.blog/posts/deep-dive-single-host-container-net). In Part I, you've learned how two containers communicate on the same single host, also known as **Single-host** container networking.

In this article, Part II, you'll learn how Containers *(Container A and Container B)* running on two different hosts (VMs) communicate and interact with each other using VXLAN networking, also known as **Multi-host** container networking, and I'll also demonstrate how Multi-host container networking works at the underlying layer with built-in Linux command-line tools.

## Summary: Objectives

*What you'll learn in this article:*

 - Basic Multi-Host Networking concepts

 - Basic Concepts of Kubernetes CNI (Container Network Interface) plugins

 - What's VXLAN (Virtual eXtensible Local-Area Network) and how it works

 - How Containers running on Different Hosts communicate and interact using VXLAN networking

## Prerequisites

Before you begin, make sure you've installed the following tools:

  - Linux-based Two VMs (or) Servers
  - Basic Networking Concepts
  - Familiar with Linux networking tools, such as `ip` and `brctl`

---

## Overview of Multi-host Container Networking

You've previously learned how two containers communicate on the same single host, only one host (or) VM, also known as Single-host container networking. For example, Docker single host.

 > In Multi-host container networking facilitated by overlay networks, containers running on the different hosts (or) VMs can communicate with each other in the same network. Sometimes, we refer to it as Multi-node (or) Cluster networking. For example, Docker Swarm mode, Kubernetes.

Technically, we can use two different networking methods for Multi-host container networking.

  - **VXLAN (Virtual eXtensible Local-Area Network)** is a tunneling protocol or network virtualization technology that provides tunneling a virtual Layer 2 network (overlay network) over the Layer 3 network (underlay network).

  - **Direct Routing (also known as Native or Simple Routing)** is the Linux kernel's built-in capabilities for forwarding network packets between different networks, rather than using specific software or network protocols. That means it's no encapsulation, no overlay network. It's just simple IP routing.

For Example, the following Kubernetes CNI (Container Network Interface) plugins use different networking modes. But some Kubernetes CNIs provide both VXLAN (Encapsulation) and Direct Routing (or Native Routing) modes.

  - [Flannel](https://github.com/flannel-io/flannel/): VXLAN is the default networking mode of Flannel.

  - [Calico](https://docs.tigera.io/calico/): Calico's default networking mode is BGP (Border Gateway Protocol) or Direct Routing, but you can also use the VXLAN networking mode.

  - [Cilium](https://docs.cilium.io/en/stable/): Cilium also provides both VXLAN and Direct Routing (or Native Routing) modes. But the default networking mode is VXLAN or tunnel mode, also known as encapsulation mode.

  - [Kube-router](https://www.kube-router.io/docs/): The default networking mode of Kube-router is BGP or Direct Routing (or Native Routing) as the main routing mechanism and so on.

You can see the CNI full list on [https://github.com/containernetworking/cni?tab=readme-ov-file#3rd-party-plugins](https://github.com/containernetworking/cni?tab=readme-ov-file#3rd-party-plugins).

In this article, I will focus on **VXLAN Networking** to demonstrate Multi-host container networking from scratch.

---

## What's VXLAN and How it Works

![vxlan-diagram](/assets/images/featured-images/img_vxlan_diagram.png)
_Photo Credit to: RedHat Developers (developers.redhat.com)_

**VXLAN (Virtual eXtensible Local-Area Network)** is a tunneling protocol or network virtualization technology that provides for creating a virtual Layer 2 network (overlay network) over the Layer 3 network (underlay network).

  - **An Overlay Network** is a virtual or logical network built on top of an existing physical network (also known as underlay network). It provides services, such as network virtualization, segmentation, and tunneling. For examples; VPNs, VXLAN.

  - **An Underlay Network** is the physical network infrastructure that provides the actual connectivity. For example; network routers, switches.

VXLAN encapsulates the Layer 2 Ethernet frames into UDP packets. This enables Layer 2 network (the data link layer, e.g: switch) traffic to traverse a Layer 3 network (the network layer, e.g; router and IP address). It's especially used in data centers, cloud environments, scalable overlay networks for VMs, and containers.

### Use Cases

There are example use cases of VXLAN:

  - Cloud Networking — Connecting VMs across hosts.
  - Container Networking — Kubernetes CNI (Container Network Interface) plugins.

### VXLAN Components

There are key components of VXLAN:

  - **VXLAN Tunnel Endpoint (VTEP)**: This is the core component that performs the encapsulation and decapsulation of VXLAN packets. VTEPs can be physical network devices or virtual switches within hypervisors (e.g: VMware). Each VTEP has a unique IP address in the underlay network.

  - **VXLAN Network Identifier (VNI)**: This is a 24-bit identifier that uniquely identifies each virtual network segment within the VXLAN overlay.

  - **Underlay Network**: This is the physical network that VXLAN traffic traverses. It provides the routing infrastructure for the encapsulated VXLAN packets.

  - **Overlay Network**: This is the virtual network created by VXLAN, running on top of the underlay physical network. It allows VMs (or Servers) to communicate.

### How VXLAN Works

Basically, **VXLAN (Virtual eXtensible Local-Area Network)** works by encapsulating L2 Ethernet frames in UDP/IP with VTEPs handling the mapping between virtual overlay and physical underlay networks.

Simple Usage:

```sh
$ ip link add <vx0> type vxlan id 100 local <10.0.0.100> remote <10.0.0.200> dev eth0 dstport 4789
```

#### Setup (1): Frame Arrival

  - A VM or Server sends an Ethernet frame. For example, Host (A) ⟶  Host (B).
  - The frame reaches the local VTEP (VXLAN Tunnel Endpoint).

#### Setup (2): Encapsulation

  - The VTEP checks the VNI (VXLAN Network Identifier) and destination MAC address.
  - It then encapsulates the frame inside a UDP/IP packet:
      - Outer Source IP: Local VTEP IP `10.0.0.100`
      - Outer Destination IP: Remote VTEP IP `10.0.0.200`
      - VNI: `100` (For example, `100`)
      - UDP Port: 4789 (The default VXLAN UDP port is `4789`)

#### Setup (3): Underlay Forwarding

  - The encapsulated packet is sent over the physical (underlay) network.

#### Setup (4): Decapsulation at Remote VTEP

  - The remote VTEP (`10.0.0.200`) receives the packet.
  - Then, it checks the following:
      - UDP Port: `4789` ⟶  identifies it as VXLAN.
      - VNI: `100` ⟶  determines which virtual network it belongs to.
      - The ethernet frame is delivered to the correct destination VM or server.

---

## Multi-Host Container Networking from Scratch

In this section,
I will focus on configuring the network for *Two Containers — Container A and Container B*, running on Two Different VMs (Hosts) to communicate with each other. Make sure you have two Linux VMs or servers. In this article, I will use two AWS EC2 Instances to demonstrate how Multi-Host Container networking works using the VXLAN networking mode.

Our project setup looks like this. Container A and Container B are running on Two different hosts.

 - Container A (`10.0.0.100`) on Host (1) — Debian Linux VM (`172.31.89.40`)
 - Container B (`10.0.0.200`) on Host (2) — Amazon Linux VM (`172.31.94.69`)

### How it Works

![Multi-Host Container Networking Diagram](/assets/images/featured-images/img_multi_host_container_networking.png)
_Diagram on How Multi-Host Container Networking Works_

 - *Container (A)* and *Container (B)* are running on two different hosts (Host 1 and Host 2).

 - VETH (Virtual Ethernet) pair `veth0`,`veth1` that connects the network between Host and Container in the same Linux network namespace. `veth0` on the Host machine and `veth1` on the container.

 - VXLAN (Virtual eXtensible Local-Area Network) creates a tunnel that connects Host (1) — Debian Linux VM and Host (2) — Amazon Linux VM.

 - Then, the Bridge network `br0` is a network switch that forwards network packets between VXLAN and VETH network interfaces. Then, Container (A) and Container (B) can communicate with each other.

*In the next section, you'll learn how to set up and configure the network in more detail.*

---

![Host 1](/assets/images/featured-images/img_multi_host_container_net_host1.png)

### On Host (1) Debian Linux VM

#### Configuring Container Network

Firstly, I will set up and configure the network for Container A on Host (1) — Debian Linux. For running Containers, we will use the Alpine Linux root filesystem image.

Make sure you familiar with how to run a Container from scratch with unshare, chroot tools and you've learned how to run it in the previous article, Part I — Containers from Scratch: Deep Dive into Single-Host Container Networking.

Create a project directory and download the Alpine Linux root filesystem image. This setup is same as the previous (Part I) article.

```sh
$ mkdir -p containers/alpine-linux
$ curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-minirootfs-3.21.3-x86_64.tar.gz
```

Extract the alpine-minirootfs-3.21.3-x86_64.tar.gz tar file and clean up.

```sh
$ tar -xzvf alpine-minirootfs-3.21.3-x86_64.tar.gz
$ rm alpine-minirootfs-3.20.2-x86_64.tar.gz
```

Project structure looks like this:

```sh
~/containers/alpine-linux
 ├── bin
 ├── dev
 ├── etc
 ├── home
 ├── lib
 ├── media
 ├── mnt
 ├── opt
 ├── proc
 ├── root
 ├── run
 ├── sbin
 ├── srv
 ├── sys
 ├── tmp
 ├── usr
 └── var
```

I will create and run Container A in an isolated PID (Process ID), mount, and network namespaces using the command-line tools, unshare, chroot.
> The following command creates a Container (Container A) that is fully PID, mount, and network isolated from the Host (OS) machine and then mounts the /proc virtual filesystem.

```sh
$ cd ~/containers/alpine-linux
$ sudo unshare --pid --mount --net \
     -f chroot ./  \
     env -i HOSTNAME=alpine-linux \
     /bin/sh -c "mount -t proc proc /proc; exec /bin/sh;"
```

Then, open another terminal on the your Host machine and get the container process ID with the following command.
> The following command gets the current running container's PID and sets the environment variable and then I will use this ENV variable when configuring the container network.

```sh
$ export CONTAINER_PID=$(ps -C sh -o pid= | tr -d ' ')
```

Then, create a VETH (Virtual Ethernet) network pair veth0, veth1 with the ip command-line tool.
> The following command creates a VETH pair veth0, veth1 and sets veth1 to the network namespace with the current running container PID and then brings veth0 up. The VETH device is like a local Ethernet tunnel, and a VETH pair consists of two interfaces — one in the host machine's network namespace and another one in the container's network namespace. In the above example, veth0 is in the host machine's Net namespace and veth1 is in the container's Net namesapce.

```sh
sudo ip link add veth0 type veth peer name veth1
sudo ip link set veth1 netns ${CONTAINER_PID}
sudo ip link set dev veth0 up
```

Then, set the IP address of Container A by running the following command without entering into the container's shell.
> The following command sets the IP address 10.0.0.100 to the veth1 network interface, also known as Container A's IP address and brings lo, veth1 up. You can use nsenter to exec commands without entering the container's shell.

**Container A's IP address** ⟶  `10.0.0.100`

```sh
sudo nsenter --target ${CONTAINER_PID} \
  --mount \
  --net \
  --pid \
  chroot ${HOME}/containers/alpine-linux \
  /bin/sh -c "ip addr add dev veth1 10.0.0.100/24; ip link set lo up; ip link set veth1 up"
```

Then, I will create a bridge network and attach veth0 to the bridge network with the following command.
> The following command creates a Bridge network interface named `br0`, attaches `veth0` to the `br0` bridge interface, sets the IP address, and brings it up. Make sure you create and configure the bridge network because we need to communicate between the Container and the Host machine. A bridge network is like a network switch that forwards packets between network interfaces that are connected to it.

```sh
$ sudo ip link add br0 type bridge
$ sudo ip link set veth0 master br0
$ sudo ip addr add dev br0 10.0.0.1/24
$ sudo ip link set br0 up
```

#### Configuring VXLAN Network Interface

In this section, I will set up and configure VXLAN to create a tunnel between *Host (1) — Debian Linux VM* and *Host (2) — Amazon Linux VM*, and then you can communicate between Container A and Container B.

On the **Host (1) Debian Linux VM**, create a VXLAN interface with the ip command-line tool.
> The following command creates a VXLAN interface named `vxlan0` and brings it up. It creates a tunnel and connects two VMs or servers. Host (1) — Debian Linux VM (`172.31.89.40`) is local and Host (2) — Amazon Linux VM (`172.31.94.69`) is remote. Make sure you set the same VNI (id) on both Host (1) and Host (2).

 - Local IP Address ⟶  `172.31.89.40` (Debian Linux VM)
 - Remote IP Address ⟶  `172.31.94.69` (Amazon Linux VM)
 - VXLAN Network Identifier (VNI) ⟶  `100`
 - Destination Port⟶  `4789` (Default UDP Port)
 - Network Interface (Device) ⟶  `enX0` (Ethernet network device on the Debian Linux VM)

```sh
sudo ip link add vxlan0 \
  type vxlan \
  id 100 \
  local 172.31.89.40 \
  remote 172.31.94.69 \
  dstport 4789 \
  dev enX0 && \
sudo ip link set vxlan0 up
```

Then, attach the `vxlan0` interface to the bridge network device with the following command.
> The following command attaches the vxlan0 interface to the br0 bridge network device. Previously, we've created this bridge device and make sure you attach your VXLAN interface to the bridge network device. We need to forward packets or connect the VETH and VXLAN interfaces because it's necessary to communicate between Container A (running on Host 1) and Container B (running on Host 2).

```sh
sudo ip link set vxlan0 master br0
```

Then, you can check it with the brctl command-line tool. Make sure your veth0 and vxlan0 are attached to the bridge br0 device.

```sh
$ brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.8aea1d11531b       no              veth0
                                                        vxlan0
```

---

![Host 2](/assets/images/featured-images/img_multi_host_container-net_host2.png)

### On Host (2) Amazon Linux VM

#### Configuring Container Network

Same as the previous Host (1) setup, I will set up and configure the network for **Container B** on **Host (2) — Amazon Linux**. To create and run the container, we will use the Alpine Linux root filesystem image.

Create a project directory and download the Alpine Linux root filesystem image. This setup is same as the previous (Part I) article.

```sh
$ mkdir -p containers/alpine-linux
$ curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-minirootfs-3.21.3-x86_64.tar.gz
```

Extract the alpine-minirootfs-3.21.3-x86_64.tar.gz tar file and clean up.

```sh
$ tar -xzvf alpine-minirootfs-3.21.3-x86_64.tar.gz
$ rm alpine-minirootfs-3.20.2-x86_64.tar.gz
```


Project structure looks like this:

```sh
~/containers/alpine-linux
 ├── bin
 ├── dev
 ├── etc
 ├── home
 ├── lib
 ├── media
 ├── mnt
 ├── opt
 ├── proc
 ├── root
 ├── run
 ├── sbin
 ├── srv
 ├── sys
 ├── tmp
 ├── usr
 └── var
```

I will create and run **Container B** in an isolated PID (Process ID), mount, and network namespaces using the command-line tools, unshare, chroot.
> This command creates a Container (Container B) that is fully PID, mount, and network isolated from the Host (OS) machine and then mounts the `/proc` virtual filesystem.

```sh
$ cd ~/containers/alpine-linux
$ sudo unshare --pid --mount --net \
     -f chroot ./  \
     env -i HOSTNAME=alpine-linux \
     /bin/sh -c "mount -t proc proc /proc; exec /bin/sh;"
```

Then, open another terminal on the your Host machine and get the container process ID with the following command.
> This command gets the current running container's PID and sets the environment variable and then I will use this ENV variable when configuring the container network.

```sh
$ export CONTAINER_PID=$(ps -C sh -o pid= | tr -d ' ')
```

Then, create a VETH (Virtual Ethernet) network pair veth0, veth1 with the ip command-line tool.
> This command creates a VETH pair veth0, veth1 and sets veth1 to the network namespace with the current running container PID and then brings veth0 up. The VETH device is like a local Ethernet tunnel, and a VETH pair consists of two interfaces — one in the host machine's network namespace and another one in the container's network namespace. In the above example, veth0 is in the host machine's Net namespace and veth1 is in the container's Net namesapce.

```sh
sudo ip link add veth0 type veth peer name veth1
sudo ip link set veth1 netns ${CONTAINER_PID}
sudo ip link set dev veth0 up
```

Then, set the IP address of Container B by running the following command without entering into the container's shell.
> This command sets the IP address `10.0.0.200` to the veth1 network interface, also known as Container B's IP address and brings lo, veth1 up. You can use nsenter to exec commands without entering the container's shell.

**Container B's IP address** ⟶  `10.0.0.200`

```sh
sudo nsenter --target ${CONTAINER_PID} \
  --mount \
  --net \
  --pid \
  chroot ${HOME}/containers/alpine-linux \
  /bin/sh -c "ip addr add dev veth1 10.0.0.200/24; ip link set lo up; ip link set veth1 up"
```

Then, I will create a bridge network and attach `veth0` to the bridge network with the following command.
> This command creates a Bridge network interface named `br0`, attaches `veth0` to the `br0` bridge interface, sets the IP address, and brings it up. Make sure you create and configure the bridge network because we need to communicate between the Container and the Host machine. A bridge network is like a network switch that forwards packets between network interfaces that are connected to it.

```sh
$ sudo ip link add br0 type bridge
$ sudo ip link set veth0 master br0
$ sudo ip addr add dev br0 10.0.0.2/24
$ sudo ip link set br0 up
```

#### Configuring VXLAN Network Interface

In this section, I will set up and configure VXLAN to create a tunnel between *Host (1) — Debian Linux VM* and *Host (2) — Amazon Linux VM*, and then you can communicate between *Container A* and *Container B*.

Same as the previous Host (1) setup, on the **Host (2) Amazon Linux VM**, create a VXLAN interface with the ip command-line tool.
> This command creates a VXLAN interface named vxlan0 and brings it up. It creates a tunnel and connects two VMs or servers. In this setup, Host (2) — Amazon Linux VM (172.31.94.69) is local and Host (1) — Debian Linux VM (172.31.89.40) is remote. Make sure you set the same VNI (id) on both Host (1) and Host (2).

 - Local IP Address ⟶  `172.31.94.69` (Host 2 Amazon Linux VM)
 - Remote IP Address ⟶  `172.31.89.40` (Host 1 Debian Linux VM)
 - VXLAN Network Identifier (VNI) ⟶  `100`
 - Destination Port ⟶  `4789` (Default UDP Port)
 - Network Interface (Device) ⟶  `enX0` (Ethernet network device on the Host 2 Amazon Linux VM)

```sh
sudo ip link add vxlan0 \
  type vxlan \
  id 100 \
  local 172.31.94.69 \
  remote 172.31.89.40 \
  dstport 4789 \
  dev enX0 && \
sudo ip link set vxlan0 up
```

Then, attach the `vxlan0` interface to the bridge network device with the following command.
> This command attaches the `vxlan0` interface to the `br0` bridge network device. Previously, we've created this bridge device and make sure you attach your VXLAN interface to the bridge network device. We need to forward packets or connect the VETH and VXLAN interfaces because it's necessary to communicate between Container A (running on Host 1) and Container B (running on Host 2).

```sh
sudo ip link set vxlan0 master br0
```

Then, you can check it with the brctl command-line tool. Make sure your `veth0` and `vxlan0` are attached to the bridge `br0` device.

```sh
$ brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.8aea1d11531b       no              veth0
                                                        vxlan0
```

---

## Testing Network Connectivity

Now, you've configured the container network and VXLAN tunnel, and you can ping the containers' IP addresses to confirm if it works.

Ping Container A (`10.0.0.100`) from the Host 2 (Amazon Linux VM).

```sh
ping 10.0.0.100
```

Ping Container B (`10.0.0.200`) from the Host 1 (Debian Linux VM).

```sh
ping 10.0.0.200
```

Reference Links:

 - [https://blog.mbrt.dev/posts/container-network](https://blog.mbrt.dev/posts/container-network)
 - [https://labs.iximiuz.com/tutorials/container-networking-from-scratch](https://labs.iximiuz.com/tutorials/container-networking-from-scratch)
 - [https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking)

