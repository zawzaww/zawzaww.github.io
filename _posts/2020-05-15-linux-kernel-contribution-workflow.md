---
layout: post
title: Linux Kernel Contribution Workflow
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_linux_kernel_contribution.png
permalink: blog/linux-kernel-contribution-workflow
---

Linux kernel ကို Contribute လုပ်တဲ့အပိုင်းမှာ လုပ်ငန်းစဥ်အသွားအလာ Workflow ကို အခု article မှာ အဓိကထား ပြောသွားမှာဖြစ်ပါတယ်။ Linux kernel က ကြီးမားတဲ့ open-source project တခုဖြစ်ပြီး မည်သူမဆို စိတ်ပါ၀င်စားသူတိုင်း Contribute လုပ်နိုင်ပါတယ်။ Linux kernel ကို Contribute လုပ်တဲ့ Workflow က တခြား Open-Source Project တွေနဲ့ တူမှာ မဟုတ်ပါဘူး။ GitHub သို့မဟုတ် GitLab တို့ကို သုံးပြီး Code တွေကို Contribute လုပ်လို့မရပါဘူး။ အဓိက Linux kernel မှာ Linux Kernel Mailing List (LKML) ကို သုံးပြီး Git နဲ့ Email ကနေ တဆင့် Kernel Patches (Fixed Code) တွေကို Submit လုပ်ပြီး Kernel Maintainers တွေက Review လုပ်ပြီး နောက်ပိုင်း Code တွေကို Merge လုပ်တဲ့နည်းနဲ့ Linux kernel မှာ Contribute လုပ်ရတာဖြစ်ပါတယ်။

# Content List
- Setup Email Client
- Make Fixes
- Compile Kernel Code
- Git diff
- Git commit
- Git show
- Git format-patch
- Check Kernel Patch
- Get Kernel Maintainers
- Git send-email

## Setup Email Client
ပထမဆုံးအနေနဲ့ gitconfig မှာ Email Client ကို Setup လုပ်ပေးဖို့ လိုအပ်ပါတယ်။

Text Editor တခုခုကို သုံးပြီး ".gitconfig" မှာ ကိုသုံးမယ့် Email Client ကို Setup လုပ်ပါမယ်။

```
zawzaw@ubuntu-linux:~$ vim ~/.gitconfig
```

For example: Gmail

```
[user]
        name = Zaw Zaw
        email = youremailaddr@mail.com

# Setup Eamil Client for using git send-mail.
[sendemail]
        smtpuser = youremailaddr@mail.com
        smtpserver = smtp.googlemail.com
        smtpencryption = tls
        smtpserverport = 587

[core]
        editor = vim

[color]
        ui = auto
```

## Make Fixes
Linux kernel source tree ကို [https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git) ကနေ တဆင့် source code ကို ရယူနိုင်ပါတယ်။ ဘာတွေ Fix လုပ်မလဲဆိုရင် Linux kernel development ကို အတိုင်းတာတခုထိ လေ့လာထားမှသာ ပိုပြီးသိလာပါလိမ့်မယ်။ ကိုယ်ရဲ့ စိတ်၀င်စားမှုပေါ်မှာ မူတည်ပါတယ်။ အစပိုင်းမှာ Linux kernel တခုလုံးကို အကုန်လိုက်လုပ်စရာ မလိုပါဘူး။ ဥပမာ - ကိုယ်က File systems ကို စိတ်၀င်စားတာလား၊ Devie Drivers ကို စိတ်၀င်စားတာလား၊ Networking subsystem ကို စိတ်၀င်စားတာလား၊ Memory Management ကို စိတ်၀င်စားတာလား စသဖြင့် တခုခုကနေ စလို့ရပါတယ်။ တခုဆိုတခု လုပ်ခြင်းအားဖြင့် ပိုပြီး ထိရောက်ပါလိမ့်မယ်။

အခု Blog post မှာ ကျွန်တော်က Clang compiler version 9 နဲ့ Linux kernel build လုပ်တဲ့အခါ build error ကို Fix လုပ်ထားတာလေးကို နမူနာအနေနဲ့ ပြောသွားမှာဖြစ်ပါတယ်။

မူးရင်း `master` branch ကနေ `dev/zawzaw` branch အသစ်တခု Local မှာ create လုပ်လိုက်ပါမယ်။

```
git branch dev/zawzaw
```

```
git checkout dev/zawzaw
```

Fixed kernel code and file location: `linux/arch/x86/include/asm/bitops.h`

![Screenshot](/assets/images/screenshots/img_screenshot_make_fixes.png)

## Compile Kernel Code
ဒီနေရာမှာတော့ ကိုယ်ပြင်လိုက်တဲ့ Kernel Code က ဘယ်လို Build error တွေ ရှိလား၊ မရှိဘူးလား ဆိုတာကို ပြန် Compile လုပ်ပြီး Testing လုပ်တဲ့အပိုင်းဖြစ်ပါတယ်။

Kernel source tree ကို သွားပြီး Kernel configuration လုပ်ပြီး Compile လုပ်ပါမယ်။ Compiler က Default compiler ဖြစ်တဲ့ GCC ကို မသုံးဘဲ Clang ကို ကျွန်တော်က သုံးတာဖြစ်တာကြောင့် `CC=clang` ဆိုပြီး ထည့်ပေးတာဖြစ်ပါတယ်။ နောက်ပိုင်း Clang Compiler နဲ့ Linux kernel ကို Compile လုပ်တဲ့အကြောင်းကို ရေးဖို့ရှိပါတယ်။

```
make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_recompile_kernel.png)

```
make CC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_recompile_kernel_complete.png)

