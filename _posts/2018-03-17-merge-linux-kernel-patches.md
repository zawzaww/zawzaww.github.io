---
layout: post
title: "Merging Upstream Linux Kernel Patches For Android"
author: Zaw Zaw
image:
  src: /assets/images/featured-images/img_merge_linux_kernel_patches.jpeg
---

ဒီတခါ Guide က ဘာအကြောင်းအရာလဲ ဆိုတော့ ကိုယ့်ရဲ့ Android Device အတွက် Build လိုက်တဲ့ Android Kernel မှာ Linux Kernel version တွေကို ဘယ်လို Update လုပ်မလဲ ဆိုတဲ့ အကြောင်းအရာပါ။ Linux Kernel release တဲ့ ပိုင်းမှာ (၄)မျိုး ကွဲပြားပါတယ် ( Prepatch, Mainline, Stable & Long Term ) ဆိုပြီး ရှိပါတယ်။ အသေးစိတ်ကိုတော့ ဒီမှာ လေ့လာကြည့်ပါ https://www.kernel.org/category/releases.html ပထမ Android Kernel building tutorial မှာလည်း ကျွန်တော်ပြောခဲ့ပါတယ် Android မှာ သုံးတဲ့ Linux Kernel branch တွေက Long Term Support (LTS) branch တွေဖြစ်ပါတယ်။ Linux Kernel LTS branch တွေအများကြီး ရှိပါတယ်။ Android ဖုန်း အမျိုးအစားပေါ် မူတည်ပြီး သုံးတဲ့ Linux Kernel LTS branch တွေက မတူပါဘူး။ ဥပမာ အနေနဲ့ ပြောပြရရင် Nexus 5X မှာဆိုရင် linux-3.10.y ဆိုတဲ့ LTS branch ကိုသုံးပြီး၊ Google Pixel မှာဆိုရင် linux-3.18.y ဆိုတဲ့ LTS branch ကို သုံးပါတယ်။ Android က အဲဒီ သက်ဆိုင်ရာ LTS Linux kernel branch တွေကို အခြေခံပြီး အသုံးချပြီး သူရဲ့ Android Mobile Device အတွက် ကိုက်ညီမှုရှိအောင် Device driver ပြန်ပြင်ရေးပြီး ပြန် Modifed ခဲ့တဲ့သဘောပါပဲ။ ဒါကြောင့် ကိုယ့်ဖုန်းအတွက် Kernel source ယူရင် Android ဘက်က သက်ဆိုင်ရာ Mobile OEM's Engineer တွေက ပေးတဲ့ Kernel source တွေယူရပြီး၊ Linux kernel version update တွေ လုပ်ချင်ရင် မူရင်း git.kernel.org ကနေ Git ကိုသုံးပြီး code တွေ merge ပြီး ကိုယ့်ဖုန်းအတွက် kernel version တွေ update လုပ်ပေးရမှာပါ။ အခု Guide မှာ Git ကိုသုံးပြီး git.kernel.org ကနေ ကိုယ့် Android ဖုန်းအတွက် Linux Kernel version (Code) တွေကို ဘယ်လို Merge လုပ်မလဲ ဆိုတာ ဆက်ရေးပါမယ်။

 
## Requirements

- GNU/Linux based Operating System(OS)
- Git: Version Control System
- C Programming Language

## How To Merge Linux Kernel Patches

- ဘယ်လို Linux Kernel version ကို Update လုပ်မလဲ ဆိုတဲ့ နေရာမှာ နှစ်မျိုးရှိပါတယ်၊ [git merge] ကိုသုံးပြီး code တွေ merge တဲ့နည်းရယ်၊ [git cherry-pick] ကိုသုံးပြီး code တွေ merge တဲ့ နည်းရယ် ဆိုပြီး ရှိပါတယ်။
- အကြံပေးချင်ပါတယ် ခုမှ git နဲ့ စထိတွေ့မယ့်သူဆို git cherry-pick နည်းပဲ သုံးပါလို့ အကြံပေးချင်ပါတယ်၊ မဟုတ်ရင် tag တွေသုံးပြီး git merge ကိုသုံးရင် conflicts တွေ ထောင်သောင်းချီသွားပါလိမ့်မယ်။
- ပထမဦးဆုံး အနေနဲ့ ကိုယ့် Computer ထဲမှာ git install ထားဖို့လိုပါတယ်။

## Method (1) : Git merge

- ပထမဦးဆုံး အနေနဲ့ linux kernel branch တွေရှိတဲ့ နေရာ သိရပါမယ် Link...https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/
<img src="https://s20.postimg.cc/9ormx6trx/Screenshot_from_2018-03-08_10-17-42.png" /> 

- နောက်တခုက ကိုယ့်ဖုန်းအတွက် Kernel source က ဘယ် linux kernel branch ကို သုံးလဲ ဆိုတာ သိရပါမယ်၊ ဥပမာ kernel-source/Makefile ကို ဖွင့်ကြည့်လိုက်ပါ၊ Nexus 5X မှဆို 3.10.73 ဆိုပြီး တွေ့ရပါမယ်။
- Format

