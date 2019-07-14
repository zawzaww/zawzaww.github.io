---
layout: post
title: "Downloading AOSP SourceCode and Compiling"
categories: how-to
author: "Zaw Zaw"
permalink: blog/how-to/download-build-aosp-android
---

ဒီ Article မွာ AOSP ဆိုတာဘာလဲ ဆိုတဲ့ အေၾကာင္းအရာနဲ႔ ကြၽန္ေတာ့္ရဲ႕ GitHub က [aosp-android](https://github.com/zawzaww/aosp-android) repository ကို သုံးၿပီး Filesize သက္သာစြာျဖင့္ Pure Android SourceCode ေတြကို ဘယ္လို Download လုပ္ၿပီး GNU/Linux based Computer ေပၚမွာ SourceCode ကေန ဘယ္လို Compile လုပ္မလဲဆိုတာကို ေရးမွာျဖစ္ပါတယ္။ ပထမဆုံး အေနနဲ႔ GitHub repository က [README](https://github.com/zawzaww/aosp-android/blob/android-9.0.0/README.md) ကို ဖက္ၾကည့္ရင္လည္း ရပါတယ္။

# What is AOSP?
AOSP ဆိုတာ Android Open Source Project ရဲ႕ အတိုေကာက္ စကားလုံး ျဖစ္ပါတယ္။ AOSP မွာ ႏွစ္ပိုင္းခြဲၾကည့္လို႔ရမယ္ ပထမတခုက Android OS ပိုင္းနဲ႔ ပတ္သက္ၿပီး Documentation ေတြ ဖက္လို႔ရမယ့္ (https://source.android.com) နဲ႔ Android OS တခုလုံးအတြက္ SourceCode Git Repositories ေတြရွိတဲ့ AOSP Google Git (https://android.googlesource.com) တို႔ ျဖစ္တယ္။ အဲဒီ AOSP Google Git မွာ Android OS ပတ္သက္တဲ့ “system package apps / framework base / framwork support / framework native / bionic / bootable recovery / art and dalvik VM, kernel sources, device trees, android build system and etc.. စတဲ့ Git Repositories ေတြ အားလုံး Open Source အေနနဲ႔ ရယူႏိုင္ပါတယ္။ ကိုယ့္ရဲ႕ Android ဖုန္းအတြက္ Custom Pure Android OS တခု build မယ္ဆိုရင္ Android OS SourceCode ေတြကို AOSP Google Git က ကရယူရမွာ ျဖစ္ပါတယ္။ ဒီေနရာမွာ တခုသိရမွာက Google ရဲ႕ ကိုယ္ပိုင္ Android apps ေတြေတာ့ AOSP ထဲမွာ မပါဝင္ဘူး (e.g : Google PlayStore, Gmail, Maps, PlayMusic, Drive and etc..) သူတို႔ေတြက တကယ္က Open Source မဟုတ္ပါဘူး။ ဒါေၾကာင့္ AOSP ထဲမွာ အဲဒီ apps project repositories ေတြကို ေတြ႕ရမွာ မဟုတ္ပါဘူး။  Google က သီသန႔္ပိုင္ဆိုင္တဲ့ Apps ေတြ ျဖစ္ပါတယ္။ ဒါေၾကာင့္ သတိထားမိပါလိမ့္မယ္ Pure Android firmware (or) AOSP Based Android Custom firmware ေတြမွာ Google’s apps ေတြ မပါတာ ေတြ႕ရပါမယ္ Firmware Install လုပ္ၿပီးတိုင္း အျပင္ Team ေတြက လုပ္ထားတဲ့ Gapps package တခု သြင္းေပးဖို႔လိုပါတယ္။

# GitHub Repository
https://github.com/zawzaww/aosp-android

# About GitHub Repository
ဒီ GitHub က Personal [aosp-android](https://github.com/zawzaww/aosp-android) Repository က Android Devices ေတြအတြက္ Custom Pure Android OS build ဖို႔ရန္ SourceCode ေတြ Size နည္းနည္းနဲ႔ download ဆြဲလို႔ရေအာင္ Setup လုပ္ထားတာ ျဖစ္ပါတယ္။ Personal ဆိုေပမယ့္ တျခားလိုအပ္သူေတြလည္း သုံးႏိုင္ပါတယ္။
ဒီ Personal “aosp-android” GitHub repository နဲ႔ မူရင္း AOSP Google Git က “platform-minifest” Repository နဲ႔ ကြာျခားခ်က္ေတြရွိပါတယ္။ ဒီ Repository ကို Android Platform Manifest လို႔ ေခၚပါတယ္။ Android OS SourceCode ေတြ Download လုပ္ဖို႔ XML files နဲ႔ Setup လုပ္ၿပီး Google ရဲ႕ git-repo Tool ကိုသုံးၿပီး တခါတည္း တေနရာတည္း SourceCode Repos ေတြ အမ်ားႀကီးကို Download လုပ္ႏိုင္ပါတယ္။ သေဘာက OS တခု Build ဖို႔ Git repositories ေတြက အမ်ားႀကီးျဖစ္တဲ့အတြက္ အဲဒီ XML file က ကိုယ္ download လုပ္ခ်င္တဲ့ Remote git repositories ေတြအားလုံး စုေပးထားၿပီး Google ရဲ႕ git-repo Tool နဲ႔ Command line ကေန တခါတည္း download လုပ္ႏိုင္ပါတယ္။ Google ရဲ႕ git-repo အေၾကာင္းကို [Gerrit](https://gerrit.googlesource.com/git-repo/+/refs/heads/master/README.md) မွာ ဖက္ႏိုင္ပါတယ္။ အေပၚမွာေျပာတဲ့ ကြာျခားခ်က္ဆိုတာ  Android OS SourceCode ရဲ႕ File size ကို ဆိုလိုတာ ျဖစ္ပါတယ္။ မူရင္း AOSP SourceCode filesize အနည္းဆုံး 50GB ေက်ာ္ ရွိပါတယ္ ဘာေၾကာင့္လဲဆိုေတာ့ မူရင္းက လိုတာေတြေရာ မလိုအပ္တဲ့ Git Repository အမ်ားႀကီး ထည့္ထားတဲ့အတြက္ေၾကာင့္ Filesize မ်ားေနပါတယ္။ အဲဒါကို ကြၽန္ေတာ့္ရဲ႕ GitHub repository မွာေတာ့ မလိုအပ္တဲ့ “system packages/apps, kernel prebuilts and device trees” စတဲ့ မလိုအပ္တဲ့ Repository အားလုံးကို Remove လုပ္ထားတဲ့ အတြက္ Filesize က သိသိသာသာႀကီးကို က်သြားပါတယ္။ အလြန္ဆုံး 25GB ေလာက္ပဲ ရွိပါတယ္။ ကြာျခားခ်က္ဆိုတာ မလိုအပ္တဲ့ Git repositories ေတြကို remove လုပ္ထားတာကို ဆိုလိုတာ ျဖစ္ပါတယ္။

# How To Download AOSP SourceCode
ပထမဆုံးအေနနဲ႔ SourceCode ေတြ Download လုပ္ဖို႔ Git and Repo ကို Setup လုပ္ထားဖို႔ လိုအပ္ပါတယ္။

အရင္ဆုံး ကိုယ္ Build ခ်င္တဲ့ Android OS version ကို Local machine ထဲမွာ “repo init” လုပ္ေပးဖို႔ လိုပါတယ္ (-b ေနာက္က Name က branch name ပါ တနည္းအားျဖင့္ ကိုယ္ Build ခ်င္တဲ့ Android OS version ပါ)
```
repo init -u https://github.com/zawzaww/aosp-android.git -b android-9.0.0
```

(OR)

To initialize a shallow clone, which will save even more space, use a command like this (ဒီ command က filesize သက္သက္သာသာနဲ႔ download လုပ္ႏိုင္ဖို႔ ကူညီပါတယ္)
```
repo init --depth=1 -u https://github.com/zawzaww/aosp-android.git -b android-9.0.0
```

Sources ေတြ Download လုပ္ဖို႔ ဒီ repo sync လုပ္ဖို့လိုပါတယ္။
```
repo sync
```

(OR)

Additionally, you can define the number of parallel download repo should do (ဒီ command က SourceCode Repositories ေတြကို ျမန္ျမန္ဆန္ဆန္ Download လုပ္ႏိုင္ဖို႔ ကူညီပါတယ္)
```
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
```

# How To Compile
AOSP Android SourceCode ေတြ အားလုံး Download လုပ္ၿပီးသြားရင္ Custom Pure Android firmware တခု Compile ဖို႔ ဒီ command ေတြ ဆက္႐ိုက္ေပးပါ။

```
cd <source-dir>
. build/envsetup.sh
lunch <device_name>
make -j4 (OR) make -j$(nproc --all)
```

အေပၚက commands ေတြက ဘယ္အတြက္သုံးတာ ဆိုတာ ဆက္ေျပာျပေပးသြားပါမယ္။

`cd <source-dir>` : 
ကိုယ့္ Download လုပ္ထားတဲ့ AOSP SourceCode ရွိတဲ့ ေနရာကို ၀င္တာျဖစ္ပါတယ္။

`. build/envsetup.sh` : 
ကိုယ့္ Build မယ့္ Device အတြက္ Compilation မလုပ္ခင္ build system/ envsetup.sh ကို run ေပးဖို႔လိုပါတယ္။

`lunch <device_name>` : 
ကိုယ္က ဘယ္ Device ကို Compile လုပ္မယ္ဆိုၿပီး `lunch` ဆိုတဲ့ command နဲ႔ ေျပာလိုက္တာျဖစ္ပါတယ္။

`make -j$(nproc --all)` : 
make ဆိုတဲ့ command က Android OS SourceCode ကေန system.img ထြက္လာတဲ့ အထိ Compilation process ကို စတင္လုပ္ပါတယ္။

ကိုယ့္ရဲ႕ Android Device အတြက္ Custom Pure Android version တခု ဘယ္လို Build မလဲဆိုတဲ့ အေသးစိတ္ကို [Building Custom Pure Android OS](https://zawzaww.github.io/blog/how-to/building-pure-android) How-To Article မွာ ဆက္လက္ ဖက္ႏိုင္ပါတယ္။
