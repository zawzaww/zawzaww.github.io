---
layout: post
title: "Contributing to the Linux kernel"
categories: [linux, kernel]
author: Zaw Zaw
image:
  src: /assets/images/featured-images/img_linux_kernel_contribution.png
---

Linux kernel ကို Contribute လုပ်တဲ့အပိုင်းမှာ ဘယ်လို Contribute လုပ်မလဲဆိုတဲ့ Workflow ကို အခု article မှာ အဓိကထား ပြောသွားမှာဖြစ်ပါတယ်။ Linux kernel က free and open-source software project တခုဖြစ်ပြီး မည်သူမဆို စိတ်ပါ၀င်စားသူတိုင်း Contribute လုပ်နိုင်ပါတယ်။ Linux kernel ကို Contribute လုပ်တဲ့ Workflow က တခြား open-source projects တွေနဲ့ တူမှာ မဟုတ်ပါဘူး။ GitHub သို့မဟုတ် GitLab တို့ကို သုံးပြီး Code တွေကို Contribute လုပ်လို့မရပါဘူး။ Linux kernel မှာ Linux Kernel Mailing List (LKML) ကို သုံးပြီး Git နဲ့ Email ကနေ တဆင့် Kernel Patches တွေကို Submit လုပ်မယ်၊ Kernel Maintainers တွေက Review လုပ်ပေးမယ်။ ပြီးတဲ့နောက် Submit လုပ်လိုက်တဲ့ Kernel Patches နဲ့ ပတ်သက်ပြီး Maintainers တွေ၊ Reviewers တွေနဲ့ Email ကနေ တဆင့် အပြန်အလှန် Discuss လုပ်ပြီး Code တွေကို Merge လုပ်တဲ့နည်းနဲ့ Linux kernel source tree မှာ Contribute လုပ်ရမှာဖြစ်ပါတယ်။

အတိုချုပ်အနေနဲ့ List လုပ်လိုက်ရင်

- Setup Email Client
- Make Fixes
- Build Kernel Code
- Git diff
- Git commit
- Git show
- Git format-patch
- Check Kernel Patch
- Get Kernel Maintainers
- Git send-mail

ဆိုပြီး ရှိမှာဖြစ်ပါတယ်။ အောက်မှာ တခုချင်းစီအတွက် တဆင့်ချင်း အသေးစိတ်ပြောပြသွားမှာဖြစ်ပါတယ်။

# Setup Email Client
ပထမဆုံးအနေနဲ့ gitconfig မှာ Email Client ကို Setup လုပ်ပေးဖို့ လိုအပ်ပါတယ်။

Text Editor တခုခုကို သုံးပြီး `.gitconfig` မှာ ကိုသုံးမယ့် Email Client ကို Setup လုပ်ပါမယ်။

```bash
zawzaw@ubuntu-linux:~$ vim ~/.gitconfig
```

For example: Gmail

```bash
[user]
        name = Your Name
        email = youremailaddr@mail.com

# Setup Eamil Client for using git send-mail.
[sendemail]
        smtpuser = youremailaddr@mail.com
        smptpass = yourpassword
        smtpserver = smtp.googlemail.com
        smtpencryption = tls
        smtpserverport = 587

[core]
        editor = vim

[color]
        ui = auto
```

