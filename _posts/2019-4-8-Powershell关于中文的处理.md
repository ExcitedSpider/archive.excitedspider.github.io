---
layout: post
title: "Powershell关于中文的处理问题"
date: 2019-4-8
excerpt: "字符集的问题"
tags: [Powershell]
comments: false
---

# Powershell 关于中文的处理问题

微软在做Powershell时思想非常前卫，默认字符集居然是utf16。显然这么前卫的思想问题很大，经常造成中文乱码。我总结了一下关于UTF8字符集中文的处理问题。

## 读取文件中的UTF8字符

将`Get-Content -Encoding`参数置为utf8。

## 读取源文件中的UTF8字符

如果将UTF8字符硬编码在源文件中，想要输出到屏幕上或者文件中的情况。

一定要将源文件设置为UTF8 with BOM字符集。

## 输出到UTF8编码的文件中

使用.net函数`[System.IO.File]::WriteAllLines($filepath, $linesArray)`。

如果用`Out-File` cmdlet，只能输出为UTF8 with BOM,非常的坑。

## 切换Terminal代码页为UTF8

一行代码

```powershell
CHCP 65001
```



