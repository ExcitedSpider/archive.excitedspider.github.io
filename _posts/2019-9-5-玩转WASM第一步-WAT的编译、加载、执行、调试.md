---
layout: post
title: "玩转WASM第一步-WAT的编译、加载、执行、调试"
date: 2019-9-5
excerpt: "WebAssembly, WAT, 浏览器调试"
tags: [wasm]
comments: false
---

## WebAssembly是什么？

官方定义如下：

> WebAssembly (abbreviated *Wasm*) is a binary instruction format for a stack-based virtual machine. Wasm is designed as a portable target for compilation of high-level languages like C/C++/Rust, enabling deployment on the web for client and server applications.

工地英语翻译：WebAssembly(wasm)是一种为**基于堆栈的虚拟机**设计的执行的二进制指令集。WASM被设计为面向C/C++/Rust等高级编程语言的可移植的**编译目标语言**。WASM使得用这些高级语言编写的程序部署在web客户端和服务端成为了可能。

## WAT的编译

从定义我们也可以看出，为了贴近机器，wasm本质是二进制的，这对人的阅读有很大的困扰。就像x86指令集和x86汇编一样，wasm也有一种基于文本助记的表示形式WAT。

WAT是一种基于**S-表达式**的表示形式，一般来说长成这样：

```wat
(module
  (func $i (import "imports" "imported_func") (param i32))
  (func (export "exported_func")
    i32.const 42
    call $i
  )
)
```

为了将文本格式的WAT编译为浏览器可执行的二进制WASM指令，我们首先需要一个工具[wabt](https://github.com/WebAssembly/wabt)，按照其github上readme的说明进行编译即可（需要CMAKE），这方面没有什么坑的地方。

```bash
git clone --recursive https://github.com/WebAssembly/wabt
cd wabt
mkdir build
cd build
cmake ..
cmake --build .
```

经过编译，我们应该获得了编译wat的工具wat2wasm这个可执行文件。使用这个可执行文件即可进行对wat的编译。

```bash
wat2wasm input.wat -o output.wasm
```

## 浏览器加载wasm并执行

浏览器加载并执行wasm主要依靠全局变量window下的命名空间`WebAssembly`内的变量和方法。

要知道浏览器如何加载wasm并运行，需要先补充几个概念：

- `modules`模块：WebAssembly程序被划分为`modules`，每一个`modules`可以被看作部署、加载、编译的集合。一个WebAssembly程序要想被运行必须先转换为`modules`。可以看作操作系统中的可执行文件。
- `instance`实例：每个`modules`都是可以被执行的集合。当一个`modules`被执行，就成为了一个`instance`，每个`instance`拥有自己的执行栈、内存等运行相关数据。可以看作操作系统的进程概念。
- `import`：每个`instance`可以将内存、变量、方法导入，用于自身程序中，这些内存、变量、方法用`import`标示。
- `export`：每个`instance`可以导出内存、变量、方法，用于外层js或其他`instance`进行执行，这些内存、变量、方法用`export`标示。

一般来说执行顺序如下：

1. 浏览器请求`.wasm`二进制文件，加载入内存中
2. 使用`WebAssembly.instantiate`将`.wasm`文件转换为可执行的`module`，以及进行运行成为`instance`。
3. js调用`instance`中的方法访问wasm提供的方法、变量；或向`instance`传入自己的方法、变量让`instance`去执行。

通用加载wasm的代码如下(摘抄自《WebAssembly标准入门》)：

```js
function fetchAndInstantiate(url, importObject) {
  return fetch(url).then(response =>
      response.arrayBuffer() // 将wasm读取为二进制数组
  ).then(bytes =>
      WebAssembly.instantiate(bytes, importObject) //将wasm编译并执行 
  ).then(results =>
      results.instance
  );
}

fetchAndInstantiate('hello.wasm',{})// 加载hello.wasm
  .then(instance=>{
  	instance.exports.export_func() // 调用instance导出的方法
	})
```

遇到一个问题是，我在本地编译了wasm文件，想用浏览器进行调试，文件结构如下：

```
.
├── hello.wasm
├── hello.wat
├── index.html
└── utils.js
```

其中html文件如此引入wasm文件：

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>Show me the answer</title>
  </head>
  <body>
    <script src="utils.js"></script>
    <script>
      var table = new WebAssembly.Table({ element: "anyfunc", initial: 2 });
      fetchAndInstantiate("hello.wasm", { js: { table: table } }).then(
        function(instance) {
          // ...进行操作
        }
      );
    </script>
  </body>
</html>
```

直接用`file://`去打开index.html，出现报错：

```
Fetch API cannot load file:///Users/macos/WorkSpace/wasm-playground/hello.wasm. URL scheme must be "http" or "https" for CORS request.
```

如上，因为现代浏览器的同源策略，不能使用`file://`协议去进行fetch请求或xhr请求。

所以需要起一个简单的文件http服务器，用node甚至nginx之类的均可。但是我发现了一个好东西[web client for chrome](https://chrome.google.com/webstore/detail/web-server-for-chrome/ofhbbkphhbklhfoeikjpcbhemlocgigb)，可以就用chrome起一个静态文件服务器，配置也非常简单，只需要选定一个文件夹，指定一个端口就可以工作了。访问该端口，即可访问指定目录下的`index.html`文件，在进行加载就没有同源策略限制了～

![1567691272982](..\assets\img\mdimg\2019-9-5-玩转WASM第一步-WAT的编译、加载、执行、调试\1567691272982.png)

## 调试wasm程序

调试wasm程序时，依然可以打开chrome的sources标签页进行调试，chrome会简单地将`wasm`二进制表示编译为`wat`，可以像调试js一样进行一些打断点、监控变量的操作，但一般是一些程序片段而不是我们写的完整的`.wat`程序，也没有注释，不过聊胜于无，毕竟wasm还是主要作为编译目标进行工作的。