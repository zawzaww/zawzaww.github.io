---
layout: post
title: "Speeding Up Linux Kernel Builds with Compiler Cache"
author: Zaw Zaw
pin: true
image:
  src: /assets/images/featured-images/img_speedup_linux_kernel_builds.png
---

Ccache (Compiler Cache) ကိုသုံးပြီး Linux kernel compilation time ကို ပုံမှန်ထက်မြန်အောင် ဘယ်လို Setup လုပ်ပြီး Build မလဲဆိုတာကို ဒီ article မှာ အဓိကထားပြီး ပြောသွားမှာဖြစ်ပါတယ်။ ပုံမှန်ဆိုရင် ကျွန်တော်ရဲ့ CPU အနိမ့်နဲ့ Laptop computer လေးပေါ်မှာ Linux kernel ကို Compile လုပ်ရတဲ့အချိန်က 30mins လောက် အချိန်ပေးနေရပါတယ်။ အဲဒါကြောင့် သိပ်ပြီးတော့ အဆင်မပြေဘူး။ အဒီပြဿနာကို Ccache နဲ့ ဖြေရှင်းနိုင်ပါတယ်။ Ccache နဲ့ Compile လုပ်ရင်တော့ 3 - 5 mins လောက်ထိ မြန်သွားပါတယ်။

## What is Ccache?

[Ccache (Compiler Cache)](https://ccache.dev/) က C, C++, Objective-C နဲ့ Objective-C++ Code တွေကို Compile လုပ်တဲ့နေရမှာ Compilation time ကို Speed up  လုပ်ဖို့ အဓိက သုံးပါတယ်။

## Installation and Setup Ccache

ပထမဆုံးအနေနဲ့ ကိုယ့်ရဲ့ GNU/Linux machine ထဲမှာ Ccache package Install လုပ်ထားဖို့လိုပါတယ်။
ကိုယ် Install လုပ်ထားတဲ့ Ccache version ကို check ချင်ရင်တော့

```bash
ccache --version
```

ဆိုပြီး check နိုင်ပါတယ်။
တကယ်လို့ Install မလုပ်ရသေးဘူးဆိုရင်တော့

```bash
sudo apt install ccache
```

ဆိုပြီး Ubuntu Linux မှာ Install လုပ်နိုင်ပါတယ်။

နောက်တခုက .bashrc file ကို ဖွင့်ပြီး Setup လုပ်ဖို့ လိုပါသေးတယ်။
ccache ရဲ့ dir path ကို export လုပ်ပေးလိုက်ရင် ရပါပြီ။ အဒီ အောက်က သုံးကြောင်း .bashrc file မှာ Add ပေးလိုက်ရင် ရပါပြီ။

```bash
export CCACHE_DIR="/home/zawzaw/.cache"
export CXX="ccache g++"
export CC="ccache gcc"
```

Ccache ကို အများဆုံး maximum size ဘယ်လောက်ထားမလဲဆိုတာ သတ်မှတ်ပေးရပါမယ်။

```bash
ccache -M 32
```

![Screenshot](/assets/images/screenshots/img_screenshot_ccache_max_size.png)

ကိုယ်ရဲ့ လက်ရှိမှာရှိနေတဲ့ ccache ရဲ့ Statistics ကို ကြည့်ချင်ရင် `ccache -s` ဆိုပြီး command ကို ရိုက်ပြီး ကြည့်နိုင်ပါတယ်။

```bash
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

## Building Linux Kernel with Ccache

Linux kernel source directory ကို သွားပြီး ပထမက Compile လုပ်ထားတဲ့ Output files တွေ ရှိရင် Clean လုပ်ပေးဖို့ လိုပါတယ်။

```bash
make clean && make mrproper
```

![Screenshot](/assets/images/screenshots/img_screenshot_make_clean.png)

နောက်တဆင့်က Linux kernel ကို Compile မလုပ်ခင် Kernel configuration လုပ်ပေးဖို့ လိုပါတယ်။ ကျွန်တော် နမူနာအနေနဲ့ default configuration ကိုပဲ သုံးလိုက်ပါတယ်။

```bash
make defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_make_defconfig.png)

Ccache နဲ့ Linux kernel ကို Compile လုပ်မယ်ဆိုရင် make command နဲ့ `CC="ccache gcc"` ဆိုတဲ့ Option တခုကို ထည့်ပေးဖို့လိုပါတယ်။

```bash
make CC="ccache gcc" -j$(nproc --all)
```

တကယ်လို့ Compilation time result ကို အတိအကျ သိချင်ရင်တော့ time ဆိုတဲ့ command ကို သုံးပေးဖို့ လိုပါတယ်။

```bash
time make CC="ccache gcc" -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_time_make_cc.png)

![Screenshot](/assets/images/screenshots/img_screenshot_kernel_compile_time.png)
