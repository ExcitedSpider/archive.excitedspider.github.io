---
layout: post
title: "webpack学习笔记"
date: 2019-3-8
excerpt: "前端工具链集大成者"
tags: [JavaScript]
comments: false
---

# Webpack学习笔记

> 本文参考：[Webpack中文网](https://www.webpackjs.com/)

webpack 是一个现代 JavaScript 应用程序的静态模块打包器(module bundler)。所谓的打包，我觉得就像Java的Maven一样是一套工具链集合，包括很多插件、生成、运行等等功能。

## 安装

当然还是建议为项目单独安装，为了版本兼容性。

```shell
npm install --save-dev webpack webpack-cli
```

## 概念

1. **webpack.config.js**是webpack的配置文件，几乎都是在`module.exports`进行配置的，以下代码均为配置文件代码。

2. 入口entry和出口output

   entry指示webpack编译的起点，从起点开始每个依赖项一个一个被处理成输出文件。

   output指示webpack编译生成(emit)到哪里。

   ```js
   const path = require('path');
   
   module.exports = {
     entry: './path/to/my/entry/file.js',
     output: {
       path: path.resolve(__dirname, 'dist'),
       filename: 'my-first-webpack.bundle.js'
   	}
   };
   ```

3. loader 处理器

   webpack原生只能加载并处理js文件，loader 的主要作用是加载非JavaScript文件，作为webpack打包的一部分。

   ```js
   //module.exports
   module: {
       rules: [
           //处理所有后缀为txt的文件都用raw-loader
           { test: /\.txt$/, use: 'raw-loader' }
       ]
   }
   ```

   - ts-loader 处理TypeScript
   - css-loader 处理css
   - 等等

4. plugin 插件

   插件用来打包优化压缩等等复杂功能，是webpack中功能最强大的一块，有内置plugin也有其他的，需要require进配置文件。

   ```js
   //第三方插件，用npm安装
   const HtmlWebpackPlugin = require('html-webpack-plugin'); 
   // 用于访问内置插件
   const webpack = require('webpack'); 
   ```

   ```js
   //module.exports
   plugins: [
       new HtmlWebpackPlugin({template: './src/index.html'})
     ]
   ```

   - BabelMinifyWebpackPlugin  使用babel进行压缩的插件
   - UglifyjsWebpackPlugin  使用UgilifyJS的插件
   - 等等

5. mode 模式

   简单来说就是不同模式下可以分别配置

   ```js
   //module.exports
   mode: 'production'
   ```

## webpack基本使用

1. CLI方式（在node_modules/.bin/下的二进制文件）

   ```shell
   npx webpack --config <配置文件名>
   # 配置文件默认根目录下的
   ```

2. npm script方式

   ```json
   //package.json
   "scripts": {
       "build": "webpack --config webpack.config.js"
   }
   ```

   ```shell
   npm run build
   ```

## 模块

虽然ES2015中的`import`和`export`还未被所有浏览器支持，但使用webpack可以尽情使用，会编译成旧版本的代码，而且兼容性好，所以随便用吧。

这是webpack唯一不做任何配置时会汇编的东西。

## webpack.config.js

虽然webpack支持无配置运行，但很多配置还是要基于配置文件，在根目录下创建webpack.config.js（当然也可以叫其他名字，不过这样标准名称可读性好，而且不设置`--config`参数也会默认读取）

```js
const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  }
};
```

## 管理资源

### 依赖图

webpack会分析文件间的依赖行为，生成依赖图，在依赖图之外的文件不会被打包，也可以接收非js代码文件，通常可以打包为一个bundle。

### HTML资源

HTML比较不一样，需要一个专门的插件进行管理，生成的html会自己修改引用文件名，保持依赖关系，非常的nice。

```shell
npm install --save-dev html-webpack-plugin
```

```js
plugins: [
     new HtmlWebpackPlugin({
       title: 'Output Management'
     })
],
```

### CSS资源

```shell
# 安装两个loader
npm install --save-dev style-loader css-loader
```

```js
//webpack.config.js
rules: [
       {
         test: /\.css$/,
         use: [
           'style-loader',
           'css-loader'
         ]
       }
     ]
```

```js
//网页直接加载的js
import './style.css';
```

### 图片资源

套路一样

```shell
npm install --save-dev file-loader
```

```js
{
         test: /\.(png|svg|jpg|gif)$/,
         use: [
           'file-loader'
         ]
}
```

```js
import Icon from './icon.png';
```

### 字体文件

套路一样

```shell
npm install --save-dev file-loader
```

```js
{
         test: /\.(woff|woff2|eot|ttf|otf)$/,
         use: [
           'file-loader'
         ]
}
```

```css
@font-face {
   font-family: 'MyFont';
   src:  url('./my-font.woff2') format('woff2'),
         url('./my-font.woff') format('woff');
   font-weight: 600;
   font-style: normal;
}
```

### 数据

通过loader是可以直接解析格式化数据的，JSON是内置的就不举例了

- csv: csv-loader
- xml: xml-loader

## 管理输出

分bundle包基本方法：

```js
const path = require('path');

module.exports = {
  entry: {
     app: './src/index.js',
     print: './src/print.js'
   },
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'dist')
  }
};
```

## source map

```js
devtool: 'inline-source-map'
```

## 自动代码编译

webpack提供了几种关于代码自动编译的选项

1. webpack's watch mode

   最简单，但不会自己刷新，需要刷新网页才行

   ```js
   //package.json
   "scripts": {
     "watch": "webpack --watch",
     "build": "webpack"
   },
   ```

2. webpack-dev-server

   最常用。会自己检测刷新，但需要安装插件：

   ```shell
   npm install --save-dev webpack-dev-server
   ```

   ```js
   //webpack.config.js
   devServer: {
     contentBase: './dist'
   },
   ```

   ```json
   //package.json
   "scripts":{
     "start":"webpack-dev-server --open"
   }
   ```

3. webpack-dev-middleware

   太小众了，总之不如第二种的自动刷新和第一种的方便，就不说了。

