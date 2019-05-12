---
layout: post
title: "PowerShell中关于与null比较的规范"
date: 2018-12-24
excerpt: "翻译"
tags: ["PowerShell"]
comments: false
---

# PowerShell中关于与null比较的规范

为确保PowerShell执行正确的`$null`比较，`$null`应该放在比较符左侧，原因如下：

- $null是标量，而当比较运算符左侧是标量时，可以确保比较返回值是一个Boolean。范例是当左侧是集合时，比较运算符是返回集合(比如-eq就返回与右操作数逻辑等的元素集合)。这样在某些情景下会产生歧义。
- PowerShell的比较运算实现中，采取了从右到左的类型转换。将$null放在左边避免了对​$null转换可能发生的错误。

## 示例

```PowerShell
function Test-CompareWithNull
{
	if ($null -eq $DebugPreference)
	{
    #...
	}
}
```

## 原文

>To ensure that PowerShell performs comparisons correctly, the $null element should be on the left side of the operator.
>
>There are a number of reasons why this should occur:
>
>- \$null is a scalar. When the input (left side) to an operator is a scalar value, comparison operators return a Boolean value. When the input is a collection of values, the comparison operators return any matching values, or an empty array if there are no matches in the collection. The only way to reliably check if a value is $null is to place $null on the left side of the operator so that a scalar comparison is perfomed.
>- PowerShell will perform type casting left to right, resulting in incorrect comparisons when $null is cast to other scalar types.

<https://github.com/PowerShell/PSScriptAnalyzer/blob/development/RuleDocumentation/PossibleIncorrectComparisonWithNull.md>
