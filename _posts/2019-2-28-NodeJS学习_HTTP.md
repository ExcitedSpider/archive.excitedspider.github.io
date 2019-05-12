---
layout: post
title: "NodeJS学习_HTTP"
date: 2019-2-28
excerpt: "NodeJS学习_HTTP"
tags: [Node]
comments: false
---

> 本内容参考《Node In Action》

# Node HTTP

本节主要包括Node本身的HTTP和TCP服务器。

Node底层的HTTP解析器是非常底层、非常灵活的，由1500行C代码写成的。

使用Node的底层HTTP方法是：

```js
var http = require('http');
var server = http.createServer(function(req,res){
    //服务器每收到一条http请求，都会用req和res调用回调函数
    //服务器会对req请求做基本的解析
    //用res.end()结束响应，否则请求挂起
    
    //每解析并读入数据，会触发data事件，
    //传入一个二进制buffer，类型相当于字符串
    req.on('data',(chunk)=>{
        console.log('parsed',chunck);
    });
    
    //数据全部读取完毕会触发end事件
    req.on('end',()=>{
        console.log('end!')
    });
})
server.listen(3000);
//监听一个端口
```

## RESTful API

对不同的Method做出反应的方法主要是：

```js
var server = http.createServer(function (req,res) {
  switch(req.method){
      case 'GET':
        //...
        res.end();
      	break;
  }
}
```

## 静态服务器

使用Node特有的流式IO编写高效静态文件服务器的要点：

- `__dirname`是Node定义的一个神奇的变量，值是文件所在目录的路径，对于创建静态文件服务器很有用。

- fs.ReadStream是高效流式硬盘访问的类，是高效读取静态文件的重要方式，读取文件时emit出data事件，结束读取时emit出end事件。

- 使用pipe可以进行流式编程

  ```js
  ReadbleStream.pipe(WriteableStream)
  ```

  ```js
  var readStream = fs.createReadStream('./ original. txt') 
  var writeStream = fs.createWriteStream('./ copy. txt') 
  readStream.pipe(writeStream);
  ```

- 对所有流式对象，都有error事件，加上回调以处理，使服务器更加健壮。

## HTTPS

使用https模块创建https链接，代码基本相同，只是在创建服务器时加入https配置：

```js
var https = require('https');
var fs = require('fs');

//证书和密钥
var options = {
  key:fs.readFileSync('./key.pem'),
  cert:fs.readFileSync("./key-cert.pem")
};

https.createServer(options, (req,res)=>{
  res.writeHead(200);
  res.end("hello world\n");
}).listen(3000);
```

