---
layout: post
title: "Description of Android OS SourceCode"
categories: knowledge
author: "Zaw Zaw"
featured-image: /assets/images/android-os-description.png
permalink: blog/knowledge/android-os-description
---

Android က free and Open-source Project တခု ျဖစ္ၿပီး Android OS SourceCode ေတြကို AOSP (Android Open Source Project) ကေန ရယူႏိုင္ပါတယ္။ Android OS SourceCode ထဲမွာ သက္ဆိုင္ရာ dir ေတြ အမ်ားႀကီး ရွိပါတယ္ တနည္းအားျဖင့္ အဲဒါေတြက git repostories ျဖစ္ပါတယ္။ အဲဒီ SourceCode အတြင္းပိုင္း directories ေတြမွာ ဘယ္ dir က ဘာအတြက္ ဆိုတာ ဒီ Article မွာ ရွင္းျပသြားမွာ ျဖစ္ပါတယ္။

ပထမဆုံးအေနနဲ႔ ကြၽန္ေတာ္တို႔ AOSP Git repositories: https://android.googlesource.com ကို ၀င္ၾကည့္လိုက္ရင္ repositories ေတြ အမ်ားရွိတာ ေတြ႕ရမ်ာ ျဖစ္ပါတယ္။ အရွင္းဆုံးအေနနဲ႔ ကြၽန္ေတာ္ Local computer ထဲမွာ Download လုပ္ထားတဲ့ SourceCode and dirs ကို အေပၚဆုံးက Screenshot မွာ အရွင္းဆုံးၾကည့္ႏိုင္ပါတယ္။ အဲဒီ dirs ေတြက ဘယ္ေကာင္က ဘာအတြက္ဆိုတာ ေျပာျပေပးမွာ ျဖစ္ပါတယ္။ ဒီေနရာမွာ အေရးႀကီးတဲ့ အသုံးမ်ားတဲ့ အပိုင္းေတြပဲ ေျပာသြားမွာ ျဖစ္ပါတယ္။

<img src="https://cdn-images-1.medium.com/max/800/1*z-gCsPmfT5n_8eTsIIviuQ.png" height="100%" width="100%;" />

<img src="https://cdn-images-1.medium.com/max/800/1*SiJvQaRedTfLqSjqyNDyFA.png" height="100%" width="100%;" />

ေနာက္တခုက Google Git နဲ႔ မရင္းႏွီးတဲ့သူေတြက မ်က္စိေနာက္တယ္ထင္ရင္ mirror အေနနဲ႔ GitHub မွာလည္း AOSP repositories ေတြကို သူတို႔ လုပ္ေပးထားတယ္ အဲဒီမွာ ၀င္ၾကည့္ႏိုင္တယ္။ ဒါေပမယ့္ အကုန္ေတာ့ အစုံ Push လုပ္မထားဘူး အေရးႀကီးတာေလာက္ပဲ ထားတဲ့ သေဘာပါပဲ။

AOSP mirror repositories on GitHub: https://github.com/aosp-mirror

<img src="https://cdn-images-1.medium.com/max/800/1*QMzezVbdArmYMUFzK3hNrQ.png" height="100%" width="100%;" />

```/device``` : Android Custom Firmware/ROM တခု Build တဲ့အခါ ကိုယ္ Build ခ်င္တဲ့ Device အတြက္ Device tree လို႔ေခၚတဲ့ hardware and device-specific configuration ေတြကို define လုပ္ေပးတဲ့ ေနရာ ျဖစ္ပါတယ္။

```/kernel``` : ဒါက ကို Build မယ့္ Device အတြက္ Kernel source ေတြ ရွိတဲ့ ေနရာ ျဖစ္ပါတယ္။

```/platform``` : platform ေအာက္မွာေတာ့ repository အခြဲေတြ အမ်ားႀကီး ရွိပါတယ္။ `/bootable/recovery`, `/build`, `/bionic`, `/dalvik`, `/art`, `/docs`, `/external`, `/frameworks`, `/hardware`, `/manifest`, `/packages`, `/prebuilts`, `/system`, `/sdk`, `/ndk`, `/tools` စသျဖင့္ အမ်ားႀကီး ရွိပါတယ္။ ေအာက္မွာ အေသးစိတ္ ဆက္ေရးသြားပါမယ္။

```platform/bootable``` : Bootloader and Android bootable recovery SourceCode ေတြ ပါဝင္ပါတယ္။ Android မွာ အဲဒီ AOSP bootable recovery SourceCode ေတြကေန Custom Recovery တခု ျပန္ Build ႏိုင္ပါတယ္။

```/platform/dalvik``` : Dalvik Virtual Machine နဲ႔ Core libraries ေတြ ရွိတဲ့ ေနရာ ျဖစ္ပါတယ္။ Android အတြက္ သီသန္႔ Google ကေန Design ျပန္လုပ္ထားတဲ့ VM တမ်ိဳး ျဖစ္ပါတယ္။ Android 4.4 နဲ႔ အေစာပိုင္းမွာ သုံးပါတယ္။

```/platform/art``` : ART က Dalvik VM ေနရာမွာ Replace လုပ္လိုက္တဲ့ Runtime environment တခု ျဖစ္ပါတယ္။ Android 5.0 မွာ စၿပီး Google ကေန Introduce လုပ္ခဲ့ပါတယ္။

