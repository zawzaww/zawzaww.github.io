---
layout: post
title: Speeding Up Linux Kernel Builds with Compiler Cache (Ccache)
author: zawzaw
categories: [ Linux ]
toc: true
image: assets/images/featured-images/img_speedup_linux_kernel_builds.png
---

This article will focus on how to set up and build Linux kernel compilation time faster than usual using Cache (Compiler Cache).
Normally, it takes about 30mins to compile the Linux kernel on my laptop with a low CPU. That makes it very inconvenient.
This problem can be solved with Ccache. Compiling with Ccache speeds up to 3-5 mins.

## What is Ccache?

[Ccache (Compiler Cache)](https://ccache.dev/) is used to speed up compilation time when compiling C, C ++, Objective-C and Objective-C ++ code.

## Installation and Setup Ccache

First of all, you need to have the Ccache package installed on your GNU/Linux machine.

If you want to check the Ccache version you have installed:

```sh
ccache --version
```

You can install on Debian-based Linux system if not already installed Ccache:

```sh
sudo apt install ccache
```
Specify the maximum size of the cache cache.

For example:

```sh
ccache -M 32
```

![Screenshot](/assets/images/screenshots/img_screenshot_ccache_max_size.png)

To view your current ccache statistics, type the `ccache -s` command.

```sh
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

```sh
make clean && make mrproper
```

![Screenshot](/assets/images/screenshots/img_screenshot_make_clean.png)

The next step is to configure the kernel before compiling the Linux kernel. I used the default configuration as an example.

```sh
make defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_make_defconfig.png)

To compile the Linux kernel with Ccache, you will need to add the `CC="ccache gcc"` option with the make command.

```sh
make CC="ccache gcc" -j$(nproc --all)
```

If you want to know the exact compilation time result, you need to use the time command.

```sh
time make CC="ccache gcc" -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_time_make_cc.png)
![Screenshot](/assets/images/screenshots/img_screenshot_kernel_compile_time.png)

Final compilation time:
```sh
real     4m18.145s
user     5m20.449s
sys      3m50.917s
```

