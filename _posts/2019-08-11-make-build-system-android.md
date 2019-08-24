---
layout: post
title: "Make Build System in Android"
categories: android
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_make_build_android.png
permalink: blog/android/make-build-system-android
---

Android OS-level ပိုင္းမွာ အဓိကသုံးတဲ့ Build System က [Make Build System](https://android.googlesource.com/platform/build) ျဖစ္ၿပီး [AOSP (Android Open Source Project)](https://android.googlesource.com/) မွာ Building process အားလုံးကို Make build နဲ႔ပဲ handle လုပ္ပါတယ္။ Android system တခုလုံးကို Compile လုပ္ဖို႔ေရာ Make build ကိုပဲ သုံးပါတယ္။  အခုခ်ိန္မွာ Android app developer တိုင္းက Android Studio မွာ  app build ဖို႔အတြက္ Build system တခု ျဖစ္တဲ့ Gradle ကိုေတာ့ ရင္းႏွီးၿပီးသားျဖစ္ပါတယ္။ Gradle build ကေတာ့ Easy to use ပိုျဖစ္တယ္လို႔ ဆိုႏိုင္ပါတယ္၊ Make build ကေတာ့ လုံး၀ Android ရဲ႕ OS-level မွာ သုံးတဲ့ native build system ျဖစ္ၿပီး ေရးရတာ လက္ေပါက္ကပ္တယ္လို႔ ဆိုႏိုင္ပါတယ္။ ဒါေပမယ့္ Android OS-level မွာေတာ့ Makfile-based build system ကိုပဲ အဓိကသုံးတဲ့အတြက္ ကြၽန္ေတာ့္အတြက္က မျဖစ္မေန ေလ့လာဖို႔လိုအပ္လာပါတယ္။

ဒါေၾကာင့္ Android Studio မွာ Gradle နဲ႔ build လုပ္ထားတဲ့ Android app project source တခုကို Android OS source code ထဲကို ထည့္ခ်င္တယ္အခါ ဒီအတိုင္း သြား Add လို႔ မရပါဘူး။ ဘာေၾကာင့္လဲဆိုေတာ့ Android OS's build system က Gradle မဟုတ္တဲ့အတြက္ေၾကာင့္ ျဖစ္ပါတယ္။ အဲဒီအတြက္ Android app တခု Compile လုပ္ဖို႔အတြက္ Low-level Android OS ရဲ႕ Make build system နဲ႔ ကိုက္ညီတဲ့ Makefile flags ေတြ ေရးေပးဖို႔လိုပါတယ္။ တနည္းအားျဖင့္ AOSP မွာ Standard အျဖစ္ သတ္မွတ္ထားတဲ့ Android.mk ကို မျဖစ္မေန ေရးေပးဖို႔ လိုအပ္ပါတယ္။ ေနာက္တခု သိထားရမွာက Go နဲ႔ ေရးထားတဲ့ [Soong Build system](https://android.googlesource.com/platform/build/soong) ကိုလည္း Google ကေန Introduce လုပ္ထားပါတယ္။ ကြၽန္ေတာ္အထင္ေတာ့ ေနာက္ပိုင္း Old Makefile-based Build System က [Deprecation of Make](https://android.googlesource.com/platform/build/+/refs/heads/master/Deprecation.md) ျဖစ္သြားၿပီး Soong နဲ႔ လုံး၀ အစားထိုးမယ့္ သေဘာမွာ ရွိေနပါတယ္။ Soong က Android.mk (Makefile) format အစား Android.bp (Blueprint) format ကို သုံးထားပါတယ္။

ဒီ Blog post မွာ Android system app တခုအတြက္ Make နဲ႔အတူ Build automation လုပ္ဖို႔ Makefile flags ေတြ ေရးတဲ့အေၾကာင္းကို ဆက္ေျပာသြားမွာျဖစ္ပါတယ္။

# Writing Makefiles
AOSP မွာ DeskClock ဆိုတဲ့ Android app project တခု အတြက္ Android.mk syntax ကို Example တခု အေနနဲ႔ အရင္ေလ့လာၾကည့္ႏိုင္ပါတယ္။

https://android.googlesource.com/platform/packages/apps/DeskClock/+/refs/tags/android-9.0.0_r47/Android.mk

App project structure ကေတာ့ Android Studio က app/src/min/ ေအာက္က dir structure အတိုင္းပဲ ျဖစ္ပါတယ္။ တခုပါပဲ Android.mk ဆိုတဲ့ file တခုေတာ့ ပိုသြားပါတယ္။ အဒီ Android.mk မွာ App project တခုအတြက္ Makefile configuration ေတြ ေရးေပးရမွာ ျဖစ္ပါတယ္။

Example: Android-OS/packages/apps/AudioWaveMaker

```
 - cpp
 - java
 - res
 - AndroidManifest.xml
 - Android.mk
```

ပထမဆုံး အေနနဲ႔ ကိုယ့္ Android app project က ဘယ္ Android support libraries ေတြနဲ႔ တျခား Android libraries ေတြ သုံးထားတယ္ဆိုတာ သိရပါတယ္။ ကိုယ့္သုံးထားတဲ့ libraries ေတြကို Android.mk မွာ Configure လုပ္ေပးဖို႔ လိုပါတယ္။ Example အေနနဲ႔ ကြၽန္ေတာ့္ရဲ႕ AudioWaveMaker ဆိုတဲ့ Android app မွာ ေအာက္ပါ Android support libraries ေတြသုံးထားပါတယ္ဆိုၿပီး Define လုပ္ထားပါတယ္။

```mk
LOCAL_STATIC_ANDROID_LIBRARIES += \
     android-support-annotations \
     android-support-v4 \
     android-support-design \
     android-support-v7-appcompat \
     android-support-v17-leanback
```

ေနာက္တခုကေတာ့ ကိုယ့္ Android app project မွာ သုံးထားတဲ့ resource dirs ေတြကို Link လုပ္ေပးဖို႔လိုပါတယ္။

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

ကိုယ့္ App ရဲ႕ Package Name ကို Define လုပ္ေပးရပါမယ္။ ဒီ Package Name က /system/ ေအာက္မွာ Add မယ့္ Package Name ကိုဆိုလိုတာ ျဖစ္ပါတယ္။ ျမင္သာေအာင္ေျပာရရင္ Android system img တခု Compile လုပ္ၿပီးသြားၿပီဆိုရင္ /system/priv-app/AudioWaveMaker ဆိုၿပီး ကိုယ့္ရဲ႕ app package ကို ျမင္ေတြ႕ရမွာ ျဖစ္ပါတယ္။

```mk
LOCAL_PACKAGE_NAME := AudioWaveMaker
```

တကယ္လို႔ ကိုယ့္ရဲ႕ Android app ကို /system/priv-app/ ေအာက္မွာ ထည့္ခ်င္တယ္ဆိုရင္ ဒီ Makefile flag ကို သုံးေပးဖို႔ လိုပါတယ္။

```mk
LOCAL_PRIVILEGED_MODULE := true
```

ေနာက္အေရးႀကီးတဲ့ Makefile flag တခုက ကိုယ့္ရဲ႕ Android app က Platform certificate ျဖစ္ေၾကာင္း Define လုပ္ေပးရပါမယ္။ ဒါမွသာ System-level app တခုအေနနဲ႔ ျမင္ေတြ႕ရမွာ ျဖစ္ပါတယ္။

```mk
LOCAL_CERTIFICATE := platform
```

ၿပီးတဲ့ေနာက္ SDK version ေတြ Minimal SDK version ေတြလည္း Gradle မွာလိုပဲ Define လုပ္ေပးႏိုင္ပါတယ္။

```mk
LOCAL_MIN_SDK_VERSION := 21
LOCAL_SDK_VERSION := current
```

App မွာ ေရးထားတဲ့ Java files (or) Kotlin files ေတြကို ေခၚေပးဖို႔ လိုအပ္ပါတယ္။ ဒီ Makefile flag ရဲ႕ သေဘာက Project root directory / java package ေအာက္က java files ေတြကို သြားေခၚမွာ ျဖစ္ပါတယ္။

```mk
LOCAL_SRC_FILES := $(call all-java-files-under, java)
```

တကယ္လို႔ ကိုယ္ရဲ႕ Android app မွာက Android NDK, C/C++ သုံးၿပီး ေရးထားတာဆိုရင္ အဲဒီ cpp dir ေအာက္က JNI libary module name ကိုလည္း Define လုပ္ေပးဖို႔ လိုအပ္ပါတယ္။ (Example: native-lib)

```mk
LOCAL_JNI_SHARED_LIBRARIES := native-lib
```

ေနာက္ဆုံးအေနနဲ႔ကေတာ့ အဲဒီအေပၚက မျဖစ္မေနလုပ္ရမယ့္ Makfile flags ေတြ Define လုပ္ၿပီးရင္ေတာ့ App က Source code ကေန Build လုပ္ရမွာ ျဖစ္တဲ့အတြက္ ေအာက္ဆုံးမွာ

```mk
include $(BUILD_PACKAGE)
```

ဆိုၿပီး ထည့္ေပးရပါမယ္။

တကယ္လို႔ ကိုယ့္ရဲ႕ Local path ေအာက္မွာ တျခား Makefiles ေတြ ရွိေနေသးရင္ ေခၚဖို႔အတြက္ ေအာက္ဆုံးမွာ

```mk
include $(call all-makefiles-under, $(LOCAL_PATH))
```

ဆိုၿပီး ထည့္ေပးရပါမယ္။

My AudioWaveMaker's Android.mk

<script src="https://gist.github.com/zawzaww/5593df85c5d93392e2cb0345d7e3b329.js"></script>

# Adding Product Packages
သက္ဆိုင္ရာ App အတြက္ Android.mk file ေရးၿပီးသြားၿပီ ဆိုရင္ ကိုယ္ lunch လုပ္မယ့္ device tree ရဲ႕ Makefile မွာ Android app ရဲ႕ PRODUCT_PACKAGES ကို ထည့္ေပးဖို႔လိုပါတယ္။ ဘာေၾကာင့္လဲဆိုေတာ့ အဲဒီ lunch လိုက္တဲ့ target device မွာ app ရဲ႕ PRODUCT_PACKAGES ကို add ထားမွ Build system က packages/apps/ ေအာက္က ကိုယ့္ရဲ႕ android app package ကို compile လုပ္ေပးမွာျဖစ္ပါတယ္။

Example: for Nexus 5X: `Android-OS/device/lge/bullhead/bullhead.mk`

```mk
PRODUCT_PACKAGES += \
    AudioWaveMaker
```

# Compiling System img with Make
အရင္ဆုံး Android System တခုလုံးကို Compile လုပ္စရာမလိုပဲ ကိုယ္ Add လိုက္တဲ့ app project တခုတည္းကိုပဲ `mma package-name` နဲ့ Compile လုပ္ၾကည့္ႏိုင္ပါတယ္။ ၿပီးမွ Android system တခုလုံးကို Compile လုပ္တာ ပိုေကာင္းပါတယ္။

Example: for AudioWaveMaker app project

```
. build/envsetup.sh
lunch target_android_device
```

```
mma AudioWaveMaker -j$(nproc --all)
```

အဲဒီအဆင့္ ေအာင္ျမင္သြားၿပီဆိုရင္ေတာ့ Android System တခုလုံးကို ျပန္ၿပီး Recompile လုပ္ႏိုင္ပါၿပီ။

```
make -j$(nproc --all)
```

Compilation time က ကိုယ့္ Computer ရဲ႕ CPU core ေပၚ မူတည္ၿပီး ၾကာႏိုင္ပါတယ္။

Reference Links:
- [https://android.googlesource.com/platform/build](https://android.googlesource.com/platform/build)
- [https://android.googlesource.com/platform/build/soong](https://android.googlesource.com/platform/build/soong)
- [https://android.googlesource.com/platform/packages/apps](https://android.googlesource.com/platform/packages/apps)