```platform/bionic``` : Google ကေန Android OS အတြက္ သီသန္႔ Develop လုပ္ထားတဲ့ Standard C library တခုျဖစ္ပါတယ္။

```platform/build``` : Makefile နဲ႔ ေရးထားတဲ့ Android Build System တခုပါ။ သေဘာက AOSP SourceCode ကေန Android Custom Firmware/ROM ေတြ make command ေတြနဲ႔ Port / Build လုပ္ဖို႔ ေရးထားတဲ့ Android Build System တခုပါပဲ။

```/platform/build/soong``` : Makefile based Android Build System အစား Google က Replace လုပ္လိုက္တဲ့ Android Build System အသစ္တခု ျဖစ္ပါတယ္။

```platform/development``` : Development tools နဲ႔ Sample Code ေတြ ျဖစ္ပါတယ္။

```/platform/docs/source.android.com``` : Official AOSP Docs Website (https://source.android.com) ရဲ႕ SourceCode ျဖစ္ပါတယ္။

```/platform/external``` : AOSP ထဲကို အမ်ိဳးမ်ိဳးေသာ external projects ေတြ Imported လုပ္ထားတာ ျဖစ္ပါတယ္။ E.g — f2fs tools, ext4, lz4, fonts, llvm and etc..

```/platform/frameworks``` : Android ရဲ႕ Android Core framework Components ေတြနဲ႔ Services ေတြ ျဖစ္ပါတယ္။

```/platform/frameworks/base``` : Android Core framework နဲ႔ System service ေတြ ပါ၀င္ပါတယ္။

```platform/frameworks/native``` : Android framework ရဲ႕ Native libraries ေတြနဲ႔ Services ေတြ ပါ၀င္ပါတယ္။

```/platform/frameworks/support``` : ဒါကေတာ့ Android App developer ေတြ အသုံးမ်ားဆုံး Android Support library ေတြ ျဖစ္ပါတယ္။ E.g — drawerlayout, fragment, gridlayout, recyclerview, room, swiperefreshlayout, slices, viewpager2 and etc..
အခု Google I/O 2018 မွာ Android Jetpack နဲ႔အတူ AndroidX လို႔ ေခၚပါတယ္။ လက္ရွိမွာ AndroidX stable version 1.0.0 ထြက္ထားပါတယ္။

```/platform/hardware``` : Hardware Abstraction Layer (HAL) နဲ႔ Hardware support library ေတြ အမ်ားဆုံး ပါ၀င္ပါတယ္။

```/platform/manifest``` : Android OS SourceCode repositories ေတြ အားလုံးကို Google ရဲ႕ git-repo tool နဲ႔ Download လုပ္ဖို႔ Setup လုပ္ထားတဲ့ Manifest repository ျဖစ္ပါတယ္။

```platform/ndk``` : Android Native Development Kit (NDK) ပါ Android app developer ေတြ Native code ေတြနဲ႔ C/C++ နဲ႔ Android Apps ေတြ ေရးႏိုင္ပါတယ္။

```/platform/packages/apps``` : Built-in Android System apps ေတြ ပါ၀င္ပါတယ္။ E.g — Calculator, Camera2, Calendar, Dialer, FMRadio, Gallery2, Launcher3, Music, Settings and etc..

```platform/prebuilts``` : Linux, Mac လိုမ်ိဳး Host Computer OS ေတြမွာ Android SourceCode ကေန သက္ဆိုင္ရာ Android Devices ေတြ အတြက္ Kernel နဲ႔ Android Custom Firmware/ROM ေတြ Compile လုပ္ဖို႔ Toochains/Compilers ေတြ ပါဝင္ပါတယ္။ E.g — GCC, LLVM/Clang

```platform/sdk``` : Android Software Development Kit (SDK) ကေတာ့ ေတာ္ေတာ္မ်ားမ်ား သိၾကပါတယ္ Android app ေတြ ေရးဖို႔ မရွိမျဖစ္ပါပဲ။

```platform/system``` , ```platform/system/core``` : Android ရဲ႕ အေရးႀကီးဆုံး အပိုင္း အသည္းႏွလုံးလို႔ေတာင္ ေျပာႏိုင္ပါတယ္ Minimal Linux system တခုျဖစ္ၿပီး Android ကို Boot လုပ္ႏိုင္ဖို႔အတြက္ အဓိက သုံးပါတယ္။

```platform/tools``` : အမ်ိဳးမ်ိဳးေသာ Android IDEs and Tools ေတြ ပါ၀င္ပါတယ္။ E.g — Android Studio

*NOTE: တခု သိထားဖို႔ရွိပါတယ္ AOSP Google Gitက repository လမ္ေၾကာင္းအတိုင္း Local computer ထဲကို Download လုပ္တဲ့ အခါ dir path က နည္းနည္း ကြဲပါမယ္။ ဥပမာ — Google Git မွာ ‘platform/build’ ဆိုတဲ့ repository က Local path မွာ platform ဆိုတာ ပါေတာ့မွာ မဟုတ္ပဲ build ဆိုၿပီး တန္းသြားလိမ့္မယ္။