```sh
VERSION = 3
PATCHLEVEL = 10
SUBLEVEL = 73
EXTRAVERSION =
NAME = TOSSUG Baby Fish
```

- အပေါ်က format ကို ကြည့်ရင် 3 10 ဆိုတာ linux kernel branch မှာဆိုရင် linux-3.10.y ကို ဆိုလိုခြင်း ဖြစ်ပါတယ်။
- အခု git command တွေသုံးပြီး code တွေ merge ပါမယ်။
- အရင် ကိုယ့်ဖုန်းအတွက် download ထားတဲ့ Kernel source folder ထဲဝင်ပြီး Right Click ပြီး Terminal ကို ဖွင့်လိုက်ပြီး အောက်က command လေး ရိုက်လိုက်ပါ။ (Nexus 5X အတွက်ဖြစ်လို့ branch name က linux-3.10.y ပါ)
- Format ( git merge မလုပ်ခင် git fetch အရင် လုပ်ပေးရပါမယ် )

```sh
git fetch --tags <repo_url> <branch_name>
```

- Example: for Nexus 5X

```sh
git fetch --tags https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/ linux-3.10.y
```

<img src="https://s20.postimg.cc/ijsh7pqa5/Screenshot_from_2018-03-08_10-18-14.png" />

- git fetch လုပ်တာက Internet connection ပေါ် မူတည်ပြီး ကြာပါမယ်၊ ပြီးသွားရင် tags အလိုက်တွေ Terminal မှာ စီပြီးပြပေးပါလိမ့်မယ်။
- git merge ပါတော့မယ်။ (ဒီနေရာက အရေးကြီးပါတယ် ခုလက်ရှိ ကိုယ့် Kernel source ထဲက Makefile မှာ တချက်လောက် ကြည့်လိုက်ပါ kernel version ကို 3.10.73 ဆိုရင် နောက် git mergeရင် .74 ကို တဆင့်ချင်း merge ပါ၊ မဟုတ်ဘူးဆိုရင် Latest .108 ကို တန်းပြီး mergeရင် merge conflicts တွေများသွားပါလိမ့်မယ်)
- Format

```sh
git merge <tag_name>
```

- Example for Nexus 5X

```sh
git merge v3.10.74
```

```sh
git merge v3.10.75
```

```sh
git merge v3.10.76
```

```sh
git merge v3.10.77
```

```sh
git merge v3.10.78
```

```sh
git merge v3.10.79
```

```sh
git merge v3.10.80
```

- Continue...
- git merge တာကို Linux version တဆင့်ချင်းစီ Merge ပေးပါ v3.10.74, 75, 76, 78, 79, 80, 81 ကနေ ဆက်ပြီးတောာ့ လက်ရှိ 3.10.y branch ရဲ့ နောက်ဆုံး version ဖြစ်တဲ့ 108 ထိ Merge ပေးပါ (73 ကနေ 108  တန်းပြီး Merge မလုပ်ပါနဲ့ တဆင့်ချင်းစီ Merge တာက နည်းလမ်းအမှန်ပါပဲ)

```sh
git merge v3.10.108
```

## Method(2) : Git cherry-pick

- git cherry-pick တဲ့နေရာမှာ အမှန်က နှစ်မျိုးရှိပါတယ်၊ tag အလိုက် cherry-pick တာရယ် commit အလိုက် cherry- pick တာရယ် ဆိုပြီး ရှိပါတယ်၊ မပြောတော့ပါဘူး လွယ်လွယ်နဲ့ မြန်မြန်လုပ်လို့ရမယ့် commit အလိုက် cherry-pick တာပဲ ပြောပါမယ်။
- ပထမဆုံး git fetch အရင်လုပ်ပေးရပါမယ်။
- Format

```sh
git fetch <repo_url> <branch_name>
```

- Example: for Nexus 5X

```sh
git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/ linux-3.10.y
```

<img src="https://s20.postimg.cc/ijsh7pqa5/Screenshot_from_2018-03-08_10-18-14.png" />

- ပြီးသွားရင် ကိုယ် Update ချင်တဲ့ Linux kernel version Page ထိ သွားရပါမယ်၊ ဥပမာ Nexus 5X အတွက် Linux v3.10.73 ကနေ v3.10.74 ကို update ချင်ရင် https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/log/?h=linux-3.10.y သွားပါ၊ အဲဒီမှာ v3.10.74 ဆိုတဲ့ Yellow color tag နဲ့ Page ထိ သွားပါ၊ အဲဒီ အပေါ်ဆုံးက Linux 3.10.74 commit က အခုလက်ရှိ kernel version(3.10.74) ရဲ့ last commit ပါ၊ ပြီးရင်အောက်ထိ ဆင်းပါ၊ အဝါရောင်လေးနဲ့ ရေးထားတဲ့ tag လေး v3.10.73 ထိ သွားပြီး၊ အဲဒီအပါ် commit တကြောင်းက Linux kernel version(3.10.74) ရဲ first commit ပါ။ (ဒီနေရာမှာက ပြောချင်တာက first commit နဲ့ last commit အကြောင်းပါ)
<img src="https://s20.postimg.cc/f06jhxxv1/Screenshot_from_2018-03-08_10-20-32.png" />

