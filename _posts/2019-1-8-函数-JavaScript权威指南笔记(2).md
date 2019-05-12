---
layout: post
title: "函数-JavaScript权威指南笔记(2)"
date: 2019-1-8
excerpt: "继续读书"
tags: ["JavaScript"]
comments: false

---

# 函数

## 综述

> 如果函数挂载在一个对象上，作为对象的一个属性，就称它为对象的方法。当通过这个对象来调用函数时，该对象就是此次调用的上下文（context），也就是该函数的this的值。

> JavaScript里，函数即对象，程序可以随意操控它们。比如，JavaScript可以把函数赋值给变量，或者作为参数传递给其他函数。因为函数就是对象，所以可以给它们设置属性，甚至调用它们的方法。

> JavaScript的函数可以嵌套在其他函数中定义，这样它们就可以访问它们被定义时所处的作用域中的任何变量。这意味着JavaScript函数构成了一个闭包（closure），它给JavaScript带来了非常强劲的编程能力。

## 函数调用

> 有4种方式来调用JavaScript函数：
>  ·作为函数
>  ·作为方法 
>  ·作为构造函数 
>  ·通过它们的call（）和apply（）方法间接调用

- 函数调用是最普通的方法。

- 方法调用特别的是有自己的调用上下文，即调用对象成文上下文，可以用`this`引用

  > 和变量不同，关键字this没有作用域的限制，嵌套的函数不会从调用它的函数中继承this。如果嵌套函数作为方法调用，其this的值指向调用它的对象。如果嵌套函数作为函数调用，其this值不是全局对象（非严格模式下）就是undefined（严格模式下）。

  **嵌套的函数不会从调用它的函数中继承this**，如果将嵌套函数作为方法调用要手动继承this，这是一个坑点

  ```javascript
  var o = { 
      m: function() { 
          var self = this; 
          console. log( this === o);
          f();
          function f() { 
              console. log( this === o); //false
              console. log( self === o); //true
          } 
      } 
  }; 
  o. m();
  ```

- 构造函数调用，这部分见*类与模块*节

- call()和apply()间接调用，主要作用是换上下文

## 函数的实参与形参

JS不对参数检查(类型、个数等)

> 调用函数的时候传入的实参比函数声明时指定的形参个数要少，剩下的形参都将设置为undefined值。

检查`null`或`undifine`的惯用写法：

```javascript
a = a || [];
```

### 实参列表arguments

函数都有一个`arguments`属性

- 可以让函数操作任意数量实参

- `arguments`不是真正的数组，只是一个对象带了`length`属性

- 用途:

  > arguments[]对象最适合的应用场景是在这样一类函数中，这类函数包含固定个数的命名和必需参数，以及随后个数不定的可选实参。

- 别名特性：

  ```javascript
  function f(x) { 
      console.log(x);	//输出传入的
      arguments[0] = null;	//arguments[0]引用了x
      console.log(x); //输出null
  }
  ```

- `callee`和`caller`都是`arguments`的属性，引用了正在执行的函数和调用本函数的函数

- `length`属性是`arguments`的属性，实参数量

### 作为命名空间的函数

> 在函数中声明的变量在整个函数体内都是可见的（包括在嵌套的函数中），在函数的外部是不可见的。不在任何函数内声明的变量是全局变量，在整个JavaScript程序中都是可见的。在JavaScript中是无法声明只在一个代码块内可见的变量的[1]，基于这个原因，我们常常简单地定义一个函数用做临时的命名空间，在这个命名空间内定义的变量都不会污染到全局命名空间。

```js
function mymodule {
    //模块代码
    //局部变量不污染全局空间
}
mymodule()
```

## 闭包

> 函数对象可以通过作用域链相互关联起来，函数体内部的变量都可以保存在函数作用域内，这种特性在计算机科学文献中称为“闭包”

闭包是JS很有趣的一个特性，其实就是利用了JS函数是对象，而且并不是基于类C语言栈式调用的特性，让函数“捕获了”外部值，其实是对象的成员

```js
var scope = "global scope"; 
function checkscope() { 
    var scope = "local scope"; 
    function f() { return scope; } 
    return f; 
    } 
checkscope()() // local scope

```

### 作用域链

对于作用域链的描述：

> 我们将作用域链描述为一个对象列表，不是绑定的栈。每次调用JavaScript函数的时候，都会为之创建一个新的对象用来保存局部变量，把这个对象添加至作用域链中。当函数返回的时候，就从作用域链中将这个绑定变量的对象删除。如果不存在嵌套的函数，也没有其他引用指向这个绑定对象，它就会被当做垃圾回收掉。

就是说，栈调用是“硬返回的”，函数调用完毕一定会弹出堆栈，而JS的作用域链和对象一样用了垃圾回收机制。因为内部嵌套函数有外部的有效引用，所以外部函数的作用域链对象不会被回收。当再次调用内部函数时，就访问“旧的”外部函数作用域链，形成了闭包。

同样，因为外部函数作用域链对象没有被回收，外部函数的所有嵌套函数共享一个作用域链。

也是因为这个特性，js并没有“块级作用域”的说法，一个函数中声明的局部变量一开始就可以访问。

同样，这种特性也可能出现坑

- 坑1 不想共享外部变量的时候不要用闭包

    ```js
    function constfuncs() 
    { 
        var funcs = [];
        for( var i = 0; i < 10; i++) 
            funcs[i] = function() { return i; }; 
        return funcs; 
    } 
    var funcs = constfuncs(); 
    funcs[5]() // 返回10，因为所有funcs共享外部的i变量
    
    ```

- 坑2 this指针指向问题，在前面说过不会继承

- 坑3 arguments指向问题，同样嵌套函数不会继承

## 函数属性、方法和构造函数

因为函数是对象，当然可以有对象的各种行为，属性、方法、构造函数

### 属性

- prototype属性

  这是函数中最重要的属性，有了它任何函数都可以被用作构造函数，具体在类章节说明

- arguments属性，在前面讲了

### 方法

- call()和apply()方法

  用来间接调用以及设置上下文(作用域链)

  ```js
  f.apply(o,[ 1, 2]);
  //用o对象作为上下文，1,2作为实参列表对f进行调用
  ```

- bind()

  绑定函数，返回绑定后的函数，相当于`func.apply(o,arguments)`

  ```js
  var sum = function(x, y) { return x + y }; 
  var succ = sum. bind(null, 1); 
  succ(2) //3
  function f( y, z) { return this. x + y + z }; 
  var g = f. bind({ x: 1}, 2); 
  g(3) //6
  ```





