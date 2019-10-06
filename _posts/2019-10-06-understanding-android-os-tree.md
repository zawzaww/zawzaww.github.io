---
layout: post
title: "Understanding Android OS Source tree"
categories: android
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_understand_android_os.png
permalink: blog/android/understanding-android-os-tree
---

Android OS က free and Open-source Project တခု ဖြစ်ပြီး Android OS SourceCode တွေကို AOSP (Android Open Source Project) ကနေ ရယူနိုင်ပါတယ်။ Android OS SourceCode ထဲမှာ သက်ဆိုင်ရာ directories တွေ အများကြီး ရှိပါတယ်။ တနည်းအားဖြင့် အဲဒီ Android OS Main source code ရဲ့ အောက်မှာရှိတဲ့ directory တခုချင်းဆီက git repostories တွေ ဖြစ်ပါတယ်။ AOSP မှာ အဲဒီ Git repositories အများကြီးကို "repo" ဆိုတဲ့ tool နဲ့ အပေါ်ကနေ maintain လုပ်ပါတယ်။ repo ကို Google က develop လုပ်ခဲ့တာ ဖြစ်ပြီး docs ကို https://source.android.com/setup/develop#repo မှာ ဖက်ကြည့်နိုင်ပါတယ်။ repo ရဲ့ သဘောက Android OS မှာဆိုရင် git repositories တွေ အများကြီးရှိတယ် အဲဒီအများကြီးကို download လုပ်ချင်တယ်ဆိုပါတော့ တခုချင်းဆီကို git clone နေမယ်ဆိုရင် ပြီးတော့မှာ မဟုတ်ပါဘူး ဒါကြောင့် repo tool နဲ့ manifest xml file တခုနဲ့ setup လုပ်ပြီး remote git repositories တွေ အားလုံးကို တခါတည်း ```repo sync``` ဆိုတဲ့ command ကို သုံးပြီး Android OS source code ကို download လုပ်နိုင်နေတာ ဖြစ်ပါတယ်။ ဒါက မြင်သာအောင် ဥပမာတခု ပြောပြတာဖြစ်ပါတယ်။ repo command တွေကို https://source.android.com/setup/develop/repo မှာ အသေးစိတ် ဖက်ကြည့်နိုင်ပါတယ်။ ဒါကြောင့် Android OS source code ကို download လုပ်တော့မယ်ဆိုရင် Google's repo ကို မဖြစ်မနေသိထားရပါမယ်။ ဒီ Blog post မှာ တော့ Androdi OS source tree ရဲ့ သက်ဆိုင်ရာ directories တွေရဲ့ description ကို အဓိကထားပြီး ပြောမှာဖြစ်ပါတယ်။

ပထမဆုံးအနေနဲ့ ကျွန်တော်တို့ Android OS source code ကို AOSP Git repositories: https://android.googlesource.com မှာ ၀င်လေ့လာကြည့်နိုင်ပါတယ်။ Android OS source code ကြီး တခုလုံးကို ဘယ်လို download လုပ်မလဲဆိုတဲ့အကြောင်းကို [Downloading and Compiling PureAOSP](https://zawzaww.github.io/blog/android/download-build-aosp-android) Blog post မှာ ဖက်ကြည့်နိုင်ပါတယ်။

<img src="https://cdn-images-1.medium.com/max/800/1*z-gCsPmfT5n_8eTsIIviuQ.png" height="100%" width="100%;" />

<img src="https://cdn-images-1.medium.com/max/800/1*SiJvQaRedTfLqSjqyNDyFA.png" height="100%" width="100%;" />

နောက်တခုက Google Git နဲ့ မရင်းနှီးတဲ့သူတွေက မျက်စိနောက်တယ်ထင်ရင် mirror အနေနဲ့ GitHub မှာလည်း AOSP repositories တွေကို သူတို့ လုပ်ပေးထားတယ် အဲဒီမှာ ဝင်ကြည့်နိုင်တယ်။

AOSP mirror repositories on GitHub: https://github.com/aosp-mirror

<img src="https://cdn-images-1.medium.com/max/800/1*QMzezVbdArmYMUFzK3hNrQ.png" height="100%" width="100%;" />


