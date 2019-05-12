---
layout: post
title: "setTimeout 0的意义"
date: 2019-4-11
excerpt: "没想到的用法"
tags: [JavaScript]
comments: false
---

# setTimeout 0的意义

setTimeout是一个计时器，但经常看到有`setTimeout(func,0)`的写法，那实际有什么作用呢？

首先JS是单线程模型，任何时间都只有一段代码可以在运行。

javascript维护一个setTimeout队列，未执行的setTimeout任务就在队列里排序，等到**线程空闲**时和时间抵达才会执行，相当于协程。

那么setTimeout 0最大的意义就在此，等主任务结束了才会运行。

例如如下：

```js
for(var i={j:0};i.j <5;i.j++){
  console.log('main');
  (function(i){
  setTimeout(function(){console.log(i.j)},0);
  })(i);
}

//main
//main
//main
//main
//main
// 5
// 5
// 5
// 5
// 5
```

如以上代码所示，所有的setTimeout 0任务可以确保都在主循环结束之后执行。

