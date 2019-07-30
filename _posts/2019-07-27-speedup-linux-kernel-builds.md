---
layout: post
title: "Speeding Up Linux Kernel Builds"
categories: linux-kernel
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_speedup_linux_kernel_builds.png
permalink: blog/linux-kernel/speedup-linux-kernel-builds
---

Ccache (Compiler Cache) ကိုသုံးၿပီး Linux kernel compilation time ကို ပုံမွန္ထက္ျမန္ေအာင္ ဘယ္လို Setup လုပ္ၿပီး Build မလဲဆိုတာကို ဒီ article မွာ အဓိကထားၿပီး ေျပာသြားမွာျဖစ္ပါတယ္။ ပုံမွန္ဆိုရင္ ကြၽန္ေတာ္ရဲ႕ CPU အနိမ့္နဲ႔ Laptop computer ေလးေပၚမွာ Linux kernel ကို Compile လုပ္ရတဲ့အခ်ိန္က 30mins ေလာက္ အခ်ိန္ေပးေနရပါတယ္။ အဲဒါေၾကာင့္ သိပ္ၿပီးေတာ့ အဆင္မေျပဘူး။ အဒီျပႆနာကို Ccache နဲ႔ ေျဖရွင္းႏိုင္ပါတယ္။ Ccache နဲ႔ Compile လုပ္ရင္ေတာ့ 3 - 5 mins ေလာက္ထိ ျမန္သြားပါတယ္။

# What is Ccache?
[Ccache (Compiler Cache)](https://ccache.dev/) က C, C++, Objective-C နဲ႔ Objective-C++ Code ေတြကို Compile လုပ္တဲ့ေနရမွာ Compilation time ကို Speed up  လုပ္ဖို႔ အဓိက သုံးပါတယ္။

# Installation and Setup Ccache
ပထမဆုံးအေနနဲ႔ ကိုယ့္ရဲ႕ GNU/Linux machine ထဲမွာ Ccache package Install လုပ္ထားဖို႔လိုပါတယ္။
ကိုယ္ Install လုပ္ထားတဲ့ Ccache version ကို check ခ်င္ရင္ေတာ့

```
ccache --version
```

ဆိုၿပီး check ႏိုင္ပါတယ္။
တကယ္လို႔ Install မလုပ္ရေသးဘူးဆိုရင္ေတာ့

```
sudo apt install ccache
```

ဆိုၿပီး Ubunt Linux မွာ Install လုပ္ႏိုင္ပါတယ္။

ေနာက္တခုက .bashrc file ကို ဖြင့္ၿပီး Setup လုပ္ဖို႔ လိုပါေသးတယ္။
ccache ရဲ႕ dir path ကို export လုပ္ေပးလိုက္ရင္ ရပါၿပီ။ အဒီ ေအာက္က သုံးေၾကာင္း .bashrc file မွာ Add ေပးလိုက္ရင္ ရပါၿပီ။

```
export CCACHE_DIR="/home/zawzaw/.cache"
export CXX="ccache g++"
export CC="ccache gcc"
```

Ccache ကို အမ်ားဆုံး maximum size ဘယ္ေလာက္ထားမလဲဆိုတာ သတ္မွတ္ေပးရပါမယ္။
```
ccache -M 32
```
![Screenshot](/assets/images/screenshot-2-2019-07-27.png)

လက္ရွိ ccache ရဲ႕ Statistics ကို ၾကည့္ခ်င္ရင္ `ccache -s` command ကို သုံးလို႔ရပါတယ္။
```
zawzaw@ubuntu-linux:~/Linux-kernel/linux-stable$ ccache -s
cache directory                     /home/zawzaw/.cache
primary config                      /home/zawzaw/.cache/ccache.conf
secondary config      (readonly)    /etc/ccache.conf
stats updated                       Fri Jul 26 15:53:23 2019
stats zeroed                        Fri Jul 26 15:02:19 2019
cache hit (direct)                  5139
cache hit (preprocessed)              24
cache miss                          2488
cache hit rate                     67.48 %
called for preprocessing              87
unsupported code directive            14
no input file                        804
cleanups performed                     0
files in cache                     80206
cache size                           2.5 GB
max cache size                      32.0 GB
```

# Building Linux Kernel with Ccache
Linux kernel source directory ကို သြားၿပီး ပထမက Compile လုပ္ထားတဲ့ Output files ေတြ ရွိရင္ Clean လုပ္ေပးဖို႔ လိုပါတယ္။
```
make clean && make mrproper
```
![Screenshot](/assets/images/screenshot-5-2019-07-27.png)

ေနာက္တဆင့္က Linux kernel ကို Compile မလုပ္ခင္ Kernel configuration လုပ္ေပးဖို႔ လိုပါတယ္။ ကြၽန္ေတာ္ နမူနာအေနနဲ႔ default configuration ကိုပဲ သုံးလိုက္ပါတယ္။
```
make defconfig
```
![Screenshot](/assets/images/screenshot-1-2019-07-27.png)

Ccache နဲ႔ Linux kernel ကို Compile လုပ္မယ္ဆိုရင္ make command နဲ႔ `CC="ccache gcc"` ဆိုတာ ထည့္ေပးဖို႔လိုပါတယ္။
```
make CC="ccache gcc" -j$(nproc --all)
```
![Screenshot](/assets/images/screenshot-3-2019-07-27.png)

တကယ္လို႔ Compilation time result ကို အတိအက် သိခ်င္ရင္ေတာ့ time ဆိုတဲ့ command ကို သုံးေပးဖို႔ လိုပါတယ္။
```
time make CC="ccache gcc" -j$(nproc --all)
```
![Screenshot](/assets/images/screenshot-4-2019-07-27.png)
