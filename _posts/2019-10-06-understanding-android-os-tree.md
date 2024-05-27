---
layout: post
title: "Understanding the Android OS Source tree"
author: zawzaw
categories: [Android]
toc: true
image: assets/images/featured-images/img_understand_android_os.png
---

Android OS is a free and open-source project, and you can get Android OS Source Code from AOSP (Android Open Source Project). Android OS Source Code has many related directories. In other words, git repostories from each directory under that Android OS Main source code. In AOSP, many of these Git repositories are maintained from above with a tool called "repo". The repo was developed by Google and can be found at https://source.android.com/setup/develop#repo. The concept of repo means that there are many git repositories in Android OS, so if you want to download a lot of them, you will not be able to gone clone each one. You can download the code. This is just an example. You can read more about repo commands at https://source.android.com/setup/develop/repo So if you are going to download the Android OS source code, you must know Google's repo. This blog post will focus on the description of the relevant directories of the Androdi OS source tree.

First of all, you can check our Android OS source code at AOSP Git repositories: https://android.googlesource.com You can read more about how to download the entire Android OS source code in the [Downloading and Compiling PureAOSP](https://zawzaww.github.io/posts/build-pure-android) blog post.

![Screenshot](/assets/images/screenshots/img_screenshot_aosp_googlegit.png)

Also, if you are unfamiliar with Google Git, you can find AOSP repositories on GitHub as a mirror.

AOSP mirror repositories on GitHub: https://github.com/aosp-mirror

![Screenshot](/assets/images/screenshots/img_screenshot_aosp_mirror_github.png)


```android-platform/art``` ART [(Android Runtime)](https://source.android.com/devices/tech/dalvik) is an Application Runtime environment that replaces Dalvik VM. It was replaced in Android 5.0. ART focuses on translating native instructions from the app's bytecode.

```android-platform/bionic``` Standard C library developed exclusively for Android OS by Google. bionic's original goal was due to a license issue with the GNU C Library (glibc), and bionic was smaller and faster than the glibc, specifically for Android mobile devices.

```android-platform/bootable``` Contains Bootloader and Android bootable recovery source code. On Android OS, you can rebuild a custom recovery from those AOSP bootable recovery source code.

```android-platform/build``` This is where the build system of the Android OS. Mainly used to build Android custom firmware and Android system images from source code.

```android-platform/developers``` Contains docs, demos and samples for Android for developers.

```android-platform/development``` Contains platform development tools and sample code for Android development.

```android-platform/device``` When you build an Android custom firmware, you define a hardware and device-specific configuration called the Device tree for the device you want to build.

```android-platform/external``` Various other external projects are imported into AOSP. E.g - f2fs tools, ext4, lz4, fonts, llvm and etc ..

```android-platform/frameworks``` Contains most of Android's Android Core framework Components and Services, Java Android application API framework. frameworks/support includes the built-in Android support libraries for Android, commonly used by Android software developers.

```android-platform/hardware``` Most include Hardware Abstraction Layer (HAL) and Hardware support libraries. Includes camera modules for Camera / Audio / Graphics.

```android-platform/kernel``` This is where the kernel sources come in for Android devices to build. You can also use kernel source code or prebuilt kernel img.

```android-platform/ndk``` Android app developers can write Android Apps with Native code C / C ++ using the Android Native Development Kit (NDK).

```android-platform/packages``` Includes built-in Android system apps. E.g - Calculator, Camera2, Calendar, Dialer, FMRadio, Gallery2, Launcher3, Music, Settings and etc ..

```android-platform/prebuilts``` Host computer operating systems, such as Linux and Mac, include Toochains / Compilers to compile the kernel and Android Custom Firmware / ROM from the Android SourceCode for the respective Android devices from Android SourceCode. E.g - GCC, LLVM / Clang

```android-platform/sdk``` The Android Software Development Kit (SDK) is a well-known software development kit essential for writing Android apps.

```android-platform/system``` At the heart of Android is the Minimal Linux system, which is primarily used to boot Android.

```android-platform/tools``` Includes various Android IDEs and Tools. E.g - Android Studio

Here is an overview of directories in the Android OS source tree and an overview.
