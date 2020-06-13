---
layout: post
title: "Kernel Design: Monolithic Versus Microkernel"
categories: kernel
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_monolithic_microkernel.png
permalink: blog/kernel/monolithic-and-microkernel
---

ဒီနေ့မှ MINIX Operating System Discussion Group (comp.os.minix) မှာ ဖြစ်ခဲ့ Tanenbaum-Torvalds debate ရဲ့ Origin Thread ကို ဖက်ကြည့်ရင်း အခု article ရေးဖြစ်သွားတာပါ။ အခု article မှာ Monolithic kernel design နဲ့ Microkernel design ရဲ့ ကွာခြားချက်တွေကို အဓိကပြောသွားမှာ ဖြစ်ပါတယ်။ အရင်ဆုံး Tanenbaum-Torvalds debate အကြောင်းကို သိရအောင် အတိုချုပ်ပြောပါမယ်။ ပြီးရင်တော့ Monolithic kernel နဲ့ Microkernel ရဲ့ အချက်လက်တွေကို တခုချင်း ပြောပေးသွားမှာ ဖြစ်ပါတယ်။

# Tanenbaum-Torvalds Debate
Tanenbaum-Torvalds Debate ကို ဟိုတခါ ကိုသက်ခိုင် ရေးထားတာတွေ့လို့ Wikipedia မှာ ဖက်ကြည့်ရင်း သိခဲ့တာတော့ ကြာပါပြီ။ ဒါပေမယ့် MINIX Operating System Discussion Group မှာ တကယ်အပြန်အလှန် Debate လုပ်ခဲ့တဲ့ မူရင်း Thread ကို ခုမှ ဖက်ကြည့်ဖြစ်ပါတယ်။ အဲဒီ Debate ကို 1992 မှာ MINIX Operating System ရဲ့ Author ဆရာကြီး Tanenbaum (also known as ast) က [LINUX is obsolete](https://groups.google.com/g/comp.os.minix/c/wlhw16QWltI) ဆိုတဲ့ subject နဲ့ စတင်ခဲ့တယ်။ အတိုချုပ်ပြောပြရရင် Kernel Design ပိုင်း ဖြစ်တဲ့ Monolithic kernel နဲ့ Microkernel ကို Debate လုပ်ကြတာပါ။ တနည်းအားဖြင့် MINIX vs LINUX ကို Professor ဆရာကြီးနဲ့ Torvalds နှင့် သူရဲ့ Linux kernel developers တွေ ပညာသားပါပါနဲ့ MINIX Operating System Discussion Group (comp.os.minix) မှာ Flame war ဖြစ်ခဲ့ကြတာပါ။ စိတ်ဝင်စားရင်တော့ Google Groups က မူးရင် Thread မှာ ဆက်ဖက်ကြည့်နိုင်ပါတယ်။

Read Origin Thread on Google Groups: [LINUX is obsolete](https://groups.google.com/g/comp.os.minix/c/wlhw16QWltI)

![Screenshot](/assets/images/screenshots/img_screenshot_ast_torvalds_debate.png)


# Kernel Designs
Monolithic kernel နဲ့ Microkernel design နှစ်ခုလုံးမှာ အားသာချက် အားနည်းချက်တွေ ရှိပါတယ်။ ဘယ်အရာမဆို ပြီးပြည့်စုံတယ်ဆိုတာ မရှိပါဘူး။ သူ့နေရာသူ အားသာချက် အားနည်းချက်တွေ ရှိကြစမြဲပါပဲ။ Monolithic kernel design ကတော့ Design ချခဲ့တာက ကြာခဲ့ပြီး Old kernel design လို့ ပြောနိုင်တယ်။ Microkernel ကတော့ Modern kernel design လို့ ‌ပြောလို့ရပါတယ်။ Personally ကတော့ ဘယ် Kernel Design က ပိုကောင်းတယ် မကောင်းဘူးဆိုတာတော့ မပြောလိုပါဘူး။ Kernel Design နှစ်ခုရဲ့ ကွာခြားတဲ့ မတူညီတဲ့အချက်တွေကို ပြောပြရုံသာ ဖြစ်ပါတယ်။ သူ့နေရာသူ့ ကောင်းတာချည်းပါပဲ။ အဓိက အသုံးများတဲ့ Kernel Design သုံးမျိုးကတော့ Monolithic kernel ရယ် Microkernel နဲ့ Hybrid kernel တွေပဲ ဖြစ်ပါတယ်။ Apple ရဲ့ Operating Systems (macOS, iOS, watchOS, tvOS) တွေမှာ သုံးတဲ့ XNU kernel သည် Hybrid kernel design ကို အခြေခံထားတာ ဖြစ်ပါတယ်။ ကျွန်တော့်အနေနဲ့တော့ Monolithic kernel ဖြစ်တဲ့ Linux kernel development ကို လေ့လာရင်း လုပ်နေတဲ့အတွက် Monolithic kernel နဲ့ Microkernel နဲ့ ယှဥ်တွဲပြီး မတူညီတဲ့အချက်တွေကို တချက်ချင်းစီ ဆက်ပြောပြသွားမှာ ဖြစ်ပါတယ်။

# Kernel Design: Monolithic

![Screenshot](/assets/images/screenshots/img_screenshot_monolithic.png)

## Pros of Monolithic kernel

- Monolithic kernel တွေက Loadable Kernel Module (LKM) Support လုပ်တယ်။ Device Drivers တွေကို Modules များ‌အဖြစ် ရေးနိုင်တယ်။ Kernel Runtime မှာ Kernel Modules တွေ လိုအပ်သလို Dynamically Loaded/Unloaded လုပ်နိုင်တယ်။ ဒါကြောင့် "Linux is modular." လို့ ပြောတာတွေ တွေ့ဖူးပါလိမ့်မယ်။

- Linux (monilithic kernel) မှာဆိုရင် Portability ဖြစ်တယ်။ ဆိုလိုတဲ့သဘောက OS kernel သည် Intel x86 architecture ကိုလည်း Support လုပ်နိုင်တယ်။ နောက်ထပ် architecture တခု ဖြစ်တဲ့ ARM arm64 အတွက်လည်း Support လုပ်တယ်။ နောက်ထပ် architecture တွေ ဖြစ်တဲ့ mips, powerpc, m68k, m68k, alpha, arm, hexagon အစရှိသဖြင့် OS kernel တခုသည် computer architectures တွေကို wide range support လုပ်တယ်ဆိုရင် Portability ဖြစ်တယ်လို့ ပြောကြပါတယ်။ Computer system architecture တခုကနေ နောက်ထပ် architecutre တခုအတွက် Portable C code တွေကို Implement လုပ်ထားတဲ့အတွက်ကြောင့် အလွယ်တကူရွေ့လို့ရတယ် Porting လုပ်နိုင်တယ်ဆိုရင် Portability ဖြစ်တဲ့ OS kernel လို့ Operating Systems World မှာ ခေါ်ကြပါတယ်။
Linux မှာဆိုရင် ဆိုရင် Support လုပ်တဲ့ architecture တွေကို linux/arch ၀င်ကြည့်နိုင်ပါတယ်။

```
zawzaw@ubuntu-linux:~/Linux-Kernel/linux/arch$ ls -l
total 132
drwxr-xr-x 10 zawzaw zawzaw  4096 Feb  8 15:17 alpha
drwxr-xr-x 14 zawzaw zawzaw  4096 Jun  5 10:49 arc
drwxr-xr-x 96 zawzaw zawzaw  4096 Jun 11 07:47 arm
drwxr-xr-x 12 zawzaw zawzaw  4096 Jun 12 11:19 arm64
drwxr-xr-x  9 zawzaw zawzaw  4096 Jun 11 07:47 c6x
drwxr-xr-x 10 zawzaw zawzaw  4096 May 18 13:28 csky
drwxr-xr-x  8 zawzaw zawzaw  4096 Jun 11 07:47 h8300
drwxr-xr-x  7 zawzaw zawzaw  4096 Jun  8 20:44 hexagon
drwxr-xr-x 12 zawzaw zawzaw  4096 Jun  8 20:44 ia64
-rw-rw-r--  1 zawzaw zawzaw 29429 Jun 11 07:47 Kconfig
drwxr-xr-x 25 zawzaw zawzaw  4096 Jun 11 07:47 m68k
drwxr-xr-x 10 zawzaw zawzaw  4096 Jun  4 14:36 microblaze
drwxr-xr-x 51 zawzaw zawzaw  4096 Jun 13 07:46 mips
drwxr-xr-x  9 zawzaw zawzaw  4096 Feb  8 15:17 nds32
drwxr-xr-x  9 zawzaw zawzaw  4096 May 18 13:28 nios2
drwxr-xr-x  8 zawzaw zawzaw  4096 May 18 13:28 openrisc
drwxr-xr-x 10 zawzaw zawzaw  4096 Jun  8 20:44 parisc
drwxr-xr-x 20 zawzaw zawzaw  4096 Jun  6 07:26 powerpc
drwxr-xr-x  9 zawzaw zawzaw  4096 Jun 12 11:19 riscv
drwxr-xr-x 19 zawzaw zawzaw  4096 Jun  5 10:49 s390
drwxr-xr-x 14 zawzaw zawzaw  4096 Jun  8 20:44 sh
drwxr-xr-x 15 zawzaw zawzaw  4096 Jun  4 14:36 sparc
drwxr-xr-x  8 zawzaw zawzaw  4096 Jun  8 20:44 um
drwxr-xr-x  8 zawzaw zawzaw  4096 Jun 11 07:47 unicore32
drwxr-xr-x 27 zawzaw zawzaw  4096 Jun 13 07:46 x86
drwxr-xr-x 11 zawzaw zawzaw  4096 May 18 13:28 xtensa
```

- Monolithic kernel တွေက Operating System (OS) တခုလုံးရဲ့ Services တွေကို Kernel-space မှာပဲ အလုပ်လုပ်တယ်။ ဆိုလိုတဲ့သဘောကတော့ Device Drivers, I/O, File Systems, IPC, Process Scheduling, Process Management, Memory Management စတာတွေ အကုန်လုံးသည် Kernel-space မှာပဲ အလုပ်လုပ်တယ်။ User-space မှာ Applications နဲ့  Libraries : C Library (libc) / GNU C Library (glibc) တွေသာ ရှိပါလိမ့်မယ်။ အဲဒါကြောင့် အပေါ်မှာပြှထားတဲ့ပုံမှာ ကြည့်ရင် Kernel mode မှာ OS တခုလုံးရဲ့ အရေကြီးတဲ့အရာတွေ အလုပ်လုပ်ပြီး၊ User mode မှာ Applications တွေသာ အလုပ်လုပ်ကြောင်း တွေ့နိုင်ပါတယ်။

- Monolithic kernel တွေက ကြီးမားတဲ့ Single Process တခုတည်းကိုပဲ တူညီတဲ့ Single Address Sapce မှာပဲ Run ပါတယ်၊ အလုပ်လုပ်တယ်။

- Performace ပိုင်းမှာ အရမ်းကောင်းပါတယ်။ ဘာကြောင့်လဲဆိုတော့ Kernel-space မှာ ရှိနေတဲ့ ဘယ် function ကို မဆို permission မှ မလိုပဲ monolithic kernel က တိုက်ရိုက် Invoke လုပ်နိုင်ပါတယ်။ Microkernel လို Kernel ရဲ့ permission စောင့်စရာမလိုပဲ function တွေကို Directly invoke လုပ်နိုင်တဲ့အတွက် အချိန်ကုန်သက်သာပြီး Execution time က ပိုမြန်တယ်။ ဒါကြောင့် Performance ပိုင်းမှာ ပိုကောင်းပါတယ်။

- Monolithic kernel တွေက Single static binary file တခုတည်းကိုသာ ထုတ်ပေးပါတယ်။

- Monolithic kernel တွေက "Easy to program" သို့မဟုတ် "Easy to Code" လို့ ပြောလို့ရမယ်။ Programmer တယောက်က Kernel Device Driver/Kernel Module တခု ဒါမှမဟုတ် Feature တခု ရေးမယ်ဆိုရင် Monolithic kernel တွေက Code ရေးရတာ နည်းတယ် ပိုပြီးလွယ်ကူပါတယ်။ ဘာကြောင့်လဲဆိုတော့ Kernel-space မှာ Kernel Framework & APIs တွေ အဆင့်သင့် Implement လုပ်ထားတဲ့အတွက်ကြောင့် ဖြစ်ပါတယ်။
ဥပမာ။ ။ Android development နဲ့ ဥပမာပေး ပြောပြရရင် Linux kernel drivers နဲ့ kernel modules ရေးရတာက Android မှာ ဆိုရင် App ရေးရတာနဲ့ တူပါတယ်။ Android OS platform ဘက်ကနေ Platform APIs တွေ Support ပေးထားပြီး၊ App ဘက်ကနေ ဘယ်လိုခေါ်သုံးရမလဲဆိုတာသာ သိထားဖို့လိုပါတယ်။ ကိုယ်တိုင် အစစအရာရာ ရေးစရာမလိုပါဘူး။ Linux (monolithic) kernel drivers ရေးတဲ့နေရာမှာလည်း ထိုအတိုင်းသာ ဖြစ်ပါတယ်။

## Cons of Monolithic kernel

- အားနည်းချက်က Operating System (OS) တခုလုံးရဲ့ Services တွေက Single Process ကြီး တခုတည်းမှာပဲ အလုပ်လုပ်တဲ့အတွက် Service တခု Fail ဖြစ်သွားတာနဲ့ Operating System တခုလုံး Crash ဖြစ်ပါတယ်။

- Monolithic kernel တွေက အရေးကြီးတဲ့ Operating System (OS) Serives တွေ အကုန်လုံးက Kernel-sapce မှာပဲ Rely လုပ်တဲ့အတွက် Microkernel နဲ့ ယှဥ်လိုက်ရင် Kernel size က အလွန်ကြီးပါတယ်။


# Kernel Design: Microkernel

![Screenshot](/assets/images/screenshots/img_screenshot_microkernel.png)

## Pros of Microkernel

- Microkernel မှာတော့ Monolithic kernel design နဲ့ ဆန့်ကျင်ဘက်ပါပဲ။ Basic Memory Mangement နဲ့ IPC (Inter Process Communication) လိုမျိုး Bare Manimum လောက်သာ Kernel-space မှာ အလုပ်လုပ်စေပါတယ်။ ကျန်တာတွေကို User-space မှာပဲ ထားပါတယ်။

- Microkernel တွေက Kernel ကနေ user-space က applications ကို တန်းသွားတာ မဟုတ်ပဲ user-sapce မှာပဲ Services တွေကို Provide လုပ်မယ့် Servers တွေကနတဆင့် အလုပ်လုပ်စေပါတယ်။

- Microkernel တွေမှာ အပေါ်မှာပြောတဲ့ user-space က ကြားခံ Servers တွေကနေ Provide လုပ်တဲ့ Services တွေကို မတူညီတဲ့ Address Space မှာ အလုပ်လုပ်ပါတယ်။ ကောင်းတဲ့အချက် services တွေကို ခွဲခွဲပြီးလုပ်တဲ့အတွက် Service တခု Fail သွားတာနဲ့ OS တခုလုံးက Monolithic လိုမျိုး Crash ဖြစ်မသွားပါဘူး။

- Microkernel တွေက Kernel-space မှာ bare manimum code တွေပဲ ထားတဲ့အတွက် Kernel size က သေးတယ်လို့ ပြောနိုင်ပါတယ်။

## Cons of Microkernel

- Microkernel မှာ Programmer တယောက်က Feauture တခုခု ဒါမဟုတ် Kernel driver တခုခု Implement လုပ်မယ် Code ရေးမယ်ဆိုရင် Monolithic kernel ထက် အများကြီး ခက်ခဲနိုင်ပါတယ်။ Code တွေ အများကြီး ရေးရပါလိမ့်မယ်။

- Microkernel တွေက Performance ပိုင်းမှာ သိပ်မကောင်းနိုင်ပါဘူး။ Monolithic kernel တွေထက် Microkernel တွေက Performance ပိုင်းမှာ 50% လောက် နှေးကွေးနိုင်ပါတယ်။ ဘာကြောင့်လဲဆိုရင် Server တခုချင်းသည် သီခြားစီဖြစ်နေပါတယ်။ အဲဒီ Server တခုက Service ဒါမှမဟုတ် funtion တခုကို တခြား Server ကနေ Invoke လုပ်မယ်ဆိုရင် Kernel ရဲ့ Permission လိုအပ်တဲ့အတွက် အချိန်စောင့်ရတဲ့အတွက် Execution time ပိုကြာပါတယ်။ Monolithic kernel လိုမျိုး funtion တခုကို တိုက်ရိုက် Invoke လုပ်မရတဲ့အတွက် Performance ပိုင်းမှာ ကျပါတယ်။ Monolithic kernel လောက် မကောင်းနိုင်ပါဘူး။

# Monolithic and Microkernel based Operating Systems
နမူနာပြောပြရရင် Kernel Design ပိုင်းမှာ Origin UNIX နဲ့ Linux က Monolithic kernel type ဖြစ်ပြီး၊ Minix က Microkernel type ဖြစ်ပါတယ်။ Android OS က Linux kernel based Mobile OS ဖြစ်တဲ့အတွက် monolithic kernel type ထဲမှာ ပါ၀င်ပါတယ်။ နောက်လာမယ့် Google ရဲ့ Mobile OS အသစ် Fuchsia OS က Zircon ဆိုတဲ့ microkernel ပေါ်မှာ အခြေခံပြီး Development လုပ်နေပါတယ်။