# Make Fixes
Linux kernel main source tree ကို [https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git) ကနေ တဆင့် source code ကို ရယူနိုင်ပါတယ်။ ဘာတွေ Fix လုပ်မလဲ ဘယ်အပိုင်းတွေကို Fix ပြီး Contribute လုပ်မလဲဆိုတာတော့ ပြောရခက်ပါတယ်။ တခြား Software project တွေလိုမျိုး လုပ်နေရင်းနဲ့ သိလာတာမျိုးပါပဲ။ Kernel Hacking ပိုင်း စိတ်၀င်စားရင်တော့ [Linux Kernel Newbies](https://kernelnewbies.org/KernelHacking) မှာ လေ့လာနိုင်ပါတယ်။ ကိုယ်ရဲ့ စိတ်၀င်စားမှုပေါ်မှာ မူတည်ပါတယ်။ ပထမ အစပိုင်းမှာ Linux kernel တခုလုံးရဲ့ Subsystem အကုန်လုံးကို လိုက်လုပ်စရာ မလိုပါဘူး။ Linux kernel subsystems တွေကို Category ခွဲကြည့်လိုက်ရင် File Systems: `/linux/fs`, Kernel Device Drivers/Modules: `/linux/drivers`, Networking: `/linux/net`, Kernel Security (e.g SELinux, Kernel lockdown and etc..): `/linux/security` စသဖြင့် Kernel Subsystems တွေက အများကြီး ရှိနေပါတယ်။ တခုခုကို အစပိုင်း Specialize လုပ်ပြီး လေ့လာသင့်ပါတယ်။ တခြား Kernel Subsystem နဲ့စာရင် တကယ့် Embedded Linux World မှာ Embedded Hardware Devices အတွက် Kernel Device Drivers/Modules တွေ ရေးတာက ပိုပြီး Popular ဖြစ်ပြီး လေ့လာလိုက်စားသူ များပါတယ်။ ကျွန်တော့်အနေနဲ့လည်း တခြား Kernel Subsystems တွေကို အများကြီး မလုပ်ဖူးသေးပါဘူး။ Kernel Device Drivers အပိုင်းမှာပဲ Specialize လုပ်ပြီး အဓိကထားပြီး လေ့လာနေတဲ့သူတယောက်ပါပဲ။

Linux Kernel Device Drivers ရေးတာနဲ့ ပတ်သက်ပြီ: Recommend ပေးချင်တဲ့ စာအုပ်တအုပ်ရှိပါတယ်။ [Linux Device Drivers, Third Edition](https://www.oreilly.com/library/view/linux-device-drivers/0596005903/) စာအုပ်သည် Linux Kernel Device Drivers ကို လေ့လာဖို့အတွက် ကောင်းတဲ့စာအုပ်တအုပ်ပဲ ဖြစ်ပါတယ်။ အခုအခါ O'Reilly Open Books Project မှာ Creative Commons Attribution-ShareAlike 2.0 license အောက်ကနေ free book အနေနဲ့ ရယူနိုင်ပါတယ်။

[O'Reilly Open Book: Linux Device Drivers Book, Third Edition.](https://www.oreilly.com/openbook/linuxdrive3/book/)

[LWN.net: Linux Device Drivers Book, Third Edition.](https://lwn.net/Kernel/LDD3/)

<img src="https://mhatsu.to/content/images/2020/06/linux-device-drivers-book.jpg" />
<p align="center"><sub><sup>Book Cover Photo by: O'Reilly Open Books Project</sup></sub></p>

အခု Blog post မှာ ကျွန်တော်က LLVM/Clang Compiler version 9 နဲ့ Linux kernel build လုပ်တဲ့အခါ build error ကို Fix လုပ်ထားတာလေးကို နမူနာအနေနဲ့ ပြောသွားမှာဖြစ်ပါတယ်။

မူရင်း `master` branch ကနေ `dev/zawzaw` branch အသစ်တခု Local မှာ create လုပ်လိုက်ပါမယ်။

```bash
git branch dev/zawzaw
```

```bash
git checkout dev/zawzaw
```

Fixed kernel build error in LLVM/Clang compiler version 9: `linux/arch/x86/include/asm/bitops.h`

![Screenshot](/assets/images/screenshots/img_screenshot_make_fixes.png)
<p align="center"><sub><sup>Architecture specific x86_64 bit operations: linux/arch/86/include/asm/bitops.h</sup></sub></p>

# Build Kernel Code
ဒီနေရာမှာတော့ ကိုယ်ပြင်လိုက်တဲ့ Kernel Code က ဘယ်လို Build error တွေ ရှိလား၊ မရှိဘူးလား ဆိုတာကို ပြန် Compile လုပ်ပြီး Testing လုပ်တဲ့အပိုင်းဖြစ်ပါတယ်။

Kernel source tree ကို သွားပြီး Kernel configuration လုပ်ပြီး Compile လုပ်ပါမယ်။ Compiler က Default compiler ဖြစ်တဲ့ GCC ကို မသုံးဘဲ Clang/LLVM ကို ကျွန်တော်က သုံးတာဖြစ်တာကြောင့် `CC=clang` ဆိုပြီး ထည့်ပေးတာဖြစ်ပါတယ်။ Clang/LLVM Compiler နဲ့ Linux Kernel Build လုပ်တဲ့အကြောင်းကို [Compiling Linux Kernel with Clang/LLVM Compiler](https://zawzaww.github.io/blog/kernel/compile-linux-clang-llvm) article မှာ ရေးထားပါတယ်။

```bash
make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_recompile_kernel.png)

```bash
make CC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_recompile_kernel_complete.png)

# Git diff
ကိုယ်ပြင်ထားတာကို `git diff` လုပ်ပြီး Changes တွေကို အရင် ကြည့်ကြည့်ပါမယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_git_diff.png)

# Git commit
ကိုယ် Change လိုက်တဲ့ Code တွေကို `git commit` လုပ်ပါမယ်။ ဒီနေရာမှာ ပြီးပြီရောပုံစံမျိုး commit လုပ်လို့မရပါဘူး တခြားသူတွေလည်း ဖက်လိုက်ရင် နားလည်အောင် သေချာရေးပေးဖို့လိုပါတယ်။

```bash
git commit -a
```

![Screenshot](/assets/images/screenshots/img_screenshot_git_commit.png)

# Git show
ကိုယ် commit လုပ်လိုက်တဲ့ commite messages တွေနဲ့ changes တွေကို `git show` နဲ့ ပြန်ကြည့်နိုင်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_git_show.png)

# Git format-patch
ဒီနေရာမှာ ကိုယ်လုပ်လိုက်တဲ့ Fixes တွေကို patch အဖြစ် Generate လုပ်မှာ ဖြစ်ပါတယ်။ နောက်တဆင့်မှာ Generate လုပ်လိုက်တဲ့ Kernel Patches တွေကို Email ကနေ Submit လုပ်မှာ ဖြစ်ပါတယ်။

ကိုယ့်ရဲ့ Local branch တွေကို `git branch` နဲ့ အရင်ကြည့်ပါမယ်။

```bash
zawzaw@ubuntu-linux:~/Linux-kernel/linux$ git branch
* dev/zawzaw
  master
```

Patch Generate လုပ်ပါမယ်။

```bash
git format-patch master..dev/zawzaw
```

Generate လုပ်လိုက်တဲ့ patch file ကို Text Editor တခုခုနဲ့ ဖွင့်လိုက်ရင် အခုလိုမျိုး မြင်တွေ့ရမှာဖြစ်ပါတယ်။ တနည်းအားဖြင့် အဲဒီကောင်ကို `git send-mail` ပို့မှာ ဖြစ်ပါတယ်။

![Screenshot](/assets/images/screenshots/img_screenshot_git_format_patch.png)

# Check Kernel Patch
Linux kernel source tree မှာ အသုံး၀င်တဲ့ Tools တွေ Scripts တွေ အများကြီးရှိနေပါတယ်။ ကိုယ်ရဲ့ Kernel Patch ကို Email ကနေ Submit မလုပ်ခင် ဘယ်လို  Errors တွေ၊ ဘယ်လို Warnings တွေ ရှိလဲ ဆိုတာကို `checkpatch.pl` နဲ့ Check လုပ်နိုင်ပါတယ်။

Linux kernel source tree မှာ `checkpatch.pl` ကို Run ပေးဖို့လိုပါတယ်။

```bash
./scripts/checkpatch.pl 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

![Screenshot](/assets/images/screenshots/img_screenshot_checkpatch.png)

# Get Kernel Maintainers
Kernel Patch ကို ဘယ် Kernel maintainers ဆီကို ပို့ရမလဲဆိုတာ ခေါင်းစားစရာ မလိုပါဘူး။ ကိုယ့်ရဲ့ Patch ကို Email ကနေ Submit မလုပ်ခင်မှာ ဘယ် Maintainer ဆီကို ပို့မလဲဆိုတာကို `get_maintainer.pl` နဲ့ ကြည့်နိုင်ပါတယ်။ Linux kernel subsystem တခုချင်းစီအလိုက် maintainers တွေ အသီးသီးရှိပါတယ်။ Patch ကို မပို့ခင်မှာ ဘယ် Maintainer ဆီကို ကိုယ့်ရဲ့ Patch ကို ပို့ရမလဲဆိုတာ သိထားဖို့လိုပါတယ်။

Linux kernel tree မှာ `get_maintainer.pl` ကို Run ပေးဖို့ လိုပါတယ်။

```bash
./scripts/get_maintainer.pl 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

![Screenshot](/assets/images/screenshots/img_screenshot_get_maintainers.png)

# Git send-mail
အပေါ်ကအဆင့်တွေ ပြီးသွားရင် Patch ကို `git send-mail` နဲ့ သက်ဆိုင်ရာ Maintainers တွေဆီ ပို့ပေးမှာဖြစ်ပါတယ်။

```bash
git send-mail --to mingo@redhat.com --cc hpa@zytor.com --cc jesse.brandeburg@intel.com --cc linux-kernel@vger.kernel.org --cc clang-built-linux@googlegroups.com 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

Kernel patch ကို ```git send-mail``` နဲ့ ပို့တဲ့နေရာမှာ ```--to``` က ကိုယ်ပို့မယ့် Kernel subsystem ရဲ့ အဓိက Maintainer ဖြစ်ရပါမယ်။ ```--cc``` ခံတဲ့နေရာမှာတော့ Reviewers တွေနဲ့ Open Public Mailing Lists တွေ ဖြစ်သင့်ပါတယ်။ Open List ဆိုတာက Kernel subsystem တခုချင်းစီမှာ Mailing List တွေ ရှိပါတယ်။

ဥပမာ။ ။ ```linux-kernel@vger.kernel.org``` သည် အဓိက Linux Kernel Mailing List (LKML) ဖြစ်ပြီး၊ ```clang-built-linux@googlegroups.com``` သည် Linux kernel အတွက် Clang compiler သုံးပြီး build လုပ်တာနဲ့ပတ်သက် submit လုပ်နိုင်တဲ့ Mailing List ဖြစ်ပါတယ်။ Mailing List အားလုံးရဲ့ email address တွေကို [http://vger.kernel.org/vger-lists.html](http://vger.kernel.org/vger-lists.html) ၀င်ရောက်ကြည့်နိုင်ပါတယ်။ ပြီးရင် စိတ်၀င်စားတဲ့ Kernel subsystems ရဲ့ Mailing List ကို ကိုယ်သုံးမယ့် email နဲ့ Subscribe လုပ်ထားနိုင်ပါတယ်။

Kernel maintainers ဆီကို Generate လုပ်ထားတဲ့ Kernel Patch ကို ```git send-mail``` နဲ့ ပို့လိုက်မှာ ဖြစ်ပါတယ်။ အဲဒီနောက် Eamil ကနေ ကိုယ့်ရဲ့ Patch ကို Review လုပ်မှာ ဖြစ်ပါတယ်။ အပြန်အလှန် Feedback လုပ်ဖို့ Kernel Maintainers တွေ Cc ခံထားတဲ့ Reviewers တွေနဲ့ ဆွေးနွေးဖို့အတွက် Email client software တခုခုကို သုံးနိုင်ပါတယ်။ Email Client Software အတွက် [Mutt](http://www.mutt.org/) သုံးလည်း ရပါတယ် သို့မဟုတ် Official Linux kernel documentation ရဲ့ [Email Clients for Linux](https://www.kernel.org/doc/html/latest/process/email-clients.html) မှာ Recommended ပေးထားတဲ့ Email Client Software တွေကို သုံးရင်လည်း ရပါတယ်။ အားလုံးပြီးသွားရင် ကိုယ့်ရဲ့ Patch ကို Kernel Maintainers တွေက Email ကနေ တဆင့် Review လုပ်ပြီးလို့ Approve လုပ်တယ်ဆိုရင်တော့ လက်ခံရရှိတဲ့ Maintainer က ```git am``` ကို သုံးပြီး Mailbox ကနေ ၀င်လာတဲ့ ကိုယ်ရဲ့ Patch ကို Apply လုပ်ပေးမှာဖြစ်ပါတယ်။ အဲဒီလိုနည်းလမ်းနဲ့ Linux kernel ကို Contribute လုပ်နိုင်မှာဖြစ်ပါတယ်။

Video Tutorial နဲ့ လေ့လာချင်ရင် FOSDEM, 2010 မှာ Linux kernel stable tree maintainer and Lead developer ဖြစ်တဲ့ Greg Kroah-Hartman ပြောပြထားတဲ့ [Write and Submit your First Linux Kernel Patch](https://www.youtube.com/watch?v=LLBrBBImJt4&t=1079s) ကနေ လေ့လာကြည့်နိုင်ပါတယ်။