- First commit နဲ့ Last commit အကြောင်း အပေါ်မှာ ရှင်းပြထားပါတယ်၊ အဲဒါ git cherry-pick တဲ့ နေရာမှာ ပြန်သုံးရမှာပါ၊ အဲဒါကြောင့် ရှင်းပြတာပါ။
- အပေါ်မှာ git fetch သွားတာ ပြီးသွားရင် ဒီ command လေး ရိုက်လိုက်ပါ
- Format (သဘောက Linux 3.0.74 အတွက် commit ထားတဲ့ code အတွေအကုန် ကိုယ့် Repo ထဲ merge လုပ်သွားပါလိမ့်မယ်)

```sh
git cherry-pick <first_commit>^..<last_commit>
```

- Example: (အဲဒါတွေက <commit_hash> တွေပါ copy ပြီး paste လိုက်တာပါ)
- First commit of v3.10.74...
[70bd96c4dfffc1e34a7e9225220405e0adb93d69](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?h=v3.10.74&id=70bd96c4dfffc1e34a7e9225220405e0adb93d69)
- Last commit of v3.10.74...
[	c9ef473a544f0c10e631c25e631f31f9dc0eaed7](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?h=v3.10.74&id=c9ef473a544f0c10e631c25e631f31f9dc0eaed7)

```sh
git cherry-pick 70bd96c4dfffc1e34a7e9225220405e0adb93d69^..c9ef473a544f0c10e631c25e631f31f9dc0eaed7
```

<img src="https://s20.postimg.cc/c63e4h0tp/Screenshot_from_2018-03-08_10-20-01.png" />
<img src="https://s20.postimg.cc/msx79woel/Screenshot_from_2018-03-08_10-20-17.png" />

(OR)

- ဒါက commit တခုချင်းစီ git cherry-pick တဲ့ နည်းပါ
- Format

```sh
git cherry-pick <commit_hash>
```

Example: (v3.10.74 first commit ကနေ last commit ထဲ တခုချင်းစီ merge တဲ့နည်းပါ၊ စိတ်ရှည်ဖို့တော့ လိုပါတယ် commit တွေက များကြီးပါပဲ)
- အဲဒီနည်းနဲ့ Linux Kernel version တခုချင်းစီအတွက် တဆင့်ချင်း v3.10.74, 75, 76, 77, 78...ကနေ လက်ရှိ Latest ဖြစ်တဲ့ 108 ထိ Merge ပေးရမှာဖြစ်ပါတယ်။ Linux Kernel Patchs တွေကို version ကျော်ပြီး Merge လို့မရပါဘူး၊ v3.10.73 ကနေ 74 ပြီးရင် 75 ပြီးရင် 76 တခုချင်းစီ သေချာ Merge ပေးရပါတယ်။ ဘာလို့လဲဆိုတော့ Version တခုတိုင်း တခုတိုင်းအတွက် Bugs Fix & Linux Kernel Security Flaw Fixed Code တွေ Patchs တွေက အများကြီးပါ အရေးကြီးပါတယ်။ တဆင့်ချင်းစီ Merge မှသာ ကိုယ့်ရဲ့ Kernel က ပြီးပြည့်စုံတဲ့ Linux Kernel patchs တွေ ရရှိမှာ ဖြစ်ပါတယ်။ (အဲဒါမှသာ စနစ်တကျဖြစ်တဲ့ မှန်ကန်တဲ့နည်းလမ်းဖြစ်ပါလိမ့်မယ်)

```sh
 git cherry-pick 70bd96c4dfffc1e34a7e9225220405e0adb93d69
 git cherry-pick 574947bf3ce72410455e76d11ac57c3da69d36d8
 git cherry-pick 1290b015b701b4c772251e63da5866974e5ccb77
 Continue... latest commit of Linux v3.10.74
```

- အဲဒါတွေ ပြီးသွားရင် Merge တဲ့ လုပ်ငန်းတော့ ပြီးသွားပြီ။
- အဲဒီနောက် ပထမက Kernel-Building Tutorial အတိုင်း ပြန် Compile လိုက်ပါ။
- တကယ်လို့ Merge conflicts တွေ ဖြစ်ခဲ့ရင် Terminal ကနေ code error တွေ line no. အတိအကျပြောပေးပါလိမ့်မယ်။ C Programmig Language ကို ရရင် ဖြေရှင်းနိုင်ပါ လိမ့်မယ်။
