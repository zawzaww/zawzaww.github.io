---
layout: post
title: "Description of Android OS SourceCode"
categories: android
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_androidos_description.png
permalink: blog/android/android-os-description
---

Android က free and Open-source Project တခု ဖြစ်ပြီး Android OS SourceCode တွေကို AOSP (Android Open Source Project) ကနေ ရယူနိုင်ပါတယ်။ Android OS SourceCode ထဲမှာ သက်ဆိုင်ရာ dir တွေ အများကြီး ရှိပါတယ် တနည်းအားဖြင့် အဲဒါတွေက git repostories ဖြစ်ပါတယ်။ အဲဒီ SourceCode အတွင်းပိုင်း directories တွေမှာ ဘယ် dir က ဘာအတွက် ဆိုတာ ဒီ Article မှာ ရှင်းပြသွားမှာ ဖြစ်ပါတယ်။

ပထမဆုံးအနေနဲ့ ကျွန်တော်တို့ AOSP Git repositories: https://android.googlesource.com ကို ဝင်ကြည့်လိုက်ရင် repositories တွေ အများရှိတာ တွေ့ရမျာ ဖြစ်ပါတယ်။ အရှင်းဆုံးအနေနဲ့ ကျွန်တော် Local computer ထဲမှာ Download လုပ်ထားတဲ့ SourceCode and dirs ကို အပေါ်ဆုံးက Screenshot မှာ အရှင်းဆုံးကြည့်နိုင်ပါတယ်။ အဲဒီ dirs တွေက ဘယ်ကောင်က ဘာအတွက်ဆိုတာ ပြောပြပေးမှာ ဖြစ်ပါတယ်။ ဒီနေရာမှာ အရေးကြီးတဲ့ အသုံးများတဲ့ အပိုင်းတွေပဲ ပြောသွားမှာ ဖြစ်ပါတယ်။

<img src="https://cdn-images-1.medium.com/max/800/1*z-gCsPmfT5n_8eTsIIviuQ.png" height="100%" width="100%;" />

<img src="https://cdn-images-1.medium.com/max/800/1*SiJvQaRedTfLqSjqyNDyFA.png" height="100%" width="100%;" />

နောက်တခုက Google Git နဲ့ မရင်းနှီးတဲ့သူတွေက မျက်စိနောက်တယ်ထင်ရင် mirror အနေနဲ့ GitHub မှာလည်း AOSP repositories တွေကို သူတို့ လုပ်ပေးထားတယ် အဲဒီမှာ ဝင်ကြည့်နိုင်တယ်။ ဒါပေမယ့် အကုန်တော့ အစုံ Push လုပ်မထားဘူး အရေးကြီးတာလောက်ပဲ ထားတဲ့ သဘောပါပဲ။

AOSP mirror repositories on GitHub: https://github.com/aosp-mirror

<img src="https://cdn-images-1.medium.com/max/800/1*QMzezVbdArmYMUFzK3hNrQ.png" height="100%" width="100%;" />

```/device``` : Android Custom Firmware/ROM တခု Build တဲ့အခါ ကိုယ် Build ချင်တဲ့ Device အတွက် Device tree လို့ခေါ်တဲ့ hardware and device-specific configuration တွေကို define လုပ်ပေးတဲ့ နေရာ ဖြစ်ပါတယ်။

```/kernel``` : ဒါက ကို Build မယ့် Device အတွက် Kernel source တွေ ရှိတဲ့ နေရာ ဖြစ်ပါတယ်။

```/platform``` : platform အောက်မှာတော့ repository အခွဲတွေ အများကြီး ရှိပါတယ်။ `/bootable/recovery`, `/build`, `/bionic`, `/dalvik`, `/art`, `/docs`, `/external`, `/frameworks`, `/hardware`, `/manifest`, `/packages`, `/prebuilts`, `/system`, `/sdk`, `/ndk`, `/tools` စသဖြင့် အများကြီး ရှိပါတယ်။ အောက်မှာ အသေးစိတ် ဆက်ရေးသွားပါမယ်။

```platform/bootable``` : Bootloader and Android bootable recovery SourceCode တွေ ပါဝင်ပါတယ်။ Android မှာ အဲဒီ AOSP bootable recovery SourceCode တွေကနေ Custom Recovery တခု ပြန် Build နိုင်ပါတယ်။

```/platform/dalvik``` : Dalvik Virtual Machine နဲ့ Core libraries တွေ ရှိတဲ့ နေရာ ဖြစ်ပါတယ်။ Android အတွက် သီသန့် Google ကနေ Design ပြန်လုပ်ထားတဲ့ VM တမျိုး ဖြစ်ပါတယ်။ Android 4.4 နဲ့ အစောပိုင်းမှာ သုံးပါတယ်။

```/platform/art``` : ART က Dalvik VM နေရာမှာ Replace လုပ်လိုက်တဲ့ Runtime environment တခု ဖြစ်ပါတယ်။ Android 5.0 မှာ စပြီး Google ကနေ Introduce လုပ်ခဲ့ပါတယ်။

