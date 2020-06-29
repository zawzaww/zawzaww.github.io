---
layout: post
title: "Compiling Linux Kernel with Clang/LLVM Compiler"
categories: kernel
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_clang_llvm_linux.png
image-description: "Clang/LLVM Logo by: LLVM Project"
permalink: blog/kernel/compile-linux-clang-llvm
---

ဟိုအရင်တည်းကနဲ့ အခုလောလောဆယ်မှာ Linux kernel မှာ သုံးတဲ့ Traditional Default C Compiler က GCC ပဲ ဖြစ်ပါတယ်။ အခုအခါမှာ Linux kernel ကို Modern C-family Compiler တခု ဖြစ်တဲ့ [Clang/LLVM](http://clang.llvm.org/) နဲ့ပါ အလွယ်တကူ Compile လုပ်လို့ ရနေပါပြီ။ အဲဒီလို အလွယ်တကူ Compile လုပ်လို့ရအောင် Google က Software Engineer တယောက်ဖြစ်တဲ့ [Nick Desaulniers](http://nickdesaulniers.github.io/about/) က ဦးဆောင်ပြီး [Linux Kernel Build System (kbuild)](https://patchwork.kernel.org/project/linux-kbuild/list/) အတွက် Kernel Patches တွေ Submit လုပ်ပြီး Contribute လုပ်နေတာ ဖြစ်ပါတယ်။ အခုဆိုရင် Linux kernel ရဲ့ [Official Documentation](https://www.kernel.org/doc/html/latest/kbuild/llvm.html) မှာလည်း Clang နဲ့ Linux kernel ကို ဘယ်လို Compile လုပ်မလဲဆိုတာ အပြည့်စုံရှိနေပြီ ဖြစ်ပါတယ်။ ပြီးတော့ GitHub မှာ Nick တို့ လုပ်ထားတဲ့ [ClangBuiltLinux](https://github.com/ClangBuiltLinux) GitHub Orgnaization လည်း ရှိပါတယ်။ တကယ်လို့ Compiler Bugs တွေနဲ့ Kernel Build errors တွေ ရှိရင်လည်း အဲဒီမှာ Report လုပ်လို့ရပါတယ်။ အခု Article မှာ Linux kernel ကို Clang/LLVM Compiler နဲ့ Compile လုပ်တဲ့အကြောင်းကို တဆင့်ချင်း ရေးသွားမှာဖြစ်ပါတယ်။

ClangBuiltLinux Wiki: [https://github.com/ClangBuiltLinux/linux/wiki](https://github.com/ClangBuiltLinux/linux/wiki)

# Installation Packages
Ubuntu Linux မှာတော့ Clang/LLVM compiler က Built-in ပါလာပြီးသာပါ။ တကယ်လို့ Install မလုပ်ရသေးရင်လည်း ကိုယ်တိုင် Install လုပ်လို့ရပါတယ်။ Linux distributions မှာ သုံးတဲ့ Package Manager တွေ ပေါ်မှာ မူတည်ပြီး ဒီနေရာ ကွဲပြားနိုင်ပါတယ်။ ကျွန်တော့်အနေနဲ့တော့ Ubuntu Linux နဲ့ပဲ နမူနာအနေနဲ့ ပြောပြသွားမှာပါ။

Clang/LLVM Compiler Package:

```bash
sudo apt install clang
```

Cross Compiling လုပ်ဖို့အတွက် GNU GCC Prebuilt aarch64 packages ကို Install လုပ်ဖို့အတွက် လိုအပ်ပါတယ်။

Cross Compile for Linux aarch64 architecture packages:

```bash
sudo apt install binutils-aarch64-linux-gnu
```

```bash
sudo apt install gcc-aarch64-linux-gnu
```

# Compiling for Host System
ကိုယ်သုံးနေတဲ့ Host Linux Systems အတွက် Linux kernel ကို Clang/LLVM နဲ့ Compile လုပ်မယ်ဆိုရင် အရမ်းခက်ခက်ခဲခဲကြီးတော့ မဟုတ်ပါဘူး `CC=clang` ဆိုတဲ့ Command line parameter ထည့်ပြီး Compile လိုက်ရုံပါပဲ။

အရင်ဆုံး Compile မလုပ်ခင်မှာ Kernel Configuration မဖြစ်မနေ လုပ်ပေးဖို့ လိုအပ်ပါတယ်။ Default configuration ပဲ သုံးလိုက်ပါမယ်။ အဲဒီ Kernel Configs တွေက Linux kernel source tree ရဲ့ `arch/<arch>/configs/` အောက်မှာ ရှိနေတာ ဖြစ်ပါတယ်။

For example: x86 architecture

```bash
zawzaw@ubuntu-linux:~/Linux-Kernel/linux-stable/arch/x86/configs$ ls -l
total 24
-rw-rw-r-- 1 zawzaw zawzaw 6841 May 23 14:03 i386_defconfig
-rw-r--r-- 1 zawzaw zawzaw  147 Feb  8 15:20 tiny.config
-rw-rw-r-- 1 zawzaw zawzaw 6834 May 23 14:03 x86_64_defconfig
-rw-r--r-- 1 zawzaw zawzaw  744 Feb  8 15:20 xen.config

```

Default Kernel Configuration ကို သုံးပြီး Kernel Configuration လုပ်လိုက်ပါမယ်။ Clang/LLVM အတွက် `CC=clang` Command Line Parameter မဖြစ်မနေ ထည့်ပေးဖို့လိုအပ်ပါတယ်။

```bash
make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_host_make_defconfig.png)

make နဲ့ Kernel configuration လုပ်ပြီးသွားရင် ကိုယ် Create လုပ်လိုက်တဲ့ Kernel configuration တွေကို Kernel Compile မလုပ်ခင် Linux kernel source tree ရဲ့ Root directory အောက်က `.config` မှာ ၀င်ကြည့်နိုင်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_host_kernel_configs.png)

ပြီးသွားရင်တော့ Kernel Compile လုပ်ပါမယ်။ ဒီနေရာမှာ `CC=clang` Command line parameter ထည့်ပေးဖို့ လိုအပ်ပါတယ်။

ဒီနေရာမှာ `-j$(nproc --all)` Option သည် မဖြစ်မနေ ထည့်ပေးဖို့တော့ မလိုအပ်ပါဘူး။ ထည့်ပေးဖို့တော့ Recommend လုပ်ပါတယ်။ သူသည် GNU Make `make` က `-jN` argument နဲ့ Parallel tasks လုပ်လို့ရပါတယ်။ ပိုမိုမြန်မြန်ဆန်ဆန် Build လုပ်နိုင်ဖို ကူညီပေးပါတယ်။ `N` သည် Number of Parallel tasks ကို ဆိုလိုခြင်းဖြစ်ပါတယ်။ သူသည် ကိုယ့်သုံးနေတဲ့ Computer ရဲ့ CPU Cores တွေပေါ်မှာ တွက်ယူပြီး Build တာ ဖြစ်တဲ့အတွက် `j4` `j8` `j16` စသဖြင့် Manually Define မလုပ်တော့ပဲ Unix/Linux ရဲ့ `nproc` utility command ကို ခေါ်သုံးပြီး CPU Processor Cores အရေတွက်ကို အလိုလျောက်တွက်ယူပြီး Build လုပ်လိုက်တာဖြစ်ပါတယ်။

```bash
make CC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_host_make_build.png)

ကိုယ် Build လိုက်တဲ့ Kernel img ကို Linux kernel source tree ရဲ့ `/arch/x86/boot/bzImage` မှာ Generate လုပ်ပေးသွားမှာ ဖြစ်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_host_kernel_img.png)


