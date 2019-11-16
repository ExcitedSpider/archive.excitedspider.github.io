---
layout: post
title: "TypeScript3.7新特性"
date: 2019-11-15
excerpt: "进化中的TS"
tags: [TypeScript]
comments: false
---

11月1号，ts发布了[3.7beta](https://devblogs.microsoft.com/typescript/announcing-typescript-3-7-beta/)版，从此版本号迈入了3.7，虽然还有很多特性等待实现，不过现在已经可以体验到许多实装的新特性了。这篇文章主要是我看3.7更新日志时的笔记和备忘，而非完整翻译。

## Optional Chaning

可选调用链，作为3.7引入的一个最新的语法糖，允许开发者方便的处理安全访问可能为undefined引用的情况。

具体来说，如果有一个数据结构为：

```typescript
interface OptionalObject{
    foo?:{
        bar?:
        	baz?:()=>void
    }
}
```

我们想调用baz方法，在原先，我们为了确保访问安全，需要写的代码为

```typescript
const a:OptionalObject = {...}
a.foo && a.foo.bar && a.foo.bar.baz && a.foo.bar.baz()
```

引入可选调用链语法后，typescript引入了新双目运算符：可选属性访问符`?.`以上代码可以简化为：

```typescript
a.foo?.bar?.baz()
```

由此我们可以看出，符号`?.`表示“**若左侧值不为`undefined`或`null`，则表达式为右侧属性; 反之则为`undefined`**”

可选属性访问符`?.`与`&&`有一些不同的是：`&&`处理js中所有表现为`falsy`的值，而`?.`只对`null`和`undefined`生效，对数字`0`，空字符串`‘’`等依然会取右值。

同样也对数组访问有支持:

```typescript
arr?.[0]
//等价于
(arr === null || arr === undefined) ? undefined : arr[0];
```

## Nullish Coalscing

这也是ECMAScript TC39的提案，但Typescript提前将其实现了。

如果还记得`||`被叫做falsy coalscing的话，这个被叫做nullish coalscing（空值触媒？不知道怎么翻译）新特性就很了解了。引入了一个新双目运算符`??`，若其左值为`null`或`undefined`，取右值。对比一下，`||`是左值为`falsy`，取右值。

关于`falsy`这个JavaScript古老的设计请看[MDN](https://developer.mozilla.org/zh-CN/docs/Glossary/Falsy).

```typescript
let x = foo ?? bar();
// 等价于
let x = (foo !== null && foo !== undefined) ?
    foo :
    bar();
```

看来委员会这是要彻底把falsy的设计赶出去啊。

## Assertion Functions

推断函数，我已经期待很久了，如果对Java熟悉其`assert`表达式的话，没错这个基本上一模一样。assert作为一个全局函数，当其中的值为falsy时将会抛出异常

```typescript
assert(someValue === 42);

declare const maybeStringOrNumber: string | number = 42
assert(typeof maybeStringOrNumber === "string") // throw new TypeError()
```

## 对`never`返回值的增强

3.6的ts中，函数`never`和`void`返回值的表现几乎一样。在3.7中，TS加强了`never`返回值的语义，表示必须抛出错误或程序终止，而不能让函数隐式返回`undefined`，`never`的语义为“函数不会执行完毕”。例如`process.exit()`返回值为`never`。

## 递归类型声明

TS一直缺少方便的递归类型声明方法，一般要多写一个辅助类型才能书写递归类型，如下：

```typescript
type Json =
    | string
    | number
    | boolean
    | null
    | JsonObject
    | JsonArray;

interface JsonObject {
    [property: string]: Json;
}

interface JsonArray extends Array<Json> {}
```

在3.7中，可以被写为：

```typescript
type Json =
    | string
    | number
    | boolean
    | null
    | { [property: string]: Json }
    | Json[];
```

## `--declaration`和`--allowJs`选项

- `–-declaration`选项：让TS编译器在编译时生成`.d.ts`声明文件。以前`.d.ts`都是要么手写，要么用第三方工具生成，这下有了官方的生成支持啦。

- `--allowJs`选项：允许混用JS，个人猜测这个会用的很少。