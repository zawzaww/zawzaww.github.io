---
layout: post
title: "Gin Android OEMs"
categories: news
author: "Zaw Zaw"
featured-image: /assets/images/featured-images/img_gin_android_oems.jpeg
permalink: blog/news/gin-android-oems
---

ပြီးခဲ့တဲ့ 2018 April လ လောက်မှာ Tech site တော်တော်များများမှာ သတင်းတခုထွက်ခဲ့တယ်။ သတင်းက Android ဖုန်း ထုတ်လုပ်သူ Company တချု့ိ Android Security Patch Level ကို Users တွေကို လိမ်ခဲ့တယ် ဆိုတဲ့ကိစ္စပါ။ ဘယ်လိုသိခဲ့တာလဲဆိုရင် တကယ်တော်တဲ့ Security Researcher တွေ ရှာတွေ့ခဲလု့ိ Report တင်ခဲ့တဲ့အတွက်ကြောင့်ပါ။ ဘယ်လိုလိမ်ခဲ့တာလဲဆိုရင် သင်ဆိုင်ရာ Android Security Patches တကယ်တမ်း Merge/Install လုပ်ခဲ့မဟုတ်ပဲ အလွယ်နားလည်အောင်ပြောရရင် Settings>About Phone ထဲ Android Security Patch Level ဆိုတဲ့နေရာက Date လေးပဲ Change လိုက်တဲ့ သဘောပါ။