# Cross Compiling for ARM arm64
ဒီအပိုင်းမှာတော့ Host System အတွက် မဟုတ်တော့ပဲ ARM arm64 architecutre အတွက် Cross Compiling လုပ်မှာ ဖြစ်ပါတယ်။ ARM arm64 architecture အတွက် Compile လုပ်မှာ ဖြစ်တဲ့အတွက် ```ARCH=arm64``` နဲ့ ```CROSS_COMPILE=aarch64-linux-gnu-``` Command line parameter နှစ်ခုကို ထည်ပေးဖို့ လိုအပ်ပါတယ်။ ကျန်တဲ့ Kernel Compile လုပ်တဲ့ Process ကတော့ Host System နဲ့ အတူတူပဲ ဖြစ်ပါတယ်။

ARM arm64 architecture အတွက် Kernel Configuration လုပ်ပါမယ်။ Kernel Compile မလုပ်ခင်မှာ ဒီအဆင့်က မဖြစ်မနေ လုပ်ပေးဖို့ လိုအပ်ပါတယ်။

```bash
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_make_defconfig.png)


Create လုပ်လိုက်တဲ့ Kernel Configuration တွေကို Linux kernel source tree ရဲ့ Root Directory အောက်က `.config` မှာ ၀င်ကြည့်လို့ရပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_kernel_configs.png)

Configuration လုပ်ပြီးရင်တော့ Kernel Compile လုပ်လို့ရပါပြီ။

```bash
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_make_build.png)

ကိုယ် Build လိုက်တဲ့ Kernel img ကို Linux kernel source tree ရဲ့ `/arch/arm64/boot/Image.gz` မှာ Kernel Build System က Generate လုပ်ပေးသွားမှာ ဖြစ်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_kernel_img.png)

အခုဆိုရင် Linux Kernel Code တွေကို Modern C-family Compiler တခုဖြစ်တဲ့ Clang/LLVM Compiler နဲ့ Compile လုပ်တဲ့အကြောင်းကို ပြောပြပေးတာဖြစ်ပါတယ်။ Linux Kernel ကို Compile လုပ်တဲ့ Steps တွေက ဟိုအရင်အစောပိုင်း Kernel versions တွေလောက် မရှုပ်ထွေးတော့ပါဘူး အခုခါမှာ ပိုပြီးရိုးရှင်းလာပါတယ်။

REF:
- https://www.kernel.org/doc/html/latest/kbuild/llvm.html
- https://github.com/ClangBuiltLinux/linux/wiki