```platform/bionic``` : Google ကနေ Android OS အတွက် သီသန့် Develop လုပ်ထားတဲ့ Standard C library တခုဖြစ်ပါတယ်။

```platform/build``` : Makefile နဲ့ ရေးထားတဲ့ Android Build System တခုပါ။ သဘောက AOSP SourceCode ကနေ Android Custom Firmware/ROM တွေ make command တွေနဲ့ Port / Build လုပ်ဖို့ ရေးထားတဲ့ Android Build System တခုပါပဲ။

```/platform/build/soong``` : Makefile based Android Build System အစား Google က Replace လုပ်လိုက်တဲ့ Android Build System အသစ်တခု ဖြစ်ပါတယ်။

```platform/development``` : Development tools နဲ့ Sample Code တွေ ဖြစ်ပါတယ်။

```/platform/docs/source.android.com``` : Official AOSP Docs Website (https://source.android.com) ရဲ့ SourceCode ဖြစ်ပါတယ်။

```/platform/external``` : AOSP ထဲကို အမျိုးမျိုးသော external projects တွေ Imported လုပ်ထားတာ ဖြစ်ပါတယ်။ E.g — f2fs tools, ext4, lz4, fonts, llvm and etc..

```/platform/frameworks``` : Android ရဲ့ Android Core framework Components တွေနဲ့ Services တွေ ဖြစ်ပါတယ်။

```/platform/frameworks/base``` : Android Core framework နဲ့ System service တွေ ပါဝင်ပါတယ်။

```platform/frameworks/native``` : Android framework ရဲ့ Native libraries တွေနဲ့ Services တွေ ပါဝင်ပါတယ်။

```/platform/frameworks/support``` : ဒါကတော့ Android App developer တွေ အသုံးများဆုံး Android Support library တွေ ဖြစ်ပါတယ်။ E.g — drawerlayout, fragment, gridlayout, recyclerview, room, swiperefreshlayout, slices, viewpager2 and etc..
အခု Google I/O 2018 မှာ Android Jetpack နဲ့အတူ AndroidX လို့ ခေါ်ပါတယ်။ လက်ရှိမှာ AndroidX stable version 1.0.0 ထွက်ထားပါတယ်။

```/platform/hardware``` : Hardware Abstraction Layer (HAL) နဲ့ Hardware support library တွေ အများဆုံး ပါဝင်ပါတယ်။

```/platform/manifest``` : Android OS SourceCode repositories တွေ အားလုံးကို Google ရဲ့ git-repo tool နဲ့ Download လုပ်ဖို့ Setup လုပ်ထားတဲ့ Manifest repository ဖြစ်ပါတယ်။

```platform/ndk``` : Android Native Development Kit (NDK) ပါ Android app developer တွေ Native code တွေနဲ့ C/C++ နဲ့ Android Apps တွေ ရေးနိုင်ပါတယ်။

```/platform/packages/apps``` : Built-in Android System apps တွေ ပါဝင်ပါတယ်။ E.g — Calculator, Camera2, Calendar, Dialer, FMRadio, Gallery2, Launcher3, Music, Settings and etc..

```platform/prebuilts``` : Linux, Mac လိုမျိုး Host Computer OS တွေမှာ Android SourceCode ကနေ သက်ဆိုင်ရာ Android Devices တွေ အတွက် Kernel နဲ့ Android Custom Firmware/ROM တွေ Compile လုပ်ဖို့ Toochains/Compilers တွေ ပါဝင်ပါတယ်။ E.g — GCC, LLVM/Clang

```platform/sdk``` : Android Software Development Kit (SDK) ကတော့ တော်တော်များများ သိကြပါတယ် Android app တွေ ရေးဖို့ မရှိမဖြစ်ပါပဲ။

```platform/system``` , ```platform/system/core``` : Android ရဲ့ အရေးကြီးဆုံး အပိုင်း အသည်းနှလုံးလို့တောင် ပြောနိုင်ပါတယ် Minimal Linux system တခုဖြစ်ပြီး Android ကို Boot လုပ်နိုင်ဖို့အတွက် အဓိက သုံးပါတယ်။

```platform/tools``` : အမျိုးမျိုးသော Android IDEs and Tools တွေ ပါဝင်ပါတယ်။ E.g — Android Studio

*NOTE: တခု သိထားဖို့က AOSP Google Git က repositories ကနေ Local computer ထဲကို Download လုပ်ပြီးတဲ့အခါ directory path က နည်းနည်းကွဲသွားပါမယ်။ ဒီ article ရဲ့ Header မှာ ပြထားထဲ့ Screenshot အတိုင်းဖြစ်ပါတယ်။ ဥပမာ ။  ။  AOSP Google Git မှာ ```platform/build``` ဆိုတဲ့ Git repository က Local path မှာတော့ platform ဆိုတာ ပါတော့မှာ မဟုတ်ပဲ ကိုယ် Download လုပ်ထားတဲ့ AOSP Source directory အောက်မှာ ```build``` ဆိုပြီး ဖြစ်သွားပါလိမ့်မယ်။
