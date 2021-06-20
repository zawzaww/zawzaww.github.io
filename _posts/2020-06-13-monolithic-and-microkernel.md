---
layout: post
title: "Kernel Design: Monolithic Versus Microkernel"
categories: kernel
author: "Zaw Zaw"
image:
  src: /assets/images/featured-images/img_monolithic_microkernel.png
---

လွန်ခဲ့သော 1992 မှာ ဖြစ်ပွားခဲ့တဲ့ Tanenbaum-Torvalds debate ရဲ့ Origin Thread ကို ဖက်ကြည့်ရင်းကနေ အခု Article ကို ရေးဖြစ်သွားတာပါ။ အခု Article က Tanenbaum-Torvalds debate အပေါ်မှာ အခြေခံထားတယ်လို့ ပြောလို့ရပါတယ်။ Kernel Design ပိုင်းမှာ အသုံးများတဲ့ Monolithic kernel design နဲ့ Microkernel design ရဲ့ ကွာခြားချက်တွေကို အဓိကပြောသွားမှာ ဖြစ်ပါတယ်။ အရင်ဆုံး Tanenbaum-Torvalds debate အကြောင်းကို အတိုချုပ်ပြောပါမယ်။ ပြီးတဲ့နောက်မှာတော့ Monolithic kernel နဲ့ Microkernel ရဲ့ ကွာခြားတဲ့ မတူညီတဲ့ အချက်လက်တွေကို တခုချင်း ပြောပေးသွားမှာ ဖြစ်ပါတယ်။