## Git diff
ကိုယ်ပြင်ထားတာကို `git diff` လုပ်ပြီး Changes တွေကို အရင် ကြည့်ကြည့်ပါမယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_git_diff.png)

## Git commit
ကိုယ် Change လိုက်တဲ့ Code တွေကို `git commit` လုပ်ပါမယ်။ ဒီနေရာမှာ ပြီးပြီရောပုံစံမျိုး commit လုပ်လို့မရပါဘူး တခြားသူတွေလည်း ဖက်လိုက်ရင် နားလည်အောင် သေချာရေးပေးဖို့လိုပါတယ်။

```
git commit -a
```

![Screenshot](/assets/images/screenshots/img_screenshot_git_commit.png)

## Git show
ကိုယ် commit လုပ်လိုက်တဲ့ commite messages တွေနဲ့ changes တွေကို `git show` နဲ့ ပြန်ကြည့်နိုင်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_git_show.png)

## Git format-patch
ဒီနေရာမှာ ကိုယ်လုပ်လိုက်တဲ့ Fixes တွေကို patch အဖြစ် Generate လုပ်မှာ ဖြစ်ပါတယ်။ နောက်တဆင့်မှာ Generate လုပ်လိုက်တဲ့ Kernel Patches တွေကို Email ကနေ Submit လုပ်မှာ ဖြစ်ပါတယ်။

ကိုယ့်ရဲ့ Local branch တွေကို `git branch` နဲ့ အရင်ကြည့်ပါမယ်။

```
zawzaw@ubuntu-linux:~/Linux-kernel/linux$ git branch
* dev/zawzaw
  master
```

Patch Generate လုပ်ပါမယ်။

```
git format-patch master..dev/zawzaw
```

Generate လုပ်လိုက်တဲ့ patch file ကို Text Editor တခုခုနဲ့ ဖွင့်လိုက်ရင် အခုလိုမျိုး မြင်တွေ့ရမှာဖြစ်ပါတယ်။ တနည်းအားဖြင့် အဲဒီကောင်ကို `git send-mail` ပို့မှာ ဖြစ်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_git_format_patch.png)

## Check Kernel Patch
Linux kernel source tree မှာ အသုံး၀င်တဲ့ Tools တွေ Scripts တွေ အများကြီးရှိနေပါတယ်။ ကိုယ်ရဲ့ Kernel Patch ကို Email ကနေ Submit မလုပ်ခင် ဘယ်လို  Errors တွေ၊ ဘယ်လို Warnings တွေ ရှိလဲ ဆိုတာကို `checkpatch.pl` နဲ့ Check လုပ်နိုင်ပါတယ်။

Linux kernel source tree မှာ `checkpatch.pl` ကို Run ပေးဖို့လိုပါတယ်။

```
./scripts/checkpatch.pl 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

![Screenshot](/assets/images/screenshots/img_screenshot_checkpatch.png)

## Get Kernel Maintainers
Kernel Patch ကို ဘယ် Kernel maintainers ဆီကို ပို့ရမလဲဆိုတာ ခေါင်းစားစရာ မလိုပါဘူး။ ကိုယ့်ရဲ့ Patch ကို Email ကနေ Submit မလုပ်ခင်မှာ ဘယ် Maintainer ဆီကို ပို့မလဲဆိုတာကို `get_maintainer.pl` နဲ့ ကြည့်နိုင်ပါတယ်။ Linux kernel subsystem တခုချင်းစီအလိုက် maintainers တွေ အသီးသီးရှိပါတယ်။ Patch ကို မပို့ခင်မှာ ဘယ် Maintainer ဆီကို ကိုယ့်ရဲ့ Patch ကို ပို့ရမလဲဆိုတာ သိထားဖို့လိုပါတယ်။

Linux kernel tree မှာ `get_maintainer.pl` ကို Run ပေးဖို့ လိုပါတယ်။

```
./scripts/get_maintainer.pl 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

![Screenshot](/assets/images/screenshots/img_screenshot_get_maintainers.png)

## Git send-mail
အပေါ်ကအဆင့်တွေ ပြီးသွားရင် Patch ကို `git send-mail` နဲ့ သက်ဆိုင်ရာ Maintainers တွေဆီ ပို့ပေးမှာဖြစ်ပါတယ်။

```
git send-mail --to mingo@redhat.com --cc hpa@zytor.com --cc jesse.brandeburg@intel.com --cc linux-kernel@vger.kernel.org --cc clang-built-linux@googlegroups.com 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

Kernel maintainers ဆီကို Patch ကို `git send-mail` နဲ့ ပို့လိုက်မှာ ဖြစ်ပါတယ်။ အဲဒီနောက် Eamil ကနေ ကိုယ့်ရဲ့ Patch ကို Review လုပ်မှာ ဖြစ်ပါတယ်။ အပြန်အလှန် Feedback လုပ်ဖို့ ဆွေးနွေးဖို့အတွက် Email client software တခုခုကို သုံးနိုင်ပါတယ်။ Mutt သို့မဟုတ် တခြားတခုခု သုံးနိုင်ပါတယ်။ အားလုံးပြီးသွားရင် ကိုယ့်ရဲ့ Patch က Review လုပ်ပြီးသွားရင် လက်ခံရရှိတဲ့ Maintainer က `git am` ကို သုံးပြီး Mailbox ကနေ ၀င်လာတဲ့ Patch ကို Apply လုပ်ပေးမှာဖြစ်ပါတယ်။ အဲဒီလိုနည်းလမ်းနဲ့ Linux kernel ကို Contribute လုပ်နိုင်မှာဖြစ်ပါတယ်။
