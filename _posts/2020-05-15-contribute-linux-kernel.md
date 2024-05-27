---
layout: post
title: "Contributing to the Linux kernel"
author: zawzaw
categories: [Linux]
toc: true
image: assets/images/featured-images/img_linux_kernel_contribution.png
---

This article will focus on how to contribute to the Linux kernel contribution workflow. The Linux kernel is a free and open-source software project that anyone can contribute. Workflow, which contributes to the Linux kernel, is unlike any other open-source project. You can not contribute code using GitHub or GitLab. Submit kernel patches via Git and Email using the Linux Kernel Mailing List (LKML) on the Linux kernel. Kernel Maintainers will review via email and merge the code to Linux kernel source tree after discuss.

In short, make a list

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

There will be Below is a step-by-step guide for each.

## Setup Email Client

Firstly you need to set up the Email Client in gitconfig.

Set up an Email Client to use `~/.gitconfig` using a Text Editor.

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

## Make Fixes

You can get the source code Linux kernel main source tree via [https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git). It's hard to say what to fix and what parts to fix and contribute. Like any other software project, you learn something. If you are interested in kernel hacking, you can learn more at [Linux Kernel Newbies](https://kernelnewbies.org/KernelHacking). It depends on your interests. Initially, you do not have to follow the entire subsystem of the entire Linux kernel. Linux kernel subsystems are categorized as File Systems: `/linux/fs`, Kernel Device Drivers / Modules:`/linux/drivers`, Networking: `/linux/net`, Kernel Security (eg SELinux, Kernel lockdown and etc .. There are many kernel subsystems, such as `/linux/security`. You should specialize in something from the beginning. Writing kernel device drivers / modules for embedded hardware devices is more popular in the real Embedded Linux World than any other kernel subsystem.

About Linux Kernel Device Drivers: There is a book I would recommend. [Linux Device Drivers, Third Edition](https://www.oreilly.com/library/view/linux-device-drivers/0596005903/) is a great book to learn about Linux Kernel Device Drivers. The O'Reilly Open Books Project is now available as a free book under the Creative Commons Attribution-ShareAlike 2.0 license.

[O'Reilly Open Book: Linux Device Drivers Book, Third Edition.](https://www.oreilly.com/openbook/linuxdrive3/book/)

[LWN.net: Linux Device Drivers Book, Third Edition.](https://lwn.net/Kernel/LDD3/)

![book-cover-image](https://mhatsu.to/content/images/2020/06/linux-device-drivers-book.jpg)
_Book Cover Photo by: O'Reilly Open Books Project_

In this blog post, I will give an example of a build error that was fixed when building Linux kernel with LLVM / Clang Compiler version 9.

Create a new `dev/zawzaw` branch from the original `master` branch locally.

```bash
git branch dev/zawzaw
```

```bash
git checkout dev/zawzaw
```

Fixed kernel build error in LLVM / Clang compiler version 9: `linux/arch/x86/include/asm/bitops.h`

## Build Kernel Code
This is the part that compiles and tests whether it exists or not.

Go to the Kernel source tree and configure the kernel and compile it. I use Clang/LLVM, so I added `CC=clang` to compile kernel. I wrote [Compiling Linux Kernel with Clang/LLVM](https://zawzaww.github.io/posts/compile-linux-clang-llvm) article on how to build Linux Kernel with Clang/LLVM toolchain.

```bash
make CC=clang defconfig
```

![Screenshot](/assets/images/screenshots/img_screenshot_recompile_kernel.png)

```bash
make CC=clang -j$(nproc --all)
```

![Screenshot](/assets/images/screenshots/img_screenshot_recompile_kernel_complete.png)

## Git diff

Let's do `git diff` and look at the changes first.

![Screenshot](/assets/images/screenshots/img_screenshot_git_diff.png)

## Git commit

You need to write meaningful commit message.

```bash
git commit -a
```

![Screenshot](/assets/images/screenshots/img_screenshot_git_commit.png)

## Git show

You can view the commit messages and changes you made with `git show`

![Screenshot](/assets/images/screenshots/img_screenshot_git_show.png)

## Git format-patch

Here you will generate a patch for the fixes you made. The next step is to submit the generated kernel patches via email.

Let's look at your local branch first with `git branch`.

```bash
zawzaw@ubuntu-linux:~/Linux-kernel/linux$ git branch
* dev/zawzaw
  master
```

Generate a patch.

```bash
git format-patch master..dev/zawzaw
```

If you open the generated patch file with a text editor, you will see something like this: In other words, it will be sent `git send-mail`.

![Screenshot](/assets/images/screenshots/img_screenshot_git_format_patch.png)

## Check Kernel Patch

The Linux kernel source tree has many useful tools and scripts. What are the errors before submitting your Kernel Patch via Email? You can check what Warnings are with `checkpatch.pl`.

You need to run `checkpatch.pl` in the Linux kernel source tree.

```bash
./scripts/checkpatch.pl 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

![Screenshot](/assets/images/screenshots/img_screenshot_checkpatch.png)

## Get Kernel Maintainers

You do not have to worry about which kernel patch to send the kernel patch to. Before you submit your patch via email, you can see which maintainer it will send to with 'get_maintainer.pl'. Each Linux kernel subsystem has its own maintainers. Before sending the patch, you need to know which maintainer to send your patch to.

You need to run `get_maintainer.pl` in the Linux kernel tree.

```bash
./scripts/get_maintainer.pl 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

![Screenshot](/assets/images/screenshots/img_screenshot_get_maintainers.png)

## Git send-mail

After completing the above steps, the patch will be sent to the relevant maintainers with `git send-mail`.

```bash
git send-mail --to mingo@redhat.com --cc hpa@zytor.com --cc jesse.brandeburg@intel.com --cc linux-kernel@vger.kernel.org --cc clang-built-linux@googlegroups.com 0001-arch-x86-asm-Fix-arch-x86-kernel-build-error-in-clan.patch
```

When sending a kernel patch with `git send-mail`, `--to` must be the main maintainer of the kernel subsystem to which you want to send it. `--cc` should be Reviewers and Open Public Mailing Lists. An Open List is a mailing list for each kernel subsystem.

For example : `linux-kernel@vger.kernel.org` is the main Linux Kernel Mailing List (LKML). `clang-built-linux @ googlegroups.com` is a mailing list for submission of builds using the Clang compiler for the Linux kernel. Email addresses of all mailing lists can be accessed at [http://vger.kernel.org/vger-lists.html](http://vger.kernel.org/vger-lists.html). You can then subscribe to the mailing list of your favorite kernel subsystems with the email you want to use.

The generated kernel patch will be sent to kernel maintainers via `git send-mail`. Eamil will then review your patch. Email Feedback software can be used to communicate with Kernel Maintainers and CCed Reviewers for feedback. You can also use [Mutt] (http://www.mutt.org/) for Email Client Software or see [Email Clients for Linux](https://www.kernel.org/doc/html/latest/). When all is said and done, the Kernel Maintainers will review your patch via email and approve it. That way you can contribute to the Linux kernel.
