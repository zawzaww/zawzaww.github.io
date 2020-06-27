---
layout: post
title: "Compiling Linux Kernel with Clang/LLVM Compiler"
categories: kernel
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_clang_llvm_linux.png
image-description: "Clang/LLVM Logo by: LLVM Project"
permalink: blog/kernel/compile-linux-clang-llvm
---

ဟိုအရင်တည်းကနဲ့ အခုလောလောဆယ်မှာ Linux kernel မှာ သုံးတဲ့ Traditional Default C Compiler က GCC ပဲ ဖြစ်ပါတယ်။ အခုအခါမှာ Linux kernel ကို [Clang/LLVM](http://clang.llvm.org/) နဲ့ပါ အလွယ်တကူ Compile လုပ်လို့ရနေ ပါပြီ။ အဲဒီလို အလွယ်တကူ Compile လုပ်လို့ရအောင် Google Engineer တယောက်ဖြစ်တဲ့ [Nick Desaulniers](http://nickdesaulniers.github.io/about/) က ဦးဆောင်ပြီး [Linux Kernel Build System (kbuild)](https://patchwork.kernel.org/project/linux-kbuild/list/) အတွက် Kernel Patches တွေ လုပ်ပြီး Contribute လုပ်နေတာ ဖြစ်ပါတယ်။ အခုဆိုရင် Linux kernel ရဲ့ [Official Documentation](https://www.kernel.org/doc/html/latest/kbuild/llvm.html) မှာလည်း Clang နဲ့ Linux kernel ကို ဘယ်လို Compile လုပ်မလဲဆိုတာ အပြည့်စုံရှိနေပြီ ဖြစ်ပါတယ်။ ပြီးတော့ GitHub မှာ Nick တို့ လုပ်ထားတဲ့ [ClangBuiltLinux]( ) GitHub Orgnaization လည်း ရှိပါတယ်။ တကယ်လို့ Compiler Bugs တွေနဲ့ Kernel Build erros တွေ ရှိရင်လည်း အဲဒီမှာ Report လုပ်လို့ရပါတယ်။ အခု Article မှာ Linux kernel ကို Clang Compiler နဲ့ လုပ်တဲ့အဆင့်တွေကို တဆင့်ချင်း ရေးသွားမှာဖြစ်ပါတယ်။

ClangBuiltLinux: [https://github.com/ClangBuiltLinux](https://github.com/ClangBuiltLinux)

# Installation Packages
Ubuntu Linux မှာတော့ Clang compiler က Built-in ပါလာပြီးသာပါ။ တကယ်လို့ မရှိရင်လည်း ကိုယ်တိုင် Install လုပ်လို့ရပါတယ်။ Linux distributions မှာ သုံးတဲ့ Package Manager တွေ ပေါ်မှာ မူတည်ပြီး ဒီနေရာ ကွဲပြားနိုင်ပါတယ်။ ကျွန်တော့်အနေနဲ့တော့ Ubuntu Linux နဲ့ပဲ နမူနာအနေနဲ့ ပြောပြသွားမှာပါ။

Clang Compiler Package:

```bash
sudo apt install clang
```

Cross Compiling လုပ်ဖို့အတွက် GNU GCC Prebuilt aarch64 packages ကို Install လုပ်ဖို့အတွက် လိုအပ်ပါတယ်။

Cross Compile for Linux aarch64 aarchitecture packages:

```bash
sudo apt install binutils-aarch64-linux-gnu
```

```bash
sudo apt install gcc-aarch64-linux-gnu
```

# Compiling Kernel with Clang/LLVM
## Host System

ကိုယ်သုံးနေတဲ့ Host Linux Systems အတွက် Linux kernel ကို Clang နဲ့ Compile လုပ်မယ်ဆိုရင် အရမ်းခက်ခက်ခဲခဲကြီးတော့ မဟုတ်ပါဘူး `CC=clang` ဆိုတဲ့ Command line parameter ထည့်ပြီး Compile လိုက်ရုံပါပဲ။

အရင်ဆုံး Compile မလုပ်ခင်မှာ Kernel Configuration မဖြစ်မနေ လုပ်ပေးဖို့ လိုအပ်ပါတယ်။ Default configuration ပဲ သုံးလိုက်ပါမယ် အဲဒီ Kernel Configs တွေက Linux kernel source tree ရဲ့ `arch/<arch>/configs/` အောက်မှာ ရှိနေတာ ဖြစ်ပါတယ်၊

```bash
make CC=clang HOSTCC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_host_make_defconfig.png)

make နဲ့ Kernel configuration လုပ်ပြီးသွားရင် ကိုယ် Create လုပ်လိုက်တဲ့ Kernel configuration တွေကို Kernel Compile မလုပ်ခင် Linux kernel source tree ရဲ့ Root directory အောက်က `.config` မှာ ၀င်ကြည့်နိုင်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_host_kernel_configs.png)

ပြီးရင်တော့ Kernel Compile လုပ်ပါမယ်။

```bash
make CC=clang HOSTCC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_host_make_build.png)

![Screenshot](/assets/images/screenshots/img_screenshot_host_kernel_img.png)


## Cross Compile for ARM arm64
ဒီအပိုင်းမှာတော့ Host System အတွက် မဟုတ်တော့ပဲ ARM arm64 architecutre အတွက် Cross Compiling လုပ်မှာ ဖြစ်ပါတယ်။ ARM arm64 architecture အတွက် Compile လုပ်မှာ ဖြစ်တဲ့အတွက် ```ARCH=arm64``` နဲ့ ```CROSS_COMPILE=aarch64-linux-gnu-``` Command line parameter နှစ်ခုကို ထည်ပေးဖို့ လိုအပ်ပါတယ်။ ကျန်တဲ့ Kernel Compile လုပ်တဲ့ Process ကတော့ Host System နဲ့ အတူတူပဲ ဖြစ်ပါတယ်။

ARM arm64 architecture အတွက် Kernel Configuration လုပ်ပါမယ်။ Kernel Compile မလုပ်ခင်မှာ ဒီအဆင့်က မဖြစ်မနေ လုပ်ပေးဖို့ လိုအပ်ပါတယ်။

```bash
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_make_defconfig.png)


Create လုပ်လိုက်တဲ့ Kernel Configuration တွေကို Linux kernel source tree ရဲ့ Root Directory အောက်က `.config` မှာ ၀င်ကြည့်လို့ရပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_kernel_configs.png)

Configuration လုပ်ပြီးရင်တော့ Kernel Compile လုပ်လို့ရပါပြီ။ ဒီနေရာမှာ `nproc` ဆိုတဲ့ command သည် ကိုယ့် Computer ရဲ့ CPU core ပေါ်မှာ မူတည်ပြီး အလိုလျောက်တွက်ပြီး Build လုပ်တာ ဖြစ်ပါတယ်။ ကိုယ်တိုင် Manual တွက်ပြီး သတ်မှတ်ပေးလို့လည်း ရပါတယ်။ ဥပမာ `-j4` / `j8` / `j16` /  `j32` စသဖြင့် ကိုယ်ရဲ့ CPU core ပေါ်မှာ မူတည်ပြီ တွက်ချက်သတ်မှတ်ပေးလို့ရပါတယ်။

```bash
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make CC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_arm64_make_build.png)

