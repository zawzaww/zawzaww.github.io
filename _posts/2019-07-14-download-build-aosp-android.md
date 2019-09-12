---
layout: post
title: "Downloading and Compiling PureAOSP"
categories: android
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_download_build_aosp_android.png
permalink: blog/android/download-build-aosp-android
---

ဒီ Article မှာ Pure AOSP ဆိုတာဘာလဲ ဆိုတဲ့ အကြောင်းအရာနဲ့ ကျွန်တော့်ရဲ့ GitHub က [aosp-android](https://github.com/zawzaww/aosp-android) repository ကို သုံးပြီး Filesize သက်သာစွာဖြင့် Pure Android SourceCode တွေကို ဘယ်လို Download လုပ်ပြီး GNU/Linux based Computer ပေါ်မှာ SourceCode ကနေ ဘယ်လို Compile လုပ်မလဲဆိုတာကို ရေးမှာဖြစ်ပါတယ်။ ပထမဆုံး အနေနဲ့ GitHub repository က [README](https://github.com/zawzaww/aosp-android/blob/android-9.0.0/README.md) ကို ဖက်ကြည့်ရင်လည်း ရပါတယ်။

# What is Pure AOSP?
AOSP ဆိုတာ Android Open Source Project ရဲ့ အတိုကောက် စကားလုံး ဖြစ်ပါတယ်။ ဒီနေရာမှာ Pure AOSP (or) Pure Android သုံးတာက မူရင်း AOSP Git မှာအတိုင်း ဘာမှ မပြုပြင်ပဲ ဒီအတိုင်း Pure Android OS build တာကို ဆိုလိုခြင်းဖြစ်ပါတယ်။ (Simple named: unmodifed Android OS)
AOSP ကို နှစ်ပိုင်းခွဲကြည့်လို့ရမယ် ပထမတခုက Android OS ပိုင်းနဲ့ ပတ်သက်ပြီး Documentation တွေ ဖက်လို့ရမယ့် (https://source.android.com) နဲ့ Android OS တခုလုံးအတွက် SourceCode Git Repositories တွေရှိတဲ့ AOSP Google Git (https://android.googlesource.com) တို့ ဖြစ်တယ်။ အဲဒီ AOSP Google Git မှာ Android OS ပတ်သက်တဲ့ “system package apps / framework base / framwork support / framework native / bionic / bootable recovery / art and dalvik VM, kernel sources, device trees, android build system and etc.. စတဲ့ Git Repositories တွေ အားလုံး Open Source အနေနဲ့ ရယူနိုင်ပါတယ်။ ကိုယ့်ရဲ့ Android ဖုန်းအတွက် Custom Pure Android OS တခု build မယ်ဆိုရင် Android OS SourceCode တွေကို AOSP Google Git က ကရယူရမှာ ဖြစ်ပါတယ်။ ဒီနေရာမှာ တခုသိရမှာက Google ရဲ့ ကိုယ်ပိုင် Android apps တွေတော့ AOSP ထဲမှာ မပါဝင်ဘူး (e.g : Google PlayStore, Gmail, Maps, PlayMusic, Drive and etc..) သူတို့တွေက တကယ်က Open Source မဟုတ်ပါဘူး။ ဒါကြောင့် AOSP ထဲမှာ အဲဒီ apps project repositories တွေကို တွေ့ရမှာ မဟုတ်ပါဘူး။  Google က သီသန့်ပိုင်ဆိုင်တဲ့ Apps တွေ ဖြစ်ပါတယ်။ ဒါကြောင့် သတိထားမိပါလိမ့်မယ် Pure Android firmware (or) AOSP Based Android Custom firmware တွေမှာ Google’s apps တွေ မပါတာ တွေ့ရပါမယ် Firmware Install လုပ်ပြီးတိုင်း အပြင် Team တွေက လုပ်ထားတဲ့ Gapps package တခု သွင်းပေးဖို့လိုပါတယ်။

# GitHub Repository
https://github.com/zawzaww/aosp-android

![aosp-android](/assets/images/screenshots/img_screenshot_github_aosp_android.png)

# About GitHub Repository
ဒီ GitHub က Personal [aosp-android](https://github.com/zawzaww/aosp-android) Repository က Android Devices တွေအတွက် Custom Pure Android OS build ဖို့ရန် SourceCode တွေ Size နည်းနည်းနဲ့ download ဆွဲလို့ရအောင် Setup လုပ်ထားတာ ဖြစ်ပါတယ်။ Personal ဆိုပေမယ့် တခြားလိုအပ်သူတွေလည်း သုံးနိုင်ပါတယ်။
ဒီ Personal “aosp-android” GitHub repository နဲ့ မူရင်း AOSP Google Git က “platform-minifest” Repository နဲ့ ကွာခြားချက်တွေရှိပါတယ်။ ဒီ Repository ကို Android Platform Manifest လို့ ခေါ်ပါတယ်။ Android OS SourceCode တွေ Download လုပ်ဖို့ XML files နဲ့ Setup လုပ်ပြီး Google ရဲ့ git-repo Tool ကိုသုံးပြီး တခါတည်း တနေရာတည်း SourceCode Repos တွေ အများကြီးကို Download လုပ်နိုင်ပါတယ်။ သဘောက OS တခု Build ဖို့ Git repositories တွေက အများကြီးဖြစ်တဲ့အတွက် အဲဒီ XML file က ကိုယ် download လုပ်ချင်တဲ့ Remote git repositories တွေအားလုံး စုပေးထားပြီး Google ရဲ့ git-repo Tool နဲ့ Command line ကနေ တခါတည်း download လုပ်နိုင်ပါတယ်။ Google ရဲ့ git-repo အကြောင်းကို [Gerrit](https://gerrit.googlesource.com/git-repo/+/refs/heads/master/README.md) မှာ ဖက်နိုင်ပါတယ်။ အပေါ်မှာပြောတဲ့ ကွာခြားချက်ဆိုတာ  Android OS SourceCode ရဲ့ File size ကို ဆိုလိုတာ ဖြစ်ပါတယ်။ မူရင်း AOSP SourceCode filesize အနည်းဆုံး 50GB ကျော် ရှိပါတယ် ဘာကြောင့်လဲဆိုတော့ မူရင်းက လိုတာတွေရော မလိုအပ်တဲ့ Git Repository အများကြီး ထည့်ထားတဲ့အတွက်ကြောင့် Filesize များနေပါတယ်။ အဲဒါကို ကျွန်တော့်ရဲ့ GitHub repository မှာတော့ မလိုအပ်တဲ့ “system packages/apps, kernel prebuilts and device trees” စတဲ့ မလိုအပ်တဲ့ Repository အားလုံးကို Remove လုပ်ထားတဲ့ အတွက် Filesize က သိသိသာသာကြီးကို ကျသွားပါတယ်။ အလွန်ဆုံး 25GB လောက်ပဲ ရှိပါတယ်။ ကွာခြားချက်ဆိုတာ မလိုအပ်တဲ့ Git repositories တွေကို remove လုပ်ထားတာကို ဆိုလိုတာ ဖြစ်ပါတယ်။

# How To Download AOSP SourceCode
ပထမဆုံးအနေနဲ့ SourceCode တွေ Download လုပ်ဖို့ Git and Repo ကို Setup လုပ်ထားဖို့ လိုအပ်ပါတယ်။

အရင်ဆုံး ကိုယ် Build ချင်တဲ့ Android OS version ကို Local machine ထဲမှာ “repo init” လုပ်ပေးဖို့ လိုပါတယ် (-b နောက်က Name က branch name ပါ တနည်းအားဖြင့် ကိုယ် Build ချင်တဲ့ Android OS version ပါ)
```
repo init -u https://github.com/zawzaww/aosp-android.git -b android-9.0.0
```

(OR)

To initialize a shallow clone, which will save even more space, use a command like this (ဒီ command က filesize သက်သက်သာသာနဲ့ download လုပ်နိုင်ဖို့ ကူညီပါတယ်)
```
repo init --depth=1 -u https://github.com/zawzaww/aosp-android.git -b android-9.0.0
```

Sources တွေ Download လုပ်ဖို့ ဒီ repo sync လုပ်ဖို့လိုပါတယ်။
```
repo sync
```

(OR)

Additionally, you can define the number of parallel download repo should do (ဒီ command က SourceCode Repositories တွေကို မြန်မြန်ဆန်ဆန် Download လုပ်နိုင်ဖို့ ကူညီပါတယ်)
```
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
```

# How To Compile
AOSP Android SourceCode တွေ အားလုံး Download လုပ်ပြီးသွားရင် Custom Pure Android firmware တခု Compile ဖို့ ဒီ command တွေ ဆက်ရိုက်ပေးပါ။

```
cd <source-dir>

. build/envsetup.sh

lunch <device_name>

make -j4 (OR) make -j$(nproc --all)
```

အပေါ်က commands တွေက ဘယ်အတွက်သုံးတာ ဆိုတာ ဆက်ပြောပြပေးသွားပါမယ်။

`cd <source-dir>` : 
ကိုယ့် Download လုပ်ထားတဲ့ AOSP SourceCode ရှိတဲ့ directory ရှိတဲ့ နေရာကို ဝင်တာဖြစ်ပါတယ် တနည်းအားဖြင့် Change directory လုပ်တာဖြစ်ပါတယ်။

`. build/envsetup.sh` : 
ကိုယ့် Build မယ့် Device အတွက် Compilation မလုပ်ခင် build system/ envsetup.sh ကို run ပေးဖို့လိုပါတယ်။

`lunch <device_name>` : 
ကိုယ်က ဘယ် Device ကို Compile လုပ်မယ်ဆိုပြီး `lunch` ဆိုတဲ့ command နဲ့ ပြောလိုက်တာဖြစ်ပါတယ်။

`make -j$(nproc --all)` : 
make ဆိုတဲ့ command က Android OS SourceCode ကနေ system.img ထွက်လာတဲ့ အထိ Compilation process ကို စတင်လုပ်ပါတယ်။

ဒီ article မှာ Pure AOSP နဲ့ GitHub repository အကြောင်းကိုပဲ အဓိက ပြောတာဖြစ်ပြီး Building လုပ်တဲ့အပိုင်းမှာတော့ အကြမ်းသဘောလောက်ပဲ ဖြစ်ပါတယ်။ 
ကိုယ့်ရဲ့ Android Device အတွက် Custom Pure Android version တခု ဘယ်လို Build မလဲဆိုတဲ့ အသေးစိတ်ကို [Building Custom Pure Android OS](https://zawzaww.github.io/blog/android/build-pure-android) How-To Article မှာ ဆက်လက် ဖက်နိုင်ပါတယ်။
