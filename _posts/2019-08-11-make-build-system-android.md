---
layout: post
title: "Make Build System in Android OS"
categories: android
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_make_build_android.png
---

Android OS-level ပိုင်းမှာ အဓိကသုံးတဲ့ Build System က [Make Build System](https://android.googlesource.com/platform/build) ဖြစ်ပြီး [AOSP (Android Open Source Project)](https://android.googlesource.com/) မှာ Building process အားလုံးကို Make build နဲ့ပဲ handle လုပ်ပါတယ်။ Android system တခုလုံးကို Compile လုပ်ဖို့ရော Make build ကိုပဲ သုံးပါတယ်။  အခုချိန်မှာ Android app developer တိုင်းက Android Studio မှာ  app build ဖို့အတွက် Build system တခု ဖြစ်တဲ့ Gradle ကိုတော့ ရင်းနှီးပြီးသားဖြစ်ပါတယ်။ Gradle build ကတော့ Easy to use ပိုဖြစ်တယ်လို့ ဆိုနိုင်ပါတယ်၊ Make build ကတော့ လုံး၀ Android ရဲ့ OS-level မှာ သုံးတဲ့ native build system ဖြစ်ပြီး ရေးရတာ လက်ပေါက်ကပ်တယ်လို့ ဆိုနိုင်ပါတယ်။ ဒါပေမယ့် Android OS-level မှာတော့ Makfile-based build system ကိုပဲ အဓိကသုံးတဲ့အတွက် ကျွန်တော့်အတွက်က မဖြစ်မနေ လေ့လာဖို့လိုအပ်လာပါတယ်။

ဒါကြောင့် Android Studio မှာ Gradle နဲ့ build လုပ်ထားတဲ့ Android app project source တခုကို Android OS source code ထဲကို ထည့်ချင်တယ်အခါ ဒီအတိုင်း သွား Add လို့ မရပါဘူး။ ဘာကြောင့်လဲဆိုတော့ Android OS's build system က Gradle မဟုတ်တဲ့အတွက်ကြောင့် ဖြစ်ပါတယ်။ အဲဒီအတွက် Android app တခု Compile လုပ်ဖို့အတွက် Low-level Android OS ရဲ့ Make build system နဲ့ ကိုက်ညီတဲ့ Makefile flags တွေ ရေးပေးဖို့လိုပါတယ်။ တနည်းအားဖြင့် AOSP မှာ Standard အဖြစ် သတ်မှတ်ထားတဲ့ Android.mk ကို မဖြစ်မနေ ရေးပေးဖို့ လိုအပ်ပါတယ်။ နောက်တခု သိထားရမှာက Go နဲ့ ရေးထားတဲ့ [Soong Build system](https://android.googlesource.com/platform/build/soong) ကိုလည်း Google ကနေ Introduce လုပ်ထားပါတယ်။ ကျွန်တော်အထင်တော့ နောက်ပိုင်း Old Makefile-based Build System က [Deprecation of Make](https://android.googlesource.com/platform/build/+/refs/heads/master/Deprecation.md) ဖြစ်သွားပြီး Soong နဲ့ လုံး၀ အစားထိုးမယ့် သဘောမှာ ရှိနေပါတယ်။ Soong က Android.mk (Makefile) format အစား Android.bp (Blueprint) format ကို သုံးထားပါတယ်။

ဒီ Blog post မှာ Android system app တခုအတွက် Make နဲ့အတူ Build automation လုပ်ဖို့ Makefile flags တွေ ရေးတဲ့အကြောင်းကို ဆက်ပြောသွားမှာဖြစ်ပါတယ်။

# Writing Makefiles
AOSP မှာ DeskClock ဆိုတဲ့ Android app project တခု အတွက် Android.mk syntax ကို Example တခု အနေနဲ့ အရင်လေ့လာကြည့်နိုင်ပါတယ်။

https://android.googlesource.com/platform/packages/apps/DeskClock/+/refs/tags/android-9.0.0_r47/Android.mk

App project structure ကတော့ Android Studio က app/src/min/ အောက်က dir structure အတိုင်းပဲ ဖြစ်ပါတယ်။ တခုပါပဲ Android.mk ဆိုတဲ့ file တခုတော့ ပိုသွားပါတယ်။ အဒီ Android.mk မှာ App project တခုအတွက် Makefile configuration တွေ ရေးပေးရမှာ ဖြစ်ပါတယ်။

Example: Android-OS/packages/apps/AudioWaveMaker

```
 - cpp
 - java
 - res
 - AndroidManifest.xml
 - Android.mk
```

ပထမဆုံး အနေနဲ့ ကိုယ့် Android app project က ဘယ် Android support libraries တွေနဲ့ တခြား Android libraries တွေ သုံးထားတယ်ဆိုတာ သိရပါတယ်။ ကိုယ့်သုံးထားတဲ့ libraries တွေကို Android.mk မှာ Configure လုပ်ပေးဖို့ လိုပါတယ်။ Example အနေနဲ့ ကျွန်တော့်ရဲ့ AudioWaveMaker ဆိုတဲ့ Android app မှာ အောက်ပါ Android support libraries တွေသုံးထားပါတယ်ဆိုပြီး Define လုပ်ထားပါတယ်။

```mk
LOCAL_STATIC_ANDROID_LIBRARIES += \
     android-support-annotations \
     android-support-v4 \
     android-support-design \
     android-support-v7-appcompat \
     android-support-v17-leanback
```

နောက်တခုကတော့ ကိုယ့် Android app project မှာ သုံးထားတဲ့ resource dirs တွေကို Link လုပ်ပေးဖို့လိုပါတယ်။

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

ကိုယ့် App ရဲ့ Package Name ကို Define လုပ်ပေးရပါမယ်။ ဒီ Package Name က /system/ အောက်မှာ Add မယ့် Package Name ကိုဆိုလိုတာ ဖြစ်ပါတယ်။ မြင်သာအောင်ပြောရရင် Android system img တခု Compile လုပ်ပြီးသွားပြီဆိုရင် /system/priv-app/AudioWaveMaker ဆိုပြီး ကိုယ့်ရဲ့ app package ကို မြင်တွေ့ရမှာ ဖြစ်ပါတယ်။

```mk
LOCAL_PACKAGE_NAME := AudioWaveMaker
```

တကယ်လို့ ကိုယ့်ရဲ့ Android app ကို /system/priv-app/ အောက်မှာ ထည့်ချင်တယ်ဆိုရင် ဒီ Makefile flag ကို သုံးပေးဖို့ လိုပါတယ်။

```mk
LOCAL_PRIVILEGED_MODULE := true
```

နောက်အရေးကြီးတဲ့ Makefile flag တခုက ကိုယ့်ရဲ့ Android app က Platform certificate ဖြစ်ကြောင်း Define လုပ်ပေးရပါမယ်။ ဒါမှသာ System-level app တခုအနေနဲ့ မြင်တွေ့ရမှာ ဖြစ်ပါတယ်။

```mk
LOCAL_CERTIFICATE := platform
```

ပြီးတဲ့နောက် SDK version တွေ Minimal SDK version တွေလည်း Gradle မှာလိုပဲ Define လုပ်ပေးနိုင်ပါတယ်။

```mk
LOCAL_MIN_SDK_VERSION := 21
LOCAL_SDK_VERSION := current
```

App မှာ ရေးထားတဲ့ Java files (or) Kotlin files တွေကို ခေါ်ပေးဖို့ လိုအပ်ပါတယ်။ ဒီ Makefile flag ရဲ့ သဘောက Project root directory / java package အောက်က java files တွေကို သွားခေါ်မှာ ဖြစ်ပါတယ်။

```mk
LOCAL_SRC_FILES := $(call all-java-files-under, java)
```

တကယ်လို့ ကိုယ်ရဲ့ Android app မှာက Android NDK, C/C++ သုံးပြီး ရေးထားတာဆိုရင် အဲဒီ cpp dir အောက်က JNI libary module name ကိုလည်း Define လုပ်ပေးဖို့ လိုအပ်ပါတယ်။ (Example: native-lib)

```mk
LOCAL_JNI_SHARED_LIBRARIES := native-lib
```

နောက်ဆုံးအနေနဲ့ကတော့ အဲဒီအပေါ်က မဖြစ်မနေလုပ်ရမယ့် Makfile flags တွေ Define လုပ်ပြီးရင်တော့ App က Source code ကနေ Build လုပ်ရမှာ ဖြစ်တဲ့အတွက် အောက်ဆုံးမှာ

```mk
include $(BUILD_PACKAGE)
```

ဆိုပြီး ထည့်ပေးရပါမယ်။

တကယ်လို့ ကိုယ့်ရဲ့ Local path အောက်မှာ တခြား Makefiles တွေ ရှိနေသေးရင် ခေါ်ဖို့အတွက် အောက်ဆုံးမှာ

```mk
include $(call all-makefiles-under, $(LOCAL_PATH))
```

ဆိုပြီး ထည့်ပေးရပါမယ်။

My AudioWaveMaker's Android.mk

<script src="https://gist.github.com/zawzaww/5593df85c5d93392e2cb0345d7e3b329.js"></script>

# Adding Product Packages
သက်ဆိုင်ရာ App အတွက် Android.mk file ရေးပြီးသွားပြီ ဆိုရင် ကိုယ် lunch လုပ်မယ့် device tree ရဲ့ Makefile မှာ Android app ရဲ့ PRODUCT_PACKAGES ကို ထည့်ပေးဖို့လိုပါတယ်။ ဘာကြောင့်လဲဆိုတော့ အဲဒီ lunch လိုက်တဲ့ target device မှာ app ရဲ့ PRODUCT_PACKAGES ကို add ထားမှ Build system က packages/apps/ အောက်က ကိုယ့်ရဲ့ android app package ကို compile လုပ်ပေးမှာဖြစ်ပါတယ်။

Example: for Nexus 5X: `Android-OS/device/lge/bullhead/bullhead.mk`

```mk
PRODUCT_PACKAGES += \
    AudioWaveMaker
```

# Compiling System img with Make
အရင်ဆုံး Android System တခုလုံးကို Compile လုပ်စရာမလိုပဲ ကိုယ် Add လိုက်တဲ့ app project တခုတည်းကိုပဲ `mma package-name` နဲ့ Compile လုပ်ကြည့်နိုင်ပါတယ်။ ပြီးမှ Android system တခုလုံးကို Compile လုပ်တာ ပိုကောင်းပါတယ်။

Example: for AudioWaveMaker app project

```
. build/envsetup.sh
lunch target_android_device
```

```
mma AudioWaveMaker -j$(nproc --all)
```

အဲဒီအဆင့် အောင်မြင်သွားပြီဆိုရင်တော့ Android System တခုလုံးကို ပြန်ပြီး Recompile လုပ်နိုင်ပါပြီ။

```
make -j$(nproc --all)
```

Compilation time က ကိုယ့် Computer ရဲ့ CPU core ပေါ် မူတည်ပြီး ကြာနိုင်ပါတယ်။

Reference Links:
- [https://android.googlesource.com/platform/build](https://android.googlesource.com/platform/build)
- [https://android.googlesource.com/platform/build/soong](https://android.googlesource.com/platform/build/soong)
- [https://android.googlesource.com/platform/packages/apps](https://android.googlesource.com/platform/packages/apps)