Users တွေကို ဘယ်လို လိမ်လု့ိရလဲဆိုရင် Technically သေချာပြောရရင် Android OS ရဲ့ SourceCode Repositories တွေအကုန်ရှိတဲ့နေရာ AOSP Google Git (https://android.googlesource.com) အောက်က platform/build ဆိုတဲ့ Git Repository တခုရှိပါတယ်။ အတိအကျ ပေးရရင် https://android.googlesource.com/platform/build ဖြစ်ပါတယ်။ သဘောတရား အကြမ်းပြောပြရရင် အဲဒီ Repository က ဘာအတွက်လဲဆိုရင် Android Build System အတွက်ပါ။ ဆိုလိုတာက Android OS ကြီး တခုလုံးရဲ့ သက်ဆိုင်ရာ လိုအပ်တဲ့ SourceCode Repositories တွေကနေ “System.img” ထွက်လာထိ Compile လုပ်ဖု့ိ Build လုပ်ဖု့ိ အတွက် အဓိကရည်ရွယ်ထားတဲ့ make command တွေနဲ့ Build automation လုပ်နိုင်ဖု့ိအတွက် Makefile နဲ့ ရေးထားတာတဲ့ Repositoryတခုဖြစ်ပါတယ်။

About the “Make” and “Makefile”

Source: Wikipedia

```
In software development, Make is a build automation tool 
that automatically builds executable programs and libraries 
from source code by reading files called Makefiles 
which specify how to derive the target program.

A Makefile is a file (by default named “Makefile”) containing 
a set of directives used by a make 
build automation tool to generate a target/goal.
```

Android Make build system: https://android.googlesource.com/platform/build.git Repository ထဲက core/အောက်က version_defaults.mk ဆိုတဲ့ file လေးကို ဖွင့်ကြည့်လိုက်ရင်

<script src="https://gist.github.com/zawzaww/3fc7723ebc6b87f0fe043693e67d1463.js"></script>

အစရှိသဖြင့် အကုန် Define လုပ်ပေးလု့ိ ရပါတယ်။ April လ တုန်းက သတင်းမှာ Android OEM Company တချို့ Android Security Patch Level လိမ်ခဲ့တယ်ဆိုတဲ့ အဓိပ္ပါယ်က သက်ဆိုင်ရာ Android Security flaw တွေကို Fix လုပ်ထားတဲ့ Security patches / Code တွေကို Merge ခဲ့တာ မဟုတ်ပဲ "Date" လေးပဲ Change ရုံသက်သက်ပဲ လုပ်ခဲ့ပြီး User တွေဆီ Software update ပြန်ပေးခဲ့တဲ့ဆိုတဲ့ သဘောဖြစ်ပါတယ်။

အခု Screenshot မှာ ပြထားတဲ့အတိုင်း platform/build Repository ထဲက core/version_defaults.mk file ထဲက Line No.184 မှာရှိတဲ့ “PLATFORM_SECURITY_PATCH := Year-Month-Day” ဆိုတဲ့ line မှာ Date လေးပဲ ပြင်ပြီး Recompile ပြန်လုပ်လိုက်ရင် ဒါက ရပါပြီ။ Company ကြီးတွေလုပ်ပြီး ဒါဟာ သိပ်ပြီး ကလေးဆန်တဲ့ အလုပ်ပါ။ လုံးဝကို မလုပ်သင့်ပါဘူး။

***(Root ထားတဲ့ Android phone ဆိုရင် /system/build.prop မှာ Android Security Patch Date ချိန်းပြီး Phone ကို Reboot ချလိုက်ရင်တောင် ဒါတွေက ရနေတဲ့ကိစ္စပါ)

Code example:

```mk
ifndef PLATFORM_SECURITY_PATCH
# Comment lines
PLATFORM_SECURITY_PATCH := 2018–05–05
endif
```

<img src="https://cdn-images-1.medium.com/max/800/1*J88H5_PwEklu9zFgoGfKgg.png" />

ပုံမှန်လုပ်ရမှာက AOSP က Android platform fixes တွေ Upstream Linux Kernel fixes တွေ Hardware Manufacturer ဘက်က System-On-Chip (SOC) နဲ့ သက်ဆိုင်တဲ့ SOC fixes တွေကို Merge လုပ်ပြီးမှ Android Build System က Date ကို သွားချိန်းပေးရမှာ ဖြစ်ပါတယ်။ ပြီးမှ Android System / OS တခုလုံးကို "system.img" ထွက်လာတဲ့အထိ Compile ပြန်လုပ်ပေးရမှာ ဖြစ်ပါတယ်။ Android Security Updates ပိုင်း အသေးစိတ်ကို ဒီမှာ လေ့လာနိုင်ပါတယ်...

Links:
- https://source.android.com/security
- https://source.android.com/security/bulletin

ဒီကိစ္စက တကယ်ဖြစ်ခဲ့တာပါ အောက်က Ref link ကိုနှိတ်ပြီးလည်း ဖက်ကြည့်နိုင်ပါတယ်။ ဒါကြောင့်လည်း Android ဟာ ဒီလို ဖုန်းထုတ်တဲ့ ဂျင်း Company တွေကြောင့် Security ပိုင်းမှာ လုံးဝ အားနည်းချက်တွေ ပြည့်နေတာ စိတ်မချရတာ မဆန်းပါဘူး။ ဒါ စီးပွားရေးလုပ်နေတဲ့ Company ကြီးတွေ အနေနဲ့ လုံးဝ မလုပ်သင့်တဲ့ ကိစ္စပါ၊ ကလေးကစားစရာ အလုပ်မဟုတ်ပါဘူး။ အမှန်တိုင်းပြောရရင် တကမ္ဘာလုံးမှာ Google ရဲ့ ကိုယ်ပိုင် Android device တွေဖြစ်တဲ့ "Nexus/Pixel" သုံးတဲ့သူက ဘယ်လောက်မှ မရှိပါဘူး။ Popular ဖြစ်တဲ့ တခြား Android OEMs တွေက Phone တွေ သုံးတဲ့သူ ပိုများပါတယ်။ အဲဒီ Company တွေကလည်း ဂျင်းထည့်ချင်တော့ Security updates တွေက သိပ်ပြီး ယုံချင်စရာ မကောင်းပါဘူး။ Android နဲ့ iOS နဲ့ကွာသွားတာ အဲဒီနေရာမှာပဲလု့ိထင်တယ် Android မှာ ထိန်းမနိုင်သိမ်းမနိုင် Android ဖုန်း ထုတ်လုပ်သူတွေများပြီး၊ အဲဒီ OEM တွေရဲ့ဖုန်းတွေရဲ့ Android Operating System က Customization တွေ အသေလုပ်ပြီး Bugs fix and Security Updates/Software Updates လည်း လစဉ်ပုံမှန် အချိန်မှီ မပေးနိုင်တဲ့ အဖြစ်တွေပါ။ ဒီကြားထဲမှာ အခုလိုမျိုး လုပ်ရပ်တွေလုပ်ပြီး မသိနားမလည်တဲ့ Users တွေကို ဂျင်းထည့်ချင်နေတော့ တော်တော်ကိုလွန်ပါတယ်။ ရှက်ဖု့ိလည်း ကောင်းပါတယ်။ ဒီလိုမျိုး လုပ်ရပ်မျိုးက တော်ရုံတန်ရုံ User ကလည်း သိမှာ မဟုတ်ဘူး Software update ပေးနေပြီဟ ဆိုပြီး Install လုပ်လိုက်မှာပဲ ကျန်တာတွေ စဉ်းစားမှာ မဟုတ်ပါဘူး Researcher တွေလို လိုက်ပြီး အတွင်းကျကျ လိုက်‌လေ့လာနေမှာ မဟုတ်ပါဘူး လိမ်ရင် ခံရမယ့် ကိစ္စမျိုးပါ။ ပိုက်ဆံသာ လိုချင်ပြီး စေတနာ မပါတဲ့ ဂျင်း Android OEM များလု့ိ ခေါ်လု့ိရပြီ သတ်မှတ်လု့ိရပြီ။

Ref: https://www.xda-developers.com/android-oem-lying-security-patches

If you are experienced in some programming language, you can learn here:

https://android.googlesource.com/platform/build
