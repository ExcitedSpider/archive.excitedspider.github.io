---
layout: post
title: "关于Clipboard命令在Powershell被取消的问题"
date: 2018-12-23
excerpt: "个人意见"
tags: ["PowerShell"]
comments: false
---

# 关于Clipboard命令在Powershell被取消的问题

最近换到了PowerShell Core，即开源社区做的跨平台版本，版本号6.1。

我在平常地写一些脚本的时候发现了`Set-Clipboard`和`Get-Clipboard`命令竟然报错了。

github相关issue中是这样解释的：

>At this time the Clipboard cmdlets are not compatible with PSCore6 as it depends on a System.Windows.Forms class which isn't part of corefx and would not be cross platform compatible.

>I do think the clipboard cmdlets are useful, but should be a separate module that is cross platform compatible which may require different code paths per OS.

反正就是由于跨平台牺牲掉了（其实我觉得很扯，社区里面有人写出了跨平台版module），解决方法主要有这些：

- 用原生的剪贴板工具，比如Win下的clip.exe，但这些工具怎么说呢，太简陋了。比如遇到中文字符集不对就GG。跨平台更别提。
- 用社区里有人写出来的ClipboardText，[地址](https://www.powershellgallery.com/packages/ClipboardText/0.1.7)
- 回到右键粘贴时代（这是个卵子解决方法）

祝脚本少年天天开心。