# Tanenbaum-Torvalds Debate
Tanenbaum-Torvalds debate ကို ဟိုတခါ ကိုသက်ခိုင် ရေးထားတာတွေ့လို့ [Wikipedia](https://en.wikipedia.org/wiki/Tanenbaum%E2%80%93Torvalds_debate) မှာ ဖက်ကြည့်ရင်း သိခဲ့တာတော့ ကြာပါပြီ။ ဒါပေမယ့် [MINIX Operating System Discussion Group (comp.os.minix)](https://groups.google.com/g/comp.os.minix)  မှာ တကယ် အပြန်အလှန် Debate လုပ်ခဲ့တဲ့ မူရင်း Thread ကို ခုမှ ဖက်ကြည့်ဖြစ်ပါတယ်။ MINIX (mini-Unix) အကြောင်း နည်းနည်းပြောရရင် Originally အနေနဲ့ MINIX သည် Educational Purpose အတွက် Computer Science (CS) ရဲ့ Operating Systems ဘာသာရပ် Teaching ပိုင်းအတွက် အဓိကရည်ရွယ်ပြီး Professor Andrew S. Tanenbaum က Create လုပ်ခဲ့တဲ့ Microkernel architecture ပေါ်မှာ အခြေခံထားတဲ့ UNIX-like Operating System တခု ဖြစ်ပါတယ်။ ဆရာကြီး  Tanenbaum က [Operating Systems Design and Implementation](https://www.amazon.com/Operating-Systems-Design-Implementation-3rd/dp/0131429388) CS Textbook ကို ရေးခဲ့ပါတယ်။ တနည်းအားဖြင့် အဲဒီစာအုပ်သည် Operating System/Kernel Design နဲ့ MINIX အကြောင်း ရေးထားတဲ့ CS Textbook စာအုပ်ကောင်း တအုပ်ပင် ဖြစ်ပါတယ်။ [Vrije Universiteit Amsterdam](https://www.vu.nl/en) University မှာ Operating Systems ဘာသာရပ်အတွက် ဆရာကြီးက ကျောင်းသားတွေကို သင်ကြားဖို့အတွက် စာအုပ်ထဲက စာတွေတင်မကပဲ Operating System တခုကို နမူနာအနေနဲ့ သူ့ရဲ့စာအုပ်ထဲမှာ Exemplify လုပ်ပြဖို့အတွက် MINIX Operating System ကို ကိုယ်တိုင်တည်ဆောက်ခဲ့တာလည်း ဖြစ်ပါတယ်။ တကယ်လေးစားစရာ ကောင်းပါတယ်။ ပညာရေးဘက်မှာ Teaching ဘက်မှာ သုံးမှာဖြစ်တဲ့အတွက် MINIX Operating System သည် Tiny microkernel ပေါ်မှာ အခြေခံပြီး အရွယ်စားသေးသေး Code lines နည်းနည်းနဲ့ ကျောင်းသားတွေအတွက် Operating Systems ဘာသာရပ်ကို လေ့လာရလွယ်ကူစေဖို့အတွက် ရည်ရွယ်ထားတယ်လို့ ကျွန်တော့်အနေနဲ့တော့မြင်ပါတယ်။

အဲဒီ Tanenbaum-Torvalds debate ကို 1992 မှာ MINIX Operating System ရဲ့ Origin Author ဆရာကြီး Andrew S. Tanenbaum (also known as ast) က MINIX System Discussion Group မှာ [LINUX is obsolete](https://groups.google.com/g/comp.os.minix/c/wlhw16QWltI) ဆိုတဲ့ subject နဲ့ စတင်ခဲ့တယ်။ အတိုချုပ်ပြောပြရရင် Kernel Design ပိုင်း ဖြစ်တဲ့ Monolithic kernel နဲ့ Microkernel ကို Debate လုပ်ကြတာပါ။ တနည်းအားဖြင့် MINIX vs LINUX ကို Professor ဆရာကြီးနဲ့ Torvalds နှင့် သူရဲ့ Linux Kernel Developers တွေ ပညာသားပါပါနဲ့ MINIX Operating System Discussion Group မှာ Flame war ဖြစ်ခဲ့ကြတာပါ။ ကျွန်တော့်အနေနဲ့တော့ Tenenbaum-Torvalds debate မှာ ဘယ်သူကမှန်တယ် မှားတယ် ဆိုတဲ့အကြောင်းကိုတော့ မပြောလိုပါဘူး။ Kernel Design နှစ်ခုရဲ့ မတူညီတဲ့ အားသားချက် အားနည်းချက်တွေကို ပြောပြဖို့အတွက်ပဲ ဒီ Article က အဓိကရည်ရွယ်ပါတယ်။ တကယ်လို့ Operating System/Kernel အခြေခံ Knowledge ရှိရင် ကိုယ်တိုင်သာ Origin Thread မှာ ၀င်ဖက်ပြီး စဥ်းစားဆုံးဖြတ်ကြည့်ပါ။ စိတ်ဝင်စားရင်တော့ Google Groups က မူးရင် Thread မှာ ဆက်ဖက်ကြည့်နိုင်ပါတယ်။

Read Origin Thread on Google Groups: [LINUX is obsolete](https://groups.google.com/g/comp.os.minix/c/wlhw16QWltI)

![Screenshot](/assets/images/screenshots/img_screenshot_ast_torvalds_debate.png)


# Kernel Designs
Monolithic kernel နဲ့ Microkernel design နှစ်ခုလုံးမှာ အားသာချက် အားနည်းချက်တွေ ရှိပါတယ်။ ဘယ်အရာမဆို ပြီးပြည့်စုံတယ်ဆိုတာ မရှိပါဘူး။ သူ့နေရာသူ အားသာချက် အားနည်းချက်တွေ ရှိကြစမြဲပါပဲ။ Monolithic kernel design ကတော့ Design ပိုင်းမှာ ကြာခဲ့ပြီဖြစ်ပြီး Old kernel design လို့ ပြောနိုင်တယ်။ Microkernel ကတော့ Modern kernel design လို့ ‌ပြောလို့ရပါတယ်။ ကျွန်တော့်အနေနဲ့တော့ ဘယ် Kernel Design က ပိုကောင်းတယ် မကောင်းဘူးဆိုတာတော့ မပြောလိုပါဘူး။ Kernel Design နှစ်ခုရဲ့ ကွာခြားတဲ့ မတူညီတဲ့အချက်တွေကို ပြောပြရုံသာ ဖြစ်ပါတယ်။ သူ့နေရာသူ့ ကောင်းတာချည်းပါပဲ။ အဓိက အသုံးများတဲ့ Kernel Design သုံးမျိုးကတော့ Monolithic kernel ရယ် Microkernel နဲ့ Hybrid kernel တွေပဲ ဖြစ်ပါတယ်။ Hybrid kernel design ကတော့ မိုက်တယ်လို့ ပြောရမယ်။ Monolithic နဲ့ Microkernel design နှစ်ခုရဲ့ ကောင်းတဲ့အချက်တွေကို Combine လုပ်ထားတဲ့ Kernel Design ပါပဲ။ Apple ရဲ့ Operating Systems (macOS, iOS, watchOS, tvOS) တွေမှာ သုံးတဲ့ XNU kernel သည် Hybrid kernel design ပေါ်မှာ အခြေခံထားတဲ့ Operating System များ ဖြစ်ပါတယ်။ ကျွန်တော့်အနေနဲ့တော့ Monolithic kernel type ဖြစ်တဲ့ Linux kernel development ကို လေ့လာရင်းလုပ်နေတဲ့အတွက် Monolithic kernel နဲ့ Microkernel နဲ့ ယှဥ်တွဲပြီး မတူညီတဲ့အချက်တွေကို တချက်ချင်းစီ ဆက်ပြောပြသွားမှာဖြစ်ပါတယ်။

# Kernel Design: Monolithic

![Screenshot](/assets/images/screenshots/img_screenshot_monolithic.png)

## Pros of Monolithic kernel

- Monolithic kernel တွေက Loadable Kernel Module (LKM) Support လုပ်တယ်။ Device Drivers တွေကို Modules များ‌အဖြစ် ရေးနိုင်တယ်။ Kernel Runtime မှာ Kernel Modules တွေ လိုအပ်သလို Dynamically Load/Unload (Add/Remove) လုပ်နိုင်တယ်။ ဒါကြောင့် “Linux is modular.” လို့ ပြောတာတွေ တွေ့ဖူးပါလိမ့်မယ်။

- Linux (monilithic kernel) မှာဆိုရင် Portability ဖြစ်တယ်။ ဆိုလိုတဲ့သဘောက Monolithic kernel based OS သည် Intel x86 architecture ကိုလည်း အလုပ်လုပ်နိုင်တယ်။ နောက်ထပ် architecture တခု ဖြစ်တဲ့ ARM arm64 ပေါ်မှာလည်း အလုပ်လုပ်တယ်။ နောက်ထပ် architecture တွေ ဖြစ်တဲ့ mips, powerpc, m68k, m68k, alpha, arm, hexagon အစရှိသဖြင့် OS တခုသည် Computer system architectures တွေကို wide range support လုပ်တယ်ဆိုရင် Portability ဖြစ်တယ်လို့ ပြောကြပါတယ်။ Computer system architecture တခုကနေ နောက်ထပ် system architecture တခုအတွက် Portable C code တွေကို အလွယ်တကူ Port လုပ်နိုင်တယ်ဆိုရင် Portability ဖြစ်တဲ့ Operating System လို့ Operating System Kernel World မှာ ခေါ်ကြပါတယ်။ Linux မှာဆိုရင် ဆိုရင် Support လုပ်တဲ့ Architecture တွေကို Linux kernel source tree ရဲ့ /linux/arch directory အောက်မှာ ၀င်ကြည့်နိုင်ပါတယ်။

```bash
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

- Monolithic kernel တွေက Operating System (OS) တခုလုံးရဲ့ Services တွေကို Kernel-space မှာပဲ အလုပ်လုပ်တယ်။ ဆိုလိုတဲ့သဘောကတော့ Device Drivers, I/O, File Systems, IPC, Process Scheduling, Process Management, Memory Management စတာတွေ အကုန်လုံးသည် Kernel-space မှာပဲ အလုပ်လုပ်တယ်။ User-space မှာ Applications နဲ့ Libraries : C Library (libc) / GNU C Library (glibc) တွေသာ ရှိပါလိမ့်မယ်။ အဲဒါကြောင့် အပေါ်မှာပြထားတဲ့ပုံမှာ ကြည့်ရင် Kernel mode မှာ OS တခုလုံးရဲ့ အရေကြီးတဲ့ OS Core Services အလုပ်လုပ်ပြီး၊ User mode မှာ Applications တွေသာ အလုပ်လုပ်ကြောင်း တွေ့နိုင်ပါတယ်။

- Monolithic kernel တွေက ကြီးမားတဲ့ Single Process တခုတည်းကိုပဲ တူညီတဲ့ Single Address space မှာပဲ Run ပါတယ်၊ အလုပ်လုပ်တယ်။ ဆိုလိုတဲ့သဘောက အပေါ်မှာ ပြောထားတဲ့ Device Drivers, I/O, File Systems, IPC, Process Scheduling, Memory Management စတဲ့ OS တခုရဲ့ Services တွေ အကုန်လုံးကို Single Process အကြီးကြီးတခုတည်းမှာပဲ အလုပ်လုပ်ပါတယ်။

- Performance ပိုင်းမှာ အားသာချက်ရှိတယ် ကောင်းတယ်လို့ ပြောရမယ်။ ဘာကြောင့်လဲဆိုတော့ Kernel-space မှာ ရှိနေတဲ့ ဘယ် function ကို မဆို Kernel ရဲ့ Permission အတွက် အချိန်စောင့်ဆိုင်းစရာမလိုပဲ Monolithic kernel က တိုက်ရိုက် Invoke လုပ်နိုင်ပါတယ်။ Microkernel လို Kernel ရဲ့ Permission စောင့်စရာမလိုပဲ function တွေကို Directly invoke လုပ်နိုင်တဲ့အတွက် Execution time က ပိုမြန်တယ်။ ဒါကြောင့် Performance ပိုင်းမှာ ပိုကောင်းပါတယ်။

- Monolithic kernel တွေက Single static binary file တခုတည်းကိုသာ ထုတ်ပေးပါတယ်။

- Monolithic kernel တွေက “Easy to Code” လို့ ပြောလို့ရမယ်။ Programmer တယောက်က Kernel Device Drivers/Kernel Module တခု ဒါမှမဟုတ် Feature တခု ရေးမယ်ဆိုရင် Monolithic kernel တွေက Code ရေးရတာ နည်းတယ် ပိုပြီးလွယ်ကူပါတယ်။ ဘာကြောင့်လဲဆိုတော့ Kernel-space မှာ Kernel Framework & APIs တွေ အဆင့်သင့် Implement လုပ်ထားတဲ့အတွက်ကြောင့် ဖြစ်ပါတယ်။ ဥပမာ။ ။ Android development နဲ့ ဥပမာပေး ပြောပြရရင် Linux kernel drivers ရေးရတာက Android မှာ ဆိုရင် App ရေးရတာနဲ့ တူပါတယ်။ Android OS platform ဘက်ကနေ Java API framework (e.g: Activity Manager, Window Manager, Package Manager, Resource Manager, Content Providers and etc..) တွေ Support ပေးထားပြီး၊ App ဘက်ကနေ ခေါ်သုံးတဲ့ပုံစံမျိုးပါပဲ။ ကိုယ်တိုင် အစစအရာရာ ရေးစရာမလိုပါဘူး။ Linux (monolithic) kernel drivers ရေးတဲ့နေရာမှာလည်း ထိုအတိုင်းသာ ဖြစ်ပါတယ်။

## Cons of Monolithic kernel

- အားနည်းချက်က Operating System တခုလုံးရဲ့ Services တွေ အကုန်လုံးက Single Process ကြီး တခုတည်းမှာပဲ အလုပ်လုပ်တဲ့အတွက် Service တခု Fail ဖြစ်သွားတာနဲ့ Operating System တခုလုံး Crash ဖြစ်ပါတယ်။

- Monolithic kernel တွေက အရေးကြီးတဲ့ Operating System Serives တွေ အကုန်လုံးက Kernel-sapce မှာပဲ Rely လုပ်တဲ့အတွက် Microkernel နဲ့ ယှဥ်လိုက်ရင် Kernel size က အလွန်ကြီးပါတယ်။


# Kernel Design: Microkernel

![Screenshot](/assets/images/screenshots/img_screenshot_microkernel.png)

## Pros of Microkernel

- Microkernel မှာတော့ Monolithic kernel design နဲ့ ဆန့်ကျင်ဘက်ပါပဲ။ Basic Memory Mangement နဲ့ IPC (Inter Process Communication) လိုမျိုး Bare Manimum လောက်သာ Kernel-space မှာ အလုပ်လုပ်စေပါတယ်။ ကျန်တာတွေကို User-space မှာပဲ ထားပါတယ်။

- Microkernel တွေက Kernel ကနေ user-space က applications ကို တန်းသွားတာ မဟုတ်ပဲ user-sapce မှာပဲ Services တွေကို Provide လုပ်မယ့် Servers တွေကနတဆင့် အလုပ်လုပ်စေပါတယ်။

- Microkernel တွေမှာ အပေါ်မှာပြောတဲ့ user-space က ကြားခံ Servers တွေကနေ Provide လုပ်တဲ့ Services တွေကို မတူညီတဲ့ Address Space မှာ အလုပ်လုပ်ပါတယ်။ ကောင်းတဲ့အချက်က Services တွေကို ခွဲပြီးလုပ်တဲ့အတွက် Service တခု Fail သွားတာနဲ့ OS တခုလုံးက Monolithic လိုမျိုး Crash ဖြစ်မသွားပါဘူး။

- Microkernel တွေက Kernel-space မှာ bare manimum code တွေပဲ ထားတဲ့အတွက် Kernel size က သေးတယ်လို့ ပြောနိုင်ပါတယ်။

## Cons of Microkernel

- Microkernel မှာ Programmer တယောက်က Feauture တခုခု ဒါမဟုတ် Kernel device driver တခုခု Implement လုပ်မယ် Code ရေးမယ်ဆိုရင် Monolithic kernel ထက် အများကြီး ခက်ခဲနိုင်ပါတယ်။ Code တွေ အများကြီး ရေးရပါလိမ့်မယ်။

- Microkernel တွေက Performance ပိုင်းမှာ သိပ်မကောင်းနိုင်ပါဘူး။ Monolithic kernel တွေထက် Microkernel တွေက Performance ပိုင်းမှာ 50% လောက် နှေးကွေးနိုင်ပါတယ်။ ဘာကြောင့်လဲဆိုရင် Server တခုချင်းသည် Separately အလုပ်လုပ်ပါတယ်။ အဲဒီ Server တခုက Service ဒါမှမဟုတ် funtion တခုကို တခြား Server ကနေ Invoke လုပ်မယ်ဆိုရင် Kernel ရဲ့ Permission လိုအပ်တဲ့အတွက် အချိန်စောင့်ရတဲ့အတွက် Execution time ပိုကြာပါတယ်။ Monolithic kernel လိုမျိုး funtion တခုကို တိုက်ရိုက် Invoke လုပ်မရတဲ့အတွက် Performance ပိုင်းမှာ အထိုက်လျောက်မကောင်းနိုင်ပါဘူး။ ဒါကြောင့် Monolithic kernel လောက် Performance ပိုင်းမှာ မကောင်းနိုင်ဘူးလို့ ပြောလို့ရပါတယ်။

လက်ရှိမှာ Monolithic kernel နဲ့ Microkernel ကို အခြေခံပြီး တည်ဆောက်ထားတဲ့ Operating Systems တွေကို မြင်သာအောင် ဥပမာအနေနဲ့ ပြောပြရရင် UNIX နဲ့ Linux က Monolithic kernel type ဖြစ်တယ်။ MINIX ကတော့ Microkernel type ဖြစ်ပါတယ်။ Android OS က Linux kernel based Mobile OS ဖြစ်တဲ့အတွက် monolithic kernel type ထဲမှာ ပါ၀င်ပါတယ်။ နောက်လာမယ့် Google ရဲ့ Mobile OS အသစ် Fuchsia OS က Zircon ဆိုတဲ့ microkernel ပေါ်မှာ အခြေခံပြီး Development လုပ်နေပါတယ်။
