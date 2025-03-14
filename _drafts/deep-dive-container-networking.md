---
layout: post
title: "Containers from Scratch: Deep Dive into Container Networking"
categories: [Containerization]
tags: [containerization, containers, networking]
---

This article focused on a deep dive into Container networking; how to run Containers and configure Container Networking from scratch using the tools, such as *Linux Namespaces*, *chroot*, *unshare* and *ip*. This article also provides a hands-on practical guide on how to run and configure from scratch using these tools.

In this article, you'll mainly learn how Container Networking works at the underlying layer (or low-level) and then, you'll clearly understand how Docker networking works.

## Before We Begin

Before we begin, make sure you are familiar with the following tools:

 - Linux Host (e.g., Ubuntu, Fedora, etc..)

 - [chroot](https://man7.org/linux/man-pages/man1/chroot.1.html) ─ *a user-space tool to interact with the [chroot(2)](https://man7.org/linux/man-pages/man2/chroot.2.html) system call, to change the root filesystem of the calling process.*

 - [unshare](https://man7.org/linux/man-pages/man1/unshare.1.html) ─ *a user-space tool to interact with [Linux kernel namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html) by invoking the [unshare(2)](https://man7.org/linux/man-pages/man2/unshare.2.html) system call, to run a program in a new namespace that isolates the process ID, mount, IPC, network, and so on.*

 - [Linux namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html) ─ *a feature of the Linux kernel that partitions kernel resources such that one set of processes sees one set of resources, while another set of processes sees a different set of resources.*

NOTE: If you have installed any Linux distribution, these tools are built-in tools and features.

## Introduction to Containers

![docker-containers](/assets/images/featured-images/img_docker_containers.png)
_Docker Containers vs Virtual Machines by Docker_

Nowadays, containers are a popular topic, and most companies are using containers to build, ship and run application workloads in both development and production environments.

Basically, containers are a way to package and deploy applications in an isolated and portal environment and they provide a standardized way to bundle an application's code, dependencies and configuration into a single unit that can be easily deployed on the server.

Containers use OS-level virtualization to create an isolated environment for running applications. OS-level virtualization is a technology that allows multiple isolated Operating Systems to run on the same hardware, also known as containerization. Containers share the Host OS's kernel and hardware resources, such as CPU and memory that make resource efficiency.

Benefits of using Containers are:

 - **Portability**: Containers can be moved easily between different environments, such as development, QA, staging and production.

 - **Consistency**: Containers ensure that the application and its dependencies are packaged into a single unit that can be deployed easily.

 - **Scalability**: Containers can be scaled up or down easily on demand.

 - **Efficiency**: Containers are lightweight and share the Host OS's kernel and hardware resources that make more efficient to run applications.

## Setup Project and Root Filesystem

Firstly, we will build and run Containers from scratch using the `chroot` and `unshare` command-line tools to understand how Containers work.

Project Structure looks like:

```
${HOME}/containers
        ├── alpine-linux
        │   ├── bin
        │   ├── dev
        │   ├── etc
        │   ├── home
        │   ├── lib
        │   ├── media
        │   ├── mnt
        │   ├── opt
        │   ├── proc
        │   ├── root
        │   ├── run
        │   ├── sbin
        │   ├── srv
        │   ├── sys
        │   ├── tmp
        │   ├── usr
        │   └── var
        └── tiny-linux
            ├── bin
            ├── dev
            ├── proc
            ├── sbin
            ├── sys
            └── usr
```

Create a project directory named, `containers` and then, we will put the Linux root filesystems (Alpine Linux, Tiny Linux) into it.

```sh
$ mkdir -p chroot/alpine-linux
```

In this article, we will use the Alpine Linux Mini root filesystem. Go to the Alpine Linux official website [https://alpinelinux.org/downloads](https://alpinelinux.org/downloads) and download the Alpine Linux Mini root filesystem.

Alpine Linux has supported the Alpine Mini root filesystem that is for containers and minimal chroots. That supports multiple system architectures, such as **aarch64, armv7. riscv64, x86, x86_64** and so on.

![img-alpine-mini-rootfs](/assets/images/screenshots/img_screenshot_alpine_mini_rootfs.png)

(Or)

Download with the `curl` command line tool. For example, `x86_64` architecture.

```sh
$ curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-minirootfs-3.21.3-x86_64.tar.gz
```

Put the downloaded Alpine Linux Mini rootfs file under the `chroot/alpine-linux` directory and then, extract the mini rootfs tar file.

```sh
$ tar -xzvf alpine-minirootfs-3.21.3-x86_64.tar.gz
```

Then, clean up the `alpine-minirootfs-3.21.3-x86_64.tar.gz` tar file.

```sh
$ rm alpine-minirootfs-3.20.2-x86_64.tar.gz
```

## Chroot: Basic Concept of Containers

### Introduction to Chroot

```sh
/ (Host Root Filesystem)
├── bin
├── dev
├── etc
├── home
│   └── zawzaw/
│        └── containers/
│            ├── alpine-linux/
│            │    ├── bin
│            │    ├── dev
│            │    ├── etc
│            │    ├── home
│            │    ├── lib
│            │    ├── proc
│            │    ├── sbin
│            │    └── var
│            └── tiny-linux/
│                 ├── bin
│                 ├── dev
│                 ├── init.sh
│                 ├── linuxrc -> bin/busybox
│                 ├── proc
│                 ├── sbin
│                 ├── sys
│                 ├── sbin
│                 └── usr
├── proc
├── sbin
├── sys
├── usr
└── var
```

[Chroot](https://man7.org/linux/man-pages/man2/chroot.2.html) (Change Root) is a *Basic Concept* of Containers. chroot is an operation that changes the apparent root directory for the current running process and its children on Unix and Unix-like operating systems. Historically, the chroot system call was introduced in Unix Seventh Edition (Version 7) in 1979.

The `chroot` user-space program (or cleint command-line tool) functionality relies on kernel support because it calls the system call [chroot(2)](https://man7.org/linux/man-pages/man2/chroot.2.html) handled by the kernel. This means that while you can execute `chroot` in user space, its effects depend on kernel-level enforcement.

 - `chroot` is a user-space program (or) client command-line tool.
 - It calls the [chroot(2)](https://man7.org/linux/man-pages/man2/chroot.2.html) system call, which is handled by the kernel.
 - It is commonly used for sandboxing processes (or) creating minimal environments for recovery and testing.
 - A process inside chroot still runs with the same privileges (it does not enhance security like containers do).

### Using the Chroot User-space Tool

On Linux, we can use the `chroot` client command-line tool, to interact with the [chroot(2)](https://man7.org/linux/man-pages/man2/chroot.2.html) system call (a kernel API function call) to change the root directory for the current running process.

Go to the already created project directory `${HOME}/containers/alpine-linux` and run the `chroot` command.

```sh
$ cd $HOME/containers/alpine-linux
$ sudo chroot . /bin/sh
```

```sh
/ # ls -l
total 0
drwxr-xr-x    1 1000     1000           858 Jul 22 14:34 bin
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 dev
drwxr-xr-x    1 1000     1000           540 Jul 22 14:34 etc
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 home
drwxr-xr-x    1 1000     1000           272 Jul 22 14:34 lib
drwxr-xr-x    1 1000     1000            28 Jul 22 14:34 media
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 mnt
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 opt
dr-xr-xr-x    1 1000     1000             0 Jul 22 14:34 proc
drwx------    1 1000     1000            24 Jul 30 04:26 root
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 run
drwxr-xr-x    1 1000     1000           790 Jul 22 14:34 sbin
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 srv
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 sys
drwxr-xr-x    1 1000     1000             0 Jul 22 14:34 tmp
drwxr-xr-x    1 1000     1000            40 Jul 22 14:34 usr
drwxr-xr-x    1 1000     1000            86 Jul 22 14:34 var
```
```sh
/ # cat /etc/os-release
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.21.3
PRETTY_NAME="Alpine Linux v3.21"
HOME_URL="https://alpinelinux.org/"
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"
```

Then, you need to mount the *proc* virtual filesystem inside the chroot isolated environment.

```sh
$ mount -t proc proc /proc
```

This `mount` command mounts the [/proc](https://docs.kernel.org/filesystems/proc.html) Virtual Filesystem (VFS) to the `/proc` directory inside the chroot (or) container environment.

 - `mount`: This command to attach a filesystem to the directory tree.
 - `-t proc`: Specifies the filesystem type as the *proc* virtual filesystem.
 - `proc`: The source since *proc* is virtual, no physical device is used.
 - `/proc`: The mount point where the filesystem will be attached in the chroot isolated root filesystem.

**Why do we need to mount the /proc filesystem?**

Mounting the */proc* filesystem inside the chroot environment is necessary because the */proc* virtual filesystem is a critical component (or) feature that is information about the system and process provided by the Linux kernel to the user-space apps and tools. Without it, many user-space apps and tools (e.g; `ps`, `top`) that rely on `/proc` will not work properly.

For example, the `ps` tool will not work properly.

```sh
$ ps aux
```

Output:
```sh
# Error: Could not read /proc/stat
```

Read more details about the */proc* virtual filesystem in **the next section**.

### The /proc Virtual Filesystem

The *proc* filesystem (often referred to as `/proc`) is a **Virtual Filesystem (VFS)** also known as a Pseudo (or) Special Filesystem on Linux that provides a way to expose system and process information to users and user-space applications in a structured, file-like format by the Linux kernel.

That does not rely on physical storage devices, such as HDDs and SSDs. The files and directories in `/proc` are not stored on disk and exist only in memory, and are generated on-the-fly (or) exposed dynamically by the Linux kernel when the system is booted.

Key Features of the */proc* Filesystem:

 - (1) Virtual and Dynamic:
    - The files and directories in `/proc` are generated dynamically by the Linux kernel.
    - The files and directories in `/proc` don't exist on disk; they are created in memory when read.

 - (2) System and Process Information:
    - /proc provides the detailed information about:
      - Running processes (e.g; `/proc/[PID]` for each process).
      - System hardware (e.g; CPU: `/proc/cpuinfo`, Memory: `cat /proc/meminfo`)
      - Kernel configuration and runtime parameters.

 - (3) Readable and Writable:
    - Most files in `/proc` are readable (e.g; you can cat `/proc/cpuinfo`).
    - Some files are writable, allowing you to modify kernel parameters at runtime (e.g; `/proc/sys`).

After you run the `mount -t proc proc /proc` command inside the container, you can test the following commands.

 - `cat /etc/os-release`: To check the running container's Linux distribution.

 - `cat /proc/version`: To check the Linux kernel version that is shared from the Host OS.

 - `cat /proc/cpuinfo`: To check the CPU information that is shared from the Host OS.

 - `cat /proc/meminfo`: To check the Memory information that is shared from the Host OS.

 - `ps aux`: To check all processes that are running inside the container.

 - `ip addr show`: To see all IP addresses inside the currently running container.

For example,

```sh
/ # cat /etc/os-release
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.21.3
PRETTY_NAME="Alpine Linux v3.21"
HOME_URL="https://alpinelinux.org/"
BUG_REPORT_URL="https://gitlab.alpinelinux.org/alpine/aports/-/issues"
```

```sh
/ # cat /proc/version
Linux version 6.13.5-200.fc41.x86_64 (mockbuild@be03da54f8364b379359fe70f52a8f23) (gcc (GCC) 14.2.1 20250110 (Red Hat 14.2.1-7), GNU ld version 2.43.1-5.fc41) #1 SMP PREEMPT_DYNAMIC Thu Feb 27 15:07:31 UTC 2025
```

```sh
/ # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 142
model name      : Intel(R) Core(TM) i7-8565U CPU @ 1.80GHz
stepping        : 12
microcode       : 0xfc
cpu MHz         : 2900.231
cache size      : 8192 KB
...
```

```sh
/ # cat /proc/meminfo
MemTotal:       16210104 kB
MemFree:         3241444 kB
MemAvailable:    9901900 kB
Buffers:            5496 kB
Cached:          7888196 kB
...
```

Then, you will notice that **the Alpine Linux container is using the Host OS kernel**, Fedora Linux, with the kernel version `6.13.5-200.fc41.x86_64` that is shared from the Host OS. And also shared CPU and Memory from the Host machine.

Then, we wil test the currently running processes and IP addresses inside the container like this.

```sh
/ # ps aux
PID   USER     TIME  COMMAND
    1 root      0:05 /usr/lib/systemd/systemd --switched-root --system --deserialize=51 rhgb
    2 root      0:00 [kthreadd]
    3 root      0:00 [pool_workqueue_]
    4 root      0:00 [kworker/R-rcu_g]
    5 root      0:00 [kworker/R-sync_]
    6 root      0:00 [kworker/R-slub_]
    7 root      0:00 [kworker/R-netns]
    9 root      0:00 [kworker/0:0H-ev]
   12 root      0:00 [kworker/R-mm_pe]
   14 root      0:00 [rcu_tasks_kthre]
   15 root      0:00 [rcu_tasks_rude_]
   16 root      0:00 [rcu_tasks_trace]
   17 root      0:16 [ksoftirqd/0]
   18 root      0:10 [rcu_preempt]
   19 root      0:00 [rcu_exp_par_gp_]
   20 root      0:00 [rcu_exp_gp_kthr]
...
```

```sh
/ # ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: wlo1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether fa:8b:5b:09:59:51 brd ff:ff:ff:ff:ff:ff
    inet 192.168.55.127/24 brd 192.168.55.255 scope global dynamic noprefixroute wlo1
       valid_lft 75600sec preferred_lft 75600sec
    inet6 fe80::fa24:a316:4e60:c881/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
...
```

In that time, you will notice that we will see all processes and network interfaces of the Host OS, Fedora Linux, from the chroot Alpine Linux container. It means that we have not isolated the process ID (PID) and network.

In **the next section**, we will learn how [Linux namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html) work and how to use the [unshare](https://man7.org/linux/man-pages/man1/unshare.1.html) user-space client tool to interact with *Linux namespaces* to start a process in a namespace that isolates the process ID (PID), mount, IPC, network, and so on.

## Linux Namespaces

### Introduction to Linux Namesapces

[Linux namespaces](https://man7.org/linux/man-pages/man7/namespaces.7.html) are a feature of the Linux kernel that isolates and virtualizes system resources for a collection of processes. Namespaces have been released in the Linux kernel version 2.4.19 since 2002.

Namespaces are the foundation of modern Containerization technologies, such as *Docker* and *Podman*. Namespaces enable multiple processes to have different views of the system, such as different process IDs, network interfaces, filesystems, and so on.

Documentation: [https://man7.org/linux/man-pages/man7/namespaces.7.html](https://man7.org/linux/man-pages/man7/namespaces.7.html)

Types of Linux Namespaces:

| Namespace                         | Manual Page | Isolates |
|-----------------------------------|-------------|----------|
| PID (Process ID)                  | [pid_namespaces](https://man7.org/linux/man-pages/man7/pid_namespaces.7.html) | Isolates process IDs. |
| Mount                             | [mount_namespaces](https://man7.org/linux/man-pages/man7/mount_namespaces.7.html) | Isolates the set of mounted filesystems. |
| UTS (UNIX Timesharing System)     | [uts_namespaces](https://man7.org/linux/man-pages/man7/uts_namespaces.7.html) | Isolates hostname and DNS name. |
| IPC (Inter-process Communication) | [ipc_namespaces](https://man7.org/linux/man-pages/man7/ipc_namespaces.7.html) | Isolates IPC resources, such as message queue and shared memory. |
| Network                           | [network_namespaces](https://man7.org/linux/man-pages/man7/network_namespaces.7.html) | Isolates network interfaces, IP addresses, routing tables, and port numbers. |
| User                              | [user_namespaces](https://man7.org/linux/man-pages/man7/user_namespaces.7.html) | Isolates user and group IDs. |
| CGroup          | [cgroup_namespaces](https://man7.org/linux/man-pages/man7/cgroup_namespaces.7.html) | Isolates the view of Control Groups (CGroups). |

### How Linux Namespaces Work

The Namespaces API supported the following system calls and Namespaces are created using these system calls.

 - `clone()` Creates a new process in a new namespace.

 - `unshare()` Creates (or) moves the calling process to a new namespace.

 - `setns()` Allows a process to join an existing namespace.

**Example Use Cases**

Consider a Container running on a Linux Host machine:

 - *The container has its own Mount namespaces*, So it can have its own root filesystem that is isolated from the Host OS.

 - *The container has its own UTS namespaces*, So it can have its own hostname that is isolated from the Host OS.

 - *The container has its own PID namespaces*, So processes inside the container have its own PIDs that are isolated from the Host OS.

 - *The container has its own Network namespaces*, So it can have its own IP addresses and network interfaces that are isolated from the Host OS.









