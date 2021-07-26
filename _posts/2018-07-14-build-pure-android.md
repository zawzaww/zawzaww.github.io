---
layout: post
title: "Building the Pure Android from Source Code"
author: Zaw Zaw
image:
  src: /assets/images/featured-images/img_build_pure_android.jpeg
---

ဒီတခါတော့ အကြောင်းအရာကတော့ AOSP (Android Open Source Project) SourceCode ကနေ ကိုယ့်ရဲ့ Android Device အတွက် Pure Android OS တခု ဘယ်လို Build မလဲဆိုတဲ့ အကြောင်းအရာပါ။ အခုနည်းကို သိသွားပြီဆိုရင် တခြားသော AOSP based ROM တွေရော LineageOS based ROM တွေရော build တတ်သွားပါလိမ့်မယ်၊ တခုပဲကွဲပြားသွားတာပါ Android SourceCode ယူရတဲ့ နေရာပဲကွဲသွားတာပါ။ တခုတော့ သတိပေးထားပါရစေ Android ရဲ့ SourceCode တွေရဲ့ filesize က 20GB နဲ့ အထက်မှာ ရှိပါတယ်။ အဲဒါကြောင့် Internet ကောင်းမှပဲ အဆင်ပြေပါလိမ့်မယ်။ Build တဲ့ နေရာမှာ Linux မှာရော Mac မှာရော build လို့ရပါတယ် ကျွန်တော်ကတော့ Linux နဲ့ပဲ target ထားပြီးပြောသွားမှာဖြစ်ပြီး၊ ခုလောလောဆယ်တော့ ubuntu 17.04 ပဲ သုံးဖြစ်ပါတယ်၊ အဲဒါကြောင့် ubuntu ပေါ်မှာ build တာပဲ ဥပမာပေး ပြောသွားမှာပါ၊ Build မယ့် target Android Device က Nexus 5X နဲ့ ဥပမာပေးပြီး ပြောပြသွားမှာ ဖြစ်ပါတယ်။

## Requirements

- GNU/Linux based Operating System
- OpenJDK
- Python 2.7+
- Git: Version Control System
- Google's git-repo (Repo)

## Why Google's git-repo tool needs

