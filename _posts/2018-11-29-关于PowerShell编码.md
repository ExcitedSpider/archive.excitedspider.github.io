---
layout: post
title: "关于PowerShell编码"
date: 2018-11-29
excerpt: "坑啊"
tags: ["PowerShell"]
comments: false
---
 
# 关于PowerShell中文编码

我是PowerShell5.0环境，我尝试自动化生成博客markdown模板的时候使用了下面的语法：
```PowerShell
$blogHeader > xxxx.md
```
感觉非常正常的操作，但开jekyll build居然崩了，报了INVALID UTF8 CHAR;
看了半天，竟然是PowerShell的OutFile的默认字符集是UTF16，什么鬼，你软真引领时代潮流；
所以改成这样：
```PowerShell
$blogHeader | Out-File xxx.md -Encoding utf8
```
