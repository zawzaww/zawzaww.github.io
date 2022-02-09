---
layout: post
title: "Make Build System in Android OS"
author: "Zaw Zaw"
categories: [Android]
tags: [android, make, build]
image:
  src: /assets/images/featured-images/img_make_build_android.png
---

The main build system used in Android OS-level is [Make Build System](https://android.googlesource.com/platform/build) and [AOSP (Android Open Source Project)](https://android.googlesource.com) handles all building processes with Make build. Android uses Make build system to compile the entire Android system. By now, every Android app developer is familiar with Gradle, a build system for building apps in Android Studio. Gradle build is easier to use. Make build is a native build system used on Android OS-level, and writing can be very tricky. But on Android OS-level, mainly use Makfile-based build system, so I have to learn.

Therefore, if you want to add an Android app project source built with Gradle in Android Studio into the Android OS source code, you can not do so. This is because Android OS's build system is not Gradle. To compile an Android app, you need to write Makefile flags that match the Make build system of a low-level Android OS. In other words, you need to write Android.mk, which is standard in AOSP. Google also introduced the [Soong Build system] (https://android.googlesource.com/platform/build/soong) written by Go in Google. I think the later Old Makefile-based Build System [Deprecation of Make] (https://android.googlesource.com/platform/build/+/refs/heads/master/Deprecation.md) was supposed to be completely replaced by Soong. Soong uses the Android.bp (Blueprint) format instead of the Android.mk (Makefile) format.

In this blog post I will talk about writing Makefile flags for Build automation with Make for an Android system app.

## Writing Makefiles

For example, for an Android app project called DeskClock in AOSP, you can first look at the Android.mk syntax as an example.

https://android.googlesource.com/platform/packages/apps/DeskClock/+/refs/tags/android-9.0.0_r47/Android.mk

The app project structure is the same as the dir structure below `app/src/main` in Android Studio. There is one more file called Android.mk. In Android.mk you need to write Makefile configuration for an app project.

Example: `AOSP/packages/apps/AudioWaveMaker`

```
 - cpp
 - java
 - res
 - AndroidManifest.xml
 - Android.mk
```

First of all, find out which Android support libraries and other Android libraries your Android app project uses. You need to configure your libraries in Android.mk. As an example, my AudioWaveMaker Android app defines the following Android support libraries:

```mk
LOCAL_STATIC_ANDROID_LIBRARIES += \
     android-support-annotations \
     android-support-v4 \
     android-support-design \
     android-support-v7-appcompat \
     android-support-v17-leanback
```

Next, you need to link the resource dirs used in your Android app project.

```mk
LOCAL_PATH:= $(call my-dir)

LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
```

```mk
LOCAL_RESOURCE_DIR += \
    frameworks/support/design/res \
    frameworks/support/v7/appcompat/res \
    frameworks/support/v17/leanback/res
```

Define the package name of your app. This Package Name refers to the Package Name to be added under `/system`. To be clear, once you have compiled an Android system img, you will see your app package as `/system/priv-app/AudioWaveMaker`.

```mk
LOCAL_PACKAGE_NAME := AudioWaveMaker
```

If you want to put your Android app under `/system/priv-app/` you need to use this Makefile flag.

```mk
LOCAL_PRIVILEGED_MODULE := true
```

Another important Makefile flag is to specify that your Android app is a Platform certificate. Only then will it be seen as a system-level app.

```mk
LOCAL_CERTIFICATE := platform
```

You can also configure SDK version and Minimal SDK version just like in Gradle.

```mk
LOCAL_MIN_SDK_VERSION := 21
LOCAL_SDK_VERSION := current
```

You need to retrieve the Java files (or) Kotlin files written in the app. The meaning of this Makefile flag is to fetch the java files under the Project root directory / java package.

```mk
LOCAL_SRC_FILES := $(call all-java-files-under, java)
```

If your Android app is running Android NDK, C/C ++, you also need to define the JNI libary module name under that cpp dir. (Example: native-lib)

```mk
LOCAL_JNI_SHARED_LIBRARIES := native-lib
```

Finally, after defining the required Makfile flags above, the app must be built from the source code, so add `include $(BUILD_PACKAGE)` at the bottom.

```mk
include $(BUILD_PACKAGE)
```

If there are other Makefiles under your Local path, you must add `include $(call all-makefiles-under, $(LOCAL_PATH))` at the bottom to invoke them.

```mk
include $(call all-makefiles-under, $(LOCAL_PATH))
```

AudioWaveMaker Android app's Android.mk

<script src="https://gist.github.com/zawzaww/5593df85c5d93392e2cb0345d7e3b329.js"></script>

## Add Product Packages

Once you have written the Android.mk file for the app, you need to add the PRODUCT_PACKAGES of the Android app to the Makefile of the device tree where you are going to have lunch. This is because if you add the app PRODUCT_PACKAGES to that lunch target device, the Build system will be able to compile your android app package under `packages/apps/`.

Example: for Nexus 5X: `Android-OS/device/lge/bullhead/bullhead.mk`

```mk
PRODUCT_PACKAGES += \
    AudioWaveMaker
```

## Compile Android sytstem img with Make

Once you have written the Android.mk file for build the app, you need to add the `PRODUCT_PACKAGES` of the Android app to the Makefile of the device tree where you are going to have lunch. This is because if you add the app `PRODUCT_PACKAGES` to that lunch target device, the Make Build system will be able to compile your android app package under `packages/apps/`.

Example: for build AudioWaveMaker app project

```sh
. build/envsetup.sh
lunch target_android_device
```

```sh
mma AudioWaveMaker -j$(nproc --all)
```

Once that step is complete, you can recompile the entire Android system with Make build system.

```sh
make -j$(nproc --all)
```

Compilation time depends on the CPU core of your computer.

Reference Links:
- [https://android.googlesource.com/platform/build](https://android.googlesource.com/platform/build)
- [https://android.googlesource.com/platform/build/soong](https://android.googlesource.com/platform/build/soong)
- [https://android.googlesource.com/platform/packages/apps](https://android.googlesource.com/platform/packages/apps)
