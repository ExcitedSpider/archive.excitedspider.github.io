---
layout: post
title: "Generator函数【ES6】"
date: 2019-3-27
excerpt: "状态机与协程"
tags: [JavaScript]
comments: false
---

# Generator函数【ES6】

Generator是ES6提供的一种异步执行函数。由`function *`定义。

一个Generator函数调用后并不立即执行，而是返回一个Iterator对象。

Generator可以理解为状态机。每次调用Iterator对象的next方法，就移动到状态机的下一个状态，并返回一个值代表状态对象，同时其内的状态（变量）保存下来。

## yield表达式

`yield <exp>`

yield表达式标志了状态机的一个状态。调用next方法时generator函数运行逻辑如下：

1. 从当前状态开始向下执行
2. 遇到yield停止，返回一个对象`{value:x, done:false}`，value为exp表达式计算的值
3. 遇到return或执行到末尾，是为最后的状态，返回一个对象`{value:x, done:false}`，value的值为return表达式的值

## next方法

next()方法标志了一次状态转移，并返回一个值。yield语句像return语句一样没有值，但next()方法可以有一个参数，被当作上一条yield语句的返回值。

```js
function *counter(){
  for(let i=0; true; i++){
    let reset = yield i;
    if(reset) {i=-1};
  }
}

var c = counter();
c.next();	//{value:0, done:false}
c.next(); //{value:1, done:false}
c.next(true); //{value:0, done:false}
```

## for..of循环

可以用for…of循环去遍历一个generator，但这个generator要有终止状态（否则死循环）。

## 错误处理

`Generator.prototype.throw`可以在generator外抛出错误，在generator内部捕获.

```js
function* errorHandle(){
  try{
    yield 0;
  }catch(e){
    console.log('catch',e)
  }
}

let i = errorHandle();
i.throw('a');	//注意不是全局的throw函数
//catch a
```

## 立即终止

使用`Generator.prototype.return()`可以立即终止一个generator

## yield* 语句

将一个generator作为另一个generator的子状态机，使用`yield* gene()`语句

```js
function *subFA(){
  yield '0';
  yield '1';
}

function *FA(){
  yield '2';
  yield* subFA();
  yield '3';
}

for(let state of FA()){
  console.log(state.value)
}
//输出2 0 1 3 (省略回车)
```

## 协程

除了状态机，Generator还可以理解为协程的一种实现：

1. 有自己的函数栈，运行状态，堆；
2. 与线程不同，同一时间只能有一个协程占用CPU资源，其他协程处于暂停态；

所以Generator的出现使JS的多道(multiprogram)度提升。