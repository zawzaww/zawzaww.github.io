---
layout: post
title: "Building Linux Kernel with Clang/LLVM"
categories: [Linux]
tags: [linux, kernel, clang, llvm]
author: "Zaw Zaw"
image:
  src: /assets/images/featured-images/img_clang_llvm_linux.png
  description: "Photo: Clang Logo by LLVM Project"
---

GCC is the Traditional Default C Compiler used in the Linux kernel back then and now. Now you can easily compile the Linux kernel with [Clang/LLVM](http://clang.llvm.org/) , a modern C-family compiler. [Nick Desaulniers](http://nickdesaulniers.github.io/about/) , a software engineer at Google, is contributing to the [Linux kernel build system (kbuild)](https://patchwork.kernel.org/project/linux-kbuild/list/) by submitting and contributing kernel patches. The [official documentation](https://www.kernel.org/doc/html/latest/kbuild/llvm.html) for the Linux kernel now covers how to compile Clang and the Linux kernel. And [ClangBuiltLinux](https://github.com/ClangBuiltLinux) GitHub organization created by Nick and Contributors on GitHub. You can also report Clang/LLVM compiler bugs and kernel build errors on GitHub. This article will show you how to compile a Linux kernel with the Clang/LLVM compiler.

ClangBuiltLinux Wiki: [https://github.com/ClangBuiltLinux/linux/wiki](https://github.com/ClangBuiltLinux/linux/wiki)

## Installation Toolchains

If you have not already installed, you can install it on Linux system. This may vary depending on the package manager used in Linux distributions.
Let me give you an example with Ubuntu Linux.

Clang/LLVM toolchain packages:

```bash
sudo apt install llvm clang clang-tools
```

You need to install the GNU GCC Prebuilt aarch64 packages for cross compiling.

Cross Compile for Linux aarch64 architecture packages:

```bash
sudo apt install binutils-aarch64-linux-gnu
```

```bash
sudo apt install gcc-aarch64-linux-gnu
```

## Compiling for Host System

Compiling the Linux kernel for your Host Linux Systems with Clang/LLVM is not very difficult, just compile it with  `CC=clang` command line parameter.

You must first configure the kernel before compiling. Use the default configuration. These kernel configs are located under `arch/<arch>/configs` in the Linux kernel source tree.

For example: x86 architecture

```bash
zawzaw@ubuntu-linux:~/Linux-Kernel/linux-stable/arch/x86/configs$ ls -l
total 24
-rw-rw-r-- 1 zawzaw zawzaw 6841 May 23 14:03 i386_defconfig
-rw-r--r-- 1 zawzaw zawzaw  147 Feb  8 15:20 tiny.config
-rw-rw-r-- 1 zawzaw zawzaw 6834 May 23 14:03 x86_64_defconfig
-rw-r--r-- 1 zawzaw zawzaw  744 Feb  8 15:20 xen.config

```

Let's do a kernel configuration using the Default Kernel Configuration. For Clang/LLVM it is necessary to add `CC=clang` command line parameter.

```bash
make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_host_make_defconfig.png)

Once you have configured kernel with make, you can access the kernel configuration you created in the ".config" directory under the root directory of the Linux kernel source tree before compiling the kernel.

![Screenshot](/assets/images/screenshots/img_screenshot_host_kernel_configs.png)

When done, compile the kernel. Here you need to add the `CC=clang` command line parameter.

The `-j $(nproc --all)` option is not required here. It is recommended to add. It can perform parallel tasks with GNU Make `make` argument `-jN` argument. Helps to build faster. "N" stands for Number of Parallel tasks. Since it is calculated and built based on the CPU cores of your computer, it does not need to be manually defaced as `j4` `j8` `j16` etc., so it automatically builds the CPU Processor Cores using `nproc` utility.

```bash
make CC=clang -j $(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_host_make_build.png)

The kernel img you created will be generated in `arch/x86/boot/bzImage` of the Linux kernel source tree.

![Screenshot](/assets/images/screenshots/img_screenshot_host_kernel_img.png)

## Cross Compiling for ARM arm64

In this section, Cross Compiling will be done for the ARM arm64 architecutre, not for the host system. To compile the ARM arm64 architecture, you need to add two command line parameters: `ARCH=arm64` and `CROSS_COMPILE=aarch64-linux-gnu-`. The rest of the kernel compilation process is the same as the host system.

Kernel configuration for ARM arm64 architecture. This step is required before compiling the kernel.

```bash
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_make_defconfig.png)

The created kernel configuration can be found in `.config` under the Root Directory of the Linux kernel source tree.

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_kernel_configs.png)

Once configured, you can now compile the kernel.

```bash
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_make_build.png)

The kernel img will be generated by the Kernel Build System in `arch/arm64/boot/Image.gz` of the Linux kernel source tree.

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_kernel_img.png)

Here's how to compile Linux kernel code with the Clang/LLVM Compiler, a modern C-family compiler. Steps compiling the Linux kernel are no longer as complicated as earlier kernel versions, but are now simpler.

REF Links:

[https://www.kernel.org/doc/html/latest/kbuild/llvm.html](https://www.kernel.org/doc/html/latest/kbuild/llvm.html)

[https://github.com/ClangBuiltLinux/linux/wiki](https://github.com/ClangBuiltLinux/linux/wiki)