Source: [https://android.googlesource.com/tools/repo](https://android.googlesource.com/tools/repo)

Google ကနေ Android အတွက် အဓိကဦးတည်ပြီး လုပ်ထားတဲ့ git-repo (Repo) အကြောင်းပြောပြချင်ပါတယ်။ များသောအားဖြင့် Repo လု့ိ လူသိများပါတယ် သိကြပါတယ်။ Repo ဆိုတာ GitHub က Project Repository မျိုးကို ခေါ်တာ မဟုတ်ပါဘူး။ Google က Git အပေါ်မှာ အခြေခံပြီး develope ထားတဲ့ Tool ရဲ့အမည်ဖြစ်ပါတယ်။ ဘာလု့ိ Android အတွက် ဖန်းတီထားတာလဲဆိုတော့ Custom Android OS တခု Sources ကနေ Build ချင်တယ်ပဲ ဆိုပါစု့ိ Android OS တနည်းအားဖြင့် AOSP မှာ Android OS ကြီး တခုလုံးအတွက်လိုအပ်တဲ့ Repositories တွေက အများကြီးရှိပါတယ်။ အဲဒါတွေကို တခုချင်း git clone လုပ်နေရင် အဆင်ပြေမှာ မဟုတ်ပါဘူး။ အဲဒီအတွက် Repo က Custom Android OS build မယ်သူတွေကို ကူညီနိုင်ပါတယ်။
git-repo အကြောင်းကို ဒီမှာဝင်ဖက်နိုင်ပါတယ်...
https://code.google.com/archive/p/git-repo/
ပြီးသွားရင် git-repo command တွေကို ဒီမှာ လေ့လာကြည့်ပါ... https://source.android.com/source/using-repo
သူက Android ROM Development မှာ အရမ်းအသုံးဝင်ပါတယ်။ [ git-repo - Multiple Repository Tool ] လို့ခေါ်ပါတယ်။ သူ့ရဲ့ အသုံးဝင်ပုံက GitHub မှာ Repo တခုဆောက်ပြီး အဲဒီထဲမှာ XML file လေးတခုဆောက်ပြီး ကိုယ်လိုချင်တဲ့ ကိုယ် remote လုပ်ချင်တဲ့ repo တွေကိုအမျာကြီးကို link ချိတ်ပေးထာပြီး repo sync ဆိုတဲ့ command ကိုသုံးပြီး၊ ကိုယ့်ရဲ့ Local machine ထဲကို တနေရာတည်းမှာပဲ Repository တွေအမျာကြီးကို download ဆွဲလို့ရပါတယ်၊ သဘောက Custom ROM တခု build ဖို့ လိုအပ်တဲ့ Android SourceCode Repository တွေက အများကြီးပါ အဲဒါကို တခုချင်းလိုက် git clone မနေပဲ XML file လေးကနေ Repository အများကြီးစုပြီး Local ထဲကို download ဆွဲလိုက်တဲ့ သဘောပါပဲ။ တနည်းအားဖြင့် ဒါဟာ Android တခုတည်းအတွက်တင် မဟုတ်ပါဘူူူး သွယ်ဝိုက်ပြီးသုံးနိုင်ပါတယ်။ တကယ်လု့ိ ကိုယ်က Git Repository အများကြီး download ဆွဲဲဲချင်တဲ့အခါ ဒီနည်းက တကယ်မိုက်ပါတယ်။
အဲဒီအတွက် XML file တခုရေးနည်းက မခက်ပါဘူး တကယ်လွယ်ပါတယ်။ ကျွန်တော်ရဲ့ "aosp-android" repository မှာ လေ့လာနိုင်ပါတယ်။
https://github.com/zawzaww/aosp-android/blob/android-8.1.0/default.xml

## Installation OpenJDK

- ပထမဦးဆုံး OpenJDK ကို ကိုယ့်ရဲ့ Computer မှာ Install ထားဖို့ လိုပါတယ်၊ Terminal ကိုဖွင့်ပြီး အောက်ပါ command လေးတွေ ရိုက်ပေးပါ။

```sh
sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo apt-get install openjdk-8-jre
```

OpenJDK Install တဲ့ နေရာမှာ နည်းနည်းပြောပြပါမယ်၊ ကိုယ့် Build မယ့် Android Version ပေါ် မူတည်ပြီး Install ရမယ့် OpenJDK version တွေ ကွဲသွားပါလိမ့်မယ်။
- Android Nougat ကနေ Android Oreo ဆို ( OpenJDK 8 ကို Install ပေးပါ )
- Android Lollipop ကနေ Android Marshmallow ဆို ( OpenJDK 7 ကို Install ပေးပါ )
- Android Gingerbread ကနေ Android KitKat ဆို ( OpenJDK 6 ကို Install ပေးပါ )
( သူ့ရဲ့ အောက်က Android version အတွက်တော့ မပြောတော့ပါဘူး ဘယ်သူမှလည်း Build မှာ မဟုတ်တော့ပါဘူး )

## Installation Python

- နောက်တဆင့်ကတော့ Python install ပေးဖု့ိ လိုပါတယ်၊ Python 2.7 လောက်ဆို အဆင်ပြေပါပြီ။ ( Python 3+ ဆို git-repo အတွက် သိပ်အဆင်မပြေပါဘူး အဲဒါကြောင့် 2.7 ပဲ Install ပေးပါ ) ဒီနေရာမှာ Ubuntu သုံးနေတာဆိုရင် တခါတည်း Install လုပ်ပြီးသားဆိုရင် မလိုအပ်ပါဘူး။

```sh
sudo add-apt-repository ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get install python2.7
```

## Installation Build-Tools

- လိုအပ်တဲ့ build tools တွေ install ဖို့ အောက်ပါ command လေးကို terminal မှာ ရိုက်ပေးပါ။

```sh
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip
```

## Installation Git and Repo (git-repo)

- အရင်ဆုံး Git install မလုပ်ရသေးဘူးဆိုရင် လုပ်ပေးပါ။ ( Install ထားပြီးသားဆိုရင် ဒီအဆင့်ကို ထပ်လုပ်စရာမလိုပါဘူး )

```sh
sudo apt-get install git-core
```

- Setting your username and email in Git
- Format:

```sh
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

- Example:

```sh
git config --global user.name "zawzaw"
git config --global user.email "zawzaw@gmail.com"
```

- Google ရဲ့ git-repo ကို install လုပ်ပေးရပါမယ်။ ( အသုံးဝင်ပုံကို အပေါ်မှာ ရှင်းပြထားပြီးဖြစ်လု့ိ ထပ်မပြောတော့ပါဘူး )

```sh
mkdir ~/bin
PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
```

အဲဒါတွေ အကုန်ပြီးသွားပြီ ဆိုရင်တော့ ROM တခု build ဖို့အတွက် Setup Environment ပိုင်းက ပြည့်စုံသွားပါပြီ။

## Downloading the Sources

Sources တွေ download တဲ့ နေရာမျာ လိုအပ်တဲ့အရာတွေကို ပြောပြစရာရှိပါတယ်။ ( CustomROM တခု build ဖု့ိအတွက် အဲဒါတွေက မရှိမဖြစ် လိုအပ်တာတွေပါ )
- Android OS ကြီးတခုလုံး အတွက် လိုအပ် Repository တွေပါတဲ့ Android Plaform Manifest ( ဘာတွေပါလဲဆိုတော့ Android OS အတွက် လိုအပ်တဲ့ framework တွေ၊ lib တွေ၊ system apps package တွေ၊ device tree တွေ kernel tree တွေ၊ build tools တွေ toochains GCC compiler တွေ အကုန်ပါပါတယ် filesize က 20GB နဲ့ အထက်မှာရှိပါတယ် )
- Google ရဲ့ Device တွေ ဖြစ်တဲ့ Nexus နဲ့ Pixel မဟုတ်ရင် တခြား Android Device တွေအတွက်ဆိုရင် Device tree နဲ့ Kernel source တွေ ရှာထားဖို့ လိုပါတယ်၊ Google ရဲ့ devices တွေအတွက်က AOSP repo ထဲမှာ device tree တွေက တခါတည်းပါပြီးသားပါ။ ( ခုမှ စလုပ်တဲ့သူအနေနဲ့ အကောင်းဆုံး အကြံပေးချင်တာတော့ အကြီးဆုံး ROM Community ကြီး ဖြစ်တဲ့ LineageOS အောက်မှာ သွားရှာတာ အကောင်းဆုံးပါ https://github.com/LineageOS ကိုယ်တိုင် ထုတ်လို့ရပါတယ် ကိုယ့်ဖုန်းရဲ့ hardware arch ပေါ်မူတည်ပြီး Device tree ထုတ်နည်းကို နောက်မှသက်သက်ရေးပေးပါမယ် )
- ပြီးရင် Android device တွေ အတွက် proprietary vendor file တွေ ပါလိုအပ်ပါတယ်။ ( တနည်းအားဖြင် အဲဒီကောင်က Non-opensource file တွေပါ၊ ကိုယ့်ဖုန်း ရဲ့ firmware ထဲကနေ ပြန်ထုတ်ရတာပါ Example for Nexus 5X...https://github.com/PureNexusProject/proprietary_vendor_lge ဥပမာအနေနဲ့ အဲဒီ Repo ထဲမှာ ဝင်ကြည့်ပါ )

- ပထမဆုံး လုပ်ရမှာက Sources တွေ download ဖို့ Directory တခုဆောက်ပါမယ်။
  
```sh
mkdir AOSP-ROM-Project
```

```sh
cd AOSP-ROM-Project
```

- Android SourceCode တွေ download လုပ်ပါတော့မယ်။ ( ဒီနေရာမှာ ပြောစရှိပါတယ် Google Git က AOSP Repo ကနေ download လုပ်ရင် Size အရမ်းများပါတယ်၊ အဲဒါကြောင့် ကျွန်တော့ GitHub မှာဆောက်ထားတဲ့ Personal AOSP Repo ကနေ down ရင် ပိုသက်သာပါလိမ့်မယ်၊ ဘာလို့လဲဆိုတော့ ကျွန်တော့်ရဲ့ GitHub AOSP Repo ထဲမှာ မလိုအပ်တဲ့ project path တွေ လျော့ထားတာပါ၊ သဘောပါပဲ နှစ်သက်တဲ့ Repo ကနေ download ဆွဲပါ။ )
- ပထမဦးဆုံး AOSP SourceCode တွေ ရှိတဲ့နေရာကို သိရပါမယ်...https://android.googlesource.com/platform/manifest
- -b နောက်က ကိုယ့် Build မယ့် branch ပါ။ ( တနည်းအားဖြင့် ကိုယ် Build ချင်တဲ့ Android version ပါ r (r_23) ဆိုတာ Release ကို ဆိုလိုတာပါ )
- ဒီနေရာမှာ သုံးတဲ့ command တွေက git-repo command တွေပါ https://source.android.com/source/using-repo သုံးမယ့် Repository ကလည်း git-repo အတွက် ရည်ရွယ်ပြီး ရေးထားတဲ့ Repository တခုဖြစ်ပါတယ် xml နဲ့ရေးပါတယ်၊ ရေးနည်းက ရိုးရှင်းပါယ် ဒီမှာလေ့လာကြည့်ပါ https://github.com/zawzaww/aosp-android/blob/android-8.1.0/default.xml

```sh
repo init -u https://android.googlesource.com/platform/manifest.git -b android-8.1.0_r2
```

 (OR)

```sh
repo init -u https://github.com/zawzaww/aosp-android.git -b android-8.1.0
```

- Sources တွေ download ဖို့ အောက်က command လေး ရိုက်ပေးပါ။

```sh
repo sync
```

အဲဒီနောက်မှာတော့ Sources တွေ Downloading လုပ်နေတဲ့ အပိုင်းပါ၊
SourceCode တွေ Download တဲ့ process ကတော့ Internet connection ပေါ်မှာ မူတည်ပြီးကြာပါလိမ့်မယ်။

## Compiling the Pure Android

- အရင်ဆုံး Source ကနေ Compilation မလုပ်ခင် ကြိုတင်ပြင်ဆင်ရမယ့် အရာတွေကို ပြောပြပေးပါမယ်။
- ပထမဆုံး လိုအပ်တာက ကိုယ့်ဖုန်းရဲ့ Device tree ပါ
- Location က ဘယ်မှာ သွားထည့်ရမလဲဆိုရင် Download ထားတဲ့ Source dir အောက်က /device အောက်မှာ သွားထည့်ပေးရမှာပါ။
- Format:

```sh
/device/manufacturer/device_name
```

- Example for Nexus 5X:

```sh
/device/lge/bullhead
```

<img src="https://s20.postimg.cc/4hn5zcmx9/Screenshot_from_2017-11-03_21-54-22.png" />

- ROM build တဲ့နေရာမှာ Kernel ပိုင်းက နှစ်မျိုးကွဲပါမယ်၊ Kernel source ကနေ build တာရယ် အဆင်သင့် build ထားပြီးသား prebuilt kernel ကနေ ROM ထဲထည့်ပြီး Build တာဆိုပြီး ရှိပါတယ်၊ kernel source ကနေ build တာပဲ အကြံပေးတယ်။
- ပြီးတဲ့နောက် Kernel source ကနေ build မယ်ဆိုရင် Device tree ထဲက ပြင်ဆင်စရာရှိပါတယ်၊ Nexus 5X အနေနဲ့ ပြောပါမယ် /device/lge/bullhead/BoardConfig.mk ကို TextEditor တခုနဲ့ ဖွင့်ပြီး အောက်က code လေးတွေ ထပ်ဖြည့်လိုက်ပါ။

```mk
# Inline PureZ Kernel Build
KERNEL_TOOLCHAIN := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_OS)-x86/aarch64/aarch64-linux-android-4.9/bin
KERNEL_TOOLCHAIN_PREFIX := aarch64-linux-android-
TARGET_KERNEL_SOURCE := kernel/lge/bullhead
TARGET_KERNEL_CONFIG := purez_defconfig
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
```

Explanation:

```txt
ဒီအဆင့်က ကျွန်တော် ပထမဆုံး ရေးထားခဲ့တဲ့ Building-Kernel ဆိုတဲ့ Tutorial ကို ဖက်ပြီးမှ အဆင်ပြေပါလိမ့်မယ်။
Line 1 - Kernel ကို Compile မယ့် Toolchain location ကို ပေးတာပါ
Line 2 - ကိုယ်သုံးမယ့် Toolchain ရဲ့ Kernel toolchain prefix လို့ခေါ်ပါတယ် ( သိပ်နားမလည်ဘူးဆိုရင် Kernel Compilation Tutorial မှာ လေ့လာကြည့်ပါ )
Line 3 - ဒါကတော့ ကိုယ် Build မယ့် kernel source location ပါ
Line 4 - Kernel build ဖို့အတွက် kernel configuration လုပ်ပေးရပါတယ်၊ အဲဒီအကြောင်းက Kernel config အပိုင်းပါ
Line 5 - ကိုယ့်ဖုန်းအတွက် output ထွက်မယ့် Kernel image name ကို အတိအကျရေးပေးရပါမယ်
```

<img src="https://s20.postimg.cc/thf0h4mjh/Screenshot_from_2017-11-03_21-58-30.png" />

- နောက်တဆင့်က Kernel source အပိုင်းပါ သွားထည့်ပေးရမယ့် Location က Source dir အောက်က /kernel အောက်မှာ သွားထည့်ပေးရမှာပါ။
- Format:
  
```sh
/kernel/manufacturer/device_name
```

- Example: for Nexus 5X ( ဒီ Location က Device tree ထဲမှာ Kernel source path လမ်းကြောင်း ပြန်ပေးရမှာပါ )

```sh
/kernel/lge/bullhead
```

<img src="https://s20.postimg.cc/852x5n81p/Screenshot_from_2017-11-03_21-54-57.png" />

- vendor အပိုင်းပါ အဲဒီကောင်က Source dir အောက်က /vendor အောက်မှာ သွားထည့်ပေးရမှာပါ။
- Format:

```sh
/vendor/manufacturer/device_name
```

- Example: for Nexus 5X
  
```sh
/vendor/lge/bullhead
```

<img src="https://s20.postimg.cc/yesl2cjel/Screenshot_from_2017-11-03_21-56-37.png" />

ဒါတွေပြည့်စုံသွားရင်တော့ AOSP ROM တခု Build ဖို့ အဆင်သင့် ဖြစ်ပါပြီ။

- ဒါကတော့ နောက်ဆုံးအဆင့်ရောက်ပါပြီ၊ Download ထားတဲ့ Source Dir ထဲ ဝင်လိုက်ပြီး Terminal ကို ဖွင့်လိုက်ပါ၊ အောက်က command လေး ရိုက်ပေးပါ။

```sh
. build/envsetup.sh
```

ပြီးသွာရင် ကိုယ် build မယ့် device ကို lunch လုပ်ပေးရပါမယ်။
- Format

```sh
lunch <device_name> (OR) lunch
```

Example: for Nexus 5X

```sh
lunch aosp_bullhead-userdebug
```

<img src="https://s20.postimg.cc/htkymict9/Screenshot_from_2017-11-03_21-59-06.png" />

- အကောင်းဆုံးက lunch လို့ ရိုက်လိုက်ရင် ကိုယ် build မယ့် device name တွေ ကျလာပြီး build ချင်တဲ့ device no. ကို ဆက်ရိုက်ပေးပါ။

```sh
lunch
```

```sh
Enter 1 or 2 or 3 etc...
```

- ပြီးရင် Build ဖို့အတွက် အောက်က command လေး ရိုက်ပေးပါ။

```sh
make -j4
```

 (OR)

```sh
make -j$(nproc --all)
```

```sh
Output - /out/target/product/bullhead/ အောက်မှာ ထွက်သွားပါလိမ့်မယ်
```

ပြီးရင်တော့ Compilation process စတင်ပါမယ်၊ process time ကတော့ ကိုယ့် Computer ရဲ့ CPU core ပေါ် မူတည်ပြီးကြာပါလိမ့်မယ်။
