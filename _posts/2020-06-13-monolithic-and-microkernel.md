---
layout: post
title: "Kernel Design: Monolithic Vs Microkernel"
author: "Zaw Zaw"
categories: [Linux]
tags: [kernel, monolithic, microkernel]
image:
  src: /assets/images/featured-images/img_monolithic_microkernel.png
---

This article is based on the Origin Thread of the 1992 Tanenbaum-Torvalds debate. We will focus on the differences between the monolithic kernel design and the microkernel design commonly used in kernel design. Let me first briefly talk about the Tanenbaum-Torvalds debate. After that, we will talk about the differences between the Monolithic kernel and the microkernel, one by one.

## Tanenbaum-Torvalds Debate

The Tanenbaum-Torvalds debate has been around for a long time, and it has been known for a long time that I was able to find it by looking at [Wikipedia](https://en.wikipedia.org/wiki/Tanenbaum%E2%80%93Torvalds_debate). However, [MINIX Operating System Discussion Group (comp.os.minix)](https://groups.google.com/g/comp.os.minix) has just started to read the original thread that was actually debated. Mr. Tanenbaum wrote the CS Textbook [Operating Systems Design and Implementation](https://www.amazon.com/Operating-Systems-Design-Implementation-3rd/dp/0131429388). In other words, it is a good CS Textbook on Operating System / Kernel Design and MINIX. At the [Vrije Universiteit Amsterdam](https://www.vu.nl/en) University, Professor Tanenbaum built his own MINIX operating system to exemplify not only the text in the textbook but also the textbook is to teach students how Operating System works. It's really admirable. As it will be used for teaching and learning, I think the MINIX operating system is based on the tiny Microkernel and aims to make it easier for students to learn about Operating Systems with a few small code lines.

The Tanenbaum-Torvalds debate was introduced in 1992 by Andrew S. Tanenbaum, Origin Author of the MINIX Operating System (also known as ast) in the MINIX System Discussion Group with [LINUX is obsolete](https://groups.google.com/g/comp.os.minix/c/wlhw16QWltI) subject. In short, they debate the monolithic kernel and the microkernel, the kernel design. In other words, MINIX vs LINUX was a Flame War in the MINIX Operating System Discussion Group with Professor vs Torvalds and his Linux Kernel Developers. I do not want to talk about who is right and who is wrong in the Tenenbaum-Torvalds debate. This article aims to highlight the different strengths and weaknesses of the two kernel designs. If you have basic knowledge of Operating System / Kernel, join the Origin Thread and consider for yourself. If you are interested, you can read more on Google Groups Thread.

Read Origin Thread on Google Groups: [LINUX is obsolete](https://groups.google.com/g/comp.os.minix/c/wlhw16QWltI)

![Screenshot](/assets/images/screenshots/img_screenshot_ast_torvalds_debate.png)

## Kernel Designs

Both monolithic kernel and microkernel design have advantages and disadvantages. Nothing is perfect. There are always strengths and weaknesses in place. Monolithic kernel design has been around for a long time and can be said to be an old kernel design. The microkernel is a modern kernel design. I do not want to say which kernel design is better or worse. It just tells the difference between the two kernel designs. His place is good. The three most commonly used kernel designs are the monolithic kernel, the microkernel, and the hybrid kernel. Hybrid kernel design is cool. It is a kernel design that combines the advantages of both monolithic and microkernel design. Apple's Operating Systems (macOS, iOS, The XNU kernel used in watchOS, tvOS) is an operating system based on a hybrid kernel design. As I'm studying the development of the Linux kernel type, the monolithic kernel, I will continue to talk about the differences between the monolithic kernel and the microkernel.

## Kernel Design: Monolithic

![Screenshot](/assets/images/screenshots/img_screenshot_monolithic.png)

### Pros of Monolithic kernel

- Monolithic kernels support the Loadable Kernel Module (LKM). Device drivers can be written as modules. You can dynamically load / unload (add / remove) kernel modules in the kernel runtime as needed. So "Linux is modular." You may have seen it.

- Portability on Linux (monilithic kernel) This means that the monolithic kernel based OS can also run the Intel x86 architecture. It also works on another architecture, ARM arm64. Other architectures, such as mips, powerpc, m68k, m68k, alpha, arm, hexagon, etc., are said to have portability if an OS supports a wide range of computer system architectures. The Portability System, also known as the Operating System Kernel World, is the name given to the ability to easily port Portable C code from one computer system architecture to another system architecture. For Linux, the supported architectures can be found under the `/linux/arch` directory of the Linux kernel source tree.

```
zawzaw@ubuntu-linux:~/Linux-Kernel/linux/arch $ ls -l
total 132
drwxr-xr-x 10 zawzaw zawzaw  4096 Feb  8 15:17 alpha
drwxr-xr-x 14 zawzaw zawzaw  4096 Jun  5 10:49 arc
drwxr-xr-x 96 zawzaw zawzaw  4096 Jun 11 07:47 arm
drwxr-xr-x 12 zawzaw zawzaw  4096 Jun 12 11:19 arm64
drwxr-xr-x  9 zawzaw zawzaw  4096 Jun 11 07:47 c6x
drwxr-xr-x 10 zawzaw zawzaw  4096 May 18 13:28 csky
drwxr-xr-x  8 zawzaw zawzaw  4096 Jun 11 07:47 h8300
drwxr-xr-x  7 zawzaw zawzaw  4096 Jun  8 20:44 hexagon
drwxr-xr-x 12 zawzaw zawzaw  4096 Jun  8 20:44 ia64
-rw-rw-r--  1 zawzaw zawzaw 29429 Jun 11 07:47 Kconfig
drwxr-xr-x 25 zawzaw zawzaw  4096 Jun 11 07:47 m68k
drwxr-xr-x 10 zawzaw zawzaw  4096 Jun  4 14:36 microblaze
drwxr-xr-x 51 zawzaw zawzaw  4096 Jun 13 07:46 mips
drwxr-xr-x  9 zawzaw zawzaw  4096 Feb  8 15:17 nds32
drwxr-xr-x  9 zawzaw zawzaw  4096 May 18 13:28 nios2
drwxr-xr-x  8 zawzaw zawzaw  4096 May 18 13:28 openrisc
drwxr-xr-x 10 zawzaw zawzaw  4096 Jun  8 20:44 parisc
drwxr-xr-x 20 zawzaw zawzaw  4096 Jun  6 07:26 powerpc
drwxr-xr-x  9 zawzaw zawzaw  4096 Jun 12 11:19 riscv
drwxr-xr-x 19 zawzaw zawzaw  4096 Jun  5 10:49 s390
drwxr-xr-x 14 zawzaw zawzaw  4096 Jun  8 20:44 sh
drwxr-xr-x 15 zawzaw zawzaw  4096 Jun  4 14:36 sparc
drwxr-xr-x 8 zawzaw zawzaw 4096 Jun 8 20:44 um
drwxr-xr-x  8 zawzaw zawzaw  4096 Jun 11 07:47 unicore32
drwxr-xr-x 27 zawzaw zawzaw  4096 Jun 13 07:46 x86
drwxr-xr-x 11 zawzaw zawzaw  4096 May 18 13:28 xtensa
```

- Monolithic kernels run the services of the entire operating system (OS) within the kernel-space. This means that Device Drivers, I / O, File Systems, IPC, Process Scheduling, Process Management, Memory Management, etc. all work within the kernel-space. In the user-space there will only be Applications and Libraries: C Library (libc) / GNU C Library (glibc). As you can see in the image above, in Kernel mode, the core OS of the entire operating system is running. You can see that only applications run in user mode.

- Monolithic kernels run on a single large process in the same single address space. It works. This means that all of the OS services such as Device Drivers, I / O, File Systems, IPC, Process Scheduling, and Memory Management all run in a single large process.

- It has an advantage in terms of performance. This is because any function in the kernel-space can be directly invoked by the monolithic kernel without having to wait for the kernel's permission. Execution time is faster because it can directly invoke functions without having to wait for the kernel permission, like the microkernel. So it is better in terms of performance.

- Monolithic kernels only output a single static binary file.

- Monolithic kernels can be said to be "Easy to Code". When a programmer writes a kernel device driver / kernel module or feature, monolithic kernels are less coded and easier to write. This is because the kernel framework and APIs are already implemented in the kernel-space. For example: Writing Linux kernel drivers is like writing an app on Android. The Android OS platform supports the Java API framework (eg: Activity Manager, Window Manager, Package Manager, Resource Manager, Content Providers, etc.). It looks like it was called from the app. You do not have to write everything yourself. The same thing applies with Linux (monolithic) kernel drivers.

### Cons of Monolithic kernel

- The downside is that all the services of the entire operating system run in the same single process, so once a service fails, the entire operating system crashes.

- Monolithic kernels have a very large kernel size compared to the microkernel, as all important operating system servers run on the same kernel-sapce.

## Kernel Design: Microkernel

![Screenshot](/assets/images/screenshots/img_screenshot_microkernel.png)

### Pros of Microkernel

- The microkernel is the opposite of the monolithic kernel design. Like the Basic Memory Management and IPC (Inter Process Communication), only Bare Manimum works in the kernel-space. The rest is in user-space.

- Microkernels do not run from the kernel to the user-space, but through the servers that provide the services in the user-space.

- In the microkernel, the user-space mentioned above serves the services provided by the intermediate servers in different address spaces. The good news is that when a service fails because the services are split, the entire operating system does not crash like Monolithic.

- Microkernels are bare manimum code in the kernel-space, so the kernel size is small.

### Cons of Microkernel

- In a microkernel, it can be a lot harder than a monolithic kernel if a programmer is writing code to implement a feature or kernel device driver. You have to write a lot of code.

- Microkernels are not very good at performance. Microkernels can be up to 50% slower in performance than monolithic kernels. Because each server works separately. Execution time is longer because one server invites a service or function from another server because it requires kernel permission. Not being able to directly invoke a function, such as a monolithic kernel, can be ineffective in terms of performance. Therefore, it can be said that it is not as good in performance as the Monolithic kernel.

Currently, for example, operating systems based on the monolithic kernel and microkernel are visible. For example, UNIX and Linux are monolithic kernel types. MINIX is a microkernel type. Android OS is a monolithic kernel type as it is a Linux kernel based Mobile OS. Google's next mobile operating system, Fuchsia OS, is based on the microkernel Zircon.
