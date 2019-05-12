---
layout: post
title: "PowerShell正则匹配"
date: 2018-11-27
excerpt: "文本处理"
tags: ["PowerShell"]
comments: false
---

# PowerShell正则匹配

不得不说微软对PS的支持力度很大，PS的正则是在shell中最舒服的。同样CSV,JSON,XML各种处理PS都可以做的很好。
比如说我们有个需求，把"20:39"这样分：秒格式转换为秒，再补两个小数点，PS怎么做呢？
```PowerShell
function getsec {
    param (
        $min_sec
    )
    $min_sec -match "(\d+):" > $null
    $minute = $Matches[1]
    $min_sec -match ":(\d+)" > $null
    $second = $Matches[1]
    $sec = "{0}.00" -f ([int]($minute)*60+[int]($second))
    return $sec
}
```
- 字符串-match参数进行正则匹配
- 因为-match对产生一个True或者False的输出，而PS默认把所有输出作为返回值，我不想要，所以重定向到$null，这个语法> $null就是Write-Null这个cmdlet的语法糖。
- $matches是正则的自动变量，$matches[0]是整个匹配串，$matches[1]是括号内的内容，通常我们取$matches[1]
- 字符串的-f就是-format，格式化字符串

```PowerShell
getsec "20:39"      
#1239.00                 
```