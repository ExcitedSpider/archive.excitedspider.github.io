---
layout: post
title: "PowerShell创建软硬链接"
date: 2018-12-3
excerpt: "利用CMDLet创建软链接"
tags: ["PowerShell"]
comments: false
---

# PowerShell创建软硬链接

网上关于PowerShell创建链接的帖子都比较老了，很多还用的.COM方法，十分别扭。

其实5.0版本的PowerShell就提供了方法，包括软硬链接。

## 软连接

软连接就是windows最常用的'快捷方式'，PowerShell里成为SymbolicLink.删除、更改软链接本身，被连接文件都不改变。

```powershell
 cd $home\desktop
 New-Item -ItemType SymbolicLink -Path booklink.pdf -Target '.\book\Windows PowerShl高级编程.pdf'

 #这样我就把电子书Windows PowerShl高级编程.pdf在桌面下创建了一个软链接
```

## 硬链接

windows图形界面中比较少用的链接，更改硬连接的动作会直接写回到原文件，不能跨驱动器创建链接，也不能给文件夹创建链接。限制比较多。

用法是将`-ItemType`参数设置为`HardLink`.

[参考](https://docs.microsoft.com/en-us/powershell/wmf/5.0/feedback_symbolic)