```android-platform/art``` : ART ကို Android မှာ [Android Runtime](https://source.android.com/devices/tech/dalvik) လို့ခေါ်ပြီး ART က Dalvik နေရာမှာ Replace လုပ်လိုက်တဲ့ Runtime environment တခု ဖြစ်ပါတယ်။ Android 5.0 မှာ စပြီး Replace လုပ်ပြီး သုံးခဲ့တာဖြစ်ပါတယ်။

```android-platform/bionic``` : Google ကနေ Android OS အတွက် သီသန့် Develop လုပ်ထားတဲ့ Standard C library တခုဖြစ်ပါတယ်။ bionic ရဲ့ Original goal က GNU C Library (glibc) ရဲ့ License ပြဿနာကြောင့်ရယ်၊ bionic က glibc ထက် ပိုသေးငယ်ပြီး ပိုပြီး Speed ကောင်ပြီး Android mobile device တွေအတွက် သီသန့်သဘောမျိူးဖြစ်ပါတယ်။

```android-platform/bootable``` : Bootloader and Android bootable recovery SourceCode တွေ ပါဝင်ပါတယ်။ Android မှာ အဲဒီ AOSP bootable recovery SourceCode တွေကနေ Custom Recovery တခု ပြန် Build နိုင်ပါတယ်။

```android-platform/build``` : Android OS ရဲ့ Build System အဓိက ရှိတဲ့နေရာ ဖြစ်ပါတယ်။ သဘောက SourceCode ကနေ Android Custom Firmware/ROM တွေ command တွေနဲ့ Port / Build လုပ်ဖို့အတွက် အဓိကသုံးပါတယ်။

```android-platform/dalvik``` : Dalvik Virtual Machine နဲ့ Core libraries တွေ ရှိတဲ့ နေရာ ဖြစ်ပါတယ်။ Android အတွက် သီသန့် Google ကနေ Design ပြန်လုပ်ထားတဲ့ VM တမျိုး ဖြစ်ပါတယ်။ Android 4.4 နဲ့ အစောပိုင်းမှာ သုံးပါတယ်။

```android-platform/developers``` : Developers တွေ အတွက် Android နဲ့ ပတ်သက်ပြီး docs တွေ demos တွေ samples တွေ ပါ၀င်ပါတယ်။

```android-platform/development``` : Android Development နဲ့ ပတ်သက်ပြီး Platform Development tools နဲ့ Sample Code တွေ ပါ၀င်ပါတယ်။

```android-platform/device``` : Android Custom Firmware/ROM တခု Build တဲ့အခါ ကိုယ် Build ချင်တဲ့ Device အတွက် Device tree လို့ခေါ်တဲ့ hardware and device-specific configuration တွေကို define လုပ်ပေးတဲ့ နေရာ ဖြစ်ပါတယ်။

```android-platform/external``` : AOSP ထဲကို အမျိုးမျိုးသော တခြားအပြင်က projects တွေ Imported လုပ်ထားတာ ဖြစ်ပါတယ်။ E.g — f2fs tools, ext4, lz4, fonts, llvm and etc..

```android-platform/frameworks``` : Android ရဲ့ Android Core framework Components တွေနဲ့ Services တွေ Java Android application API framwork တွေ အများဆုံး ပါ၀င်ပါတယ်။

```android-platform/frameworks/base``` : Android Core framework နဲ့ System service တွေ ပါဝင်ပါတယ်။

```android-platform/frameworks/native``` : Android framework ရဲ့ Native libraries တွေနဲ့ Services တွေ ပါဝင်ပါတယ်။

```android-platform/frameworks/support``` : ဒါကတော့ Android App developer တွေ အသုံးများဆုံး Android Support library တွေ ဖြစ်ပါတယ်။ E.g — drawerlayout, fragment, gridlayout, recyclerview, room, swiperefreshlayout, slices, viewpager2 and etc..

```android-platform/hardware``` : Hardware Abstraction Layer (HAL) နဲ့ Hardware support library တွေ အများဆုံး ပါဝင်ပါတယ်။

```android-platform/kernel``` : ဒါက ကို Build မယ့် Android Devices အတွက် Kernel source တွေ ရှိတဲ့ နေရာ ဖြစ်ပါတယ်။ Kernel source code ကိုလည်း သုံးနိုင်သလို Prebuilt kernel img တွေလည်း သုံးနိုင်ပါတယ်။

```android-platform/ndk``` : Android Native Development Kit (NDK) ပါ Android app developer တွေ Native code တွေနဲ့ C/C++ နဲ့ Android Apps တွေ ရေးနိုင်ပါတယ်။

```android-platform/packages/apps``` : Built-in Android System apps တွေ ပါဝင်ပါတယ်။ E.g — Calculator, Camera2, Calendar, Dialer, FMRadio, Gallery2, Launcher3, Music, Settings and etc..

```android-platform/prebuilts``` : Linux, Mac လိုမျိုး Host Computer OS တွေမှာ Android SourceCode ကနေ သက်ဆိုင်ရာ Android Devices တွေ အတွက် Kernel နဲ့ Android Custom Firmware/ROM တွေ Compile လုပ်ဖို့ Toochains/Compilers တွေ ပါဝင်ပါတယ်။ E.g — GCC, LLVM/Clang

```android-platform/sdk``` : Android Software Development Kit (SDK) ကတော့ တော်တော်များများ သိကြပါတယ် Android app တွေ ရေးနိုင်ဖို့အတွက် အဓိကလိုအပ်တဲ့ Software development kit တခု ဖြစ်ပါတယ်။

```android-platform/system``` : Android ရဲ့ အရေးကြီးဆုံး အပိုင်း အသည်းနှလုံးလို့တောင် ပြောနိုင်ပါတယ် Minimal Linux system တခုဖြစ်ပြီး Android ကို Boot လုပ်နိုင်ဖို့အတွက် အဓိက သုံးပါတယ်။

```android-platform/tools``` : အမျိုးမျိုးသော Android IDEs and Tools တွေ ပါဝင်ပါတယ်။ E.g — Android Studio

ဒီနေရာမှာ တကယ်အရေးကြီးတဲ့အရာတွေပဲ အဓိကထားပြီး ပြောပေးသွားတာဖြစ်ပါတယ်။
