---
layout: post
title: "Speeding Up Linux Kernel Builds with Compiler Cache"
author: "Zaw Zaw"
categories: [Linux]
tags: [linux, kernel, ccache]
pin: true
image:
  src: /assets/images/featured-images/img_speedup_linux_kernel_builds.png
---

This article will focus on how to set up and build Linux kernel compilation time faster than usual using Cache (Compiler Cache). Normally, it takes about 30mins to compile the Linux kernel on my laptop with a low CPU. That makes it very inconvenient. This problem can be solved with Ccache. Compiling with Ccache speeds up to 3-5 mins.

## What is Ccache?

[Ccache (Compiler Cache)](https://ccache.dev/) is used to speed up compilation time when compiling C, C ++, Objective-C and Objective-C ++ code.

## Installation and Setup Ccache

First of all, you need to have the Ccache package installed on your GNU/Linux machine.
If you want to check the Ccache version you have installed

```bash
ccache --version
```

You can check if not already installed.

```bash
sudo apt install ccache
```

You can install it on Ubuntu Linux.

Next you need to open the .bashrc file and set it up.
Export the dache path to ccache. Add it to the following .bashrc file.

```bash
export CCACHE_DIR="/home/zawzaw/.cache"
export CXX="ccache g++"
export CC="ccache gcc"
```

Specify the maximum size of the cache cache.

```bash
ccache -M 32
```

![Screenshot](/assets/images/screenshots/img_screenshot_ccache_max_size.png)

To view your current ccache statistics, type the command 'ccache -s'.

```bash
zawzaw@ubuntu-linux:~/Linux-kernel/linux-stable$ ccache -s
cache directory                     /home/zawzaw/.cache
primary config                      /home/zawzaw/.cache/ccache.conf
secondary config      (readonly)    /etc/ccache.conf
stats updated                       Fri Jul 26 15:53:23 2019
stats zeroed                        Fri Jul 26 15:02:19 2019
cache hit (direct)                  5139
cache hit (preprocessed)              24
cache miss                          2488
cache hit rate                     67.48 %
called for preprocessing              87
unsupported code directive            14
no input file                        804
cleanups performed                     0
files in cache                     80206
cache size                           2.5 GB
max cache size                      32.0 GB
```

## Building Linux Kernel with Ccache

Navigate to the Linux kernel source directory and clean the output files first.

```bash
make clean && make mrproper
```

![Screenshot](/assets/images/screenshots/img_screenshot_make_clean.png)

The next step is to configure the kernel before compiling the Linux kernel. I used the default configuration as an example.

```bash
make defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_make_defconfig.png)

To compile the Linux kernel with Ccache, you will need to add the `CC="ccache gcc"` option with the make command.

```bash
make CC="ccache gcc" -j$(nproc --all)
```

If you want to know the exact compilation time result, you need to use the time command.

```bash
time make CC="ccache gcc" -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_time_make_cc.png)

Final compilation time:

```
real     4m18.145s
user     5m20.449s
sys      3m50.917s
```

![Screenshot](/assets/images/screenshots/img_screenshot_kernel_compile_time.png)
