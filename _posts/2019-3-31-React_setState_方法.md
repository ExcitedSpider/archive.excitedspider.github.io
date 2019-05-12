---
layout: post
title: "React setState 方法"
date: 2019-3-31
excerpt: "React setState 方法"
tags: [React]
comments: false

---

# setState机制

React通过this.state来访问state，通过this.setState()来设置state并触发re-render。除了自定义组件的constructor方法，任何地方都不能直接通过this.state去设置属性。setState也能传入一个回调函数，通知setState完成。

```typescript
React.Component.prototype.setState 
  = function(partialState:Object, callback:function)
```

## setState异步更新

setState通过一个队列机制实现state更新，而不是直接去写state。更新队列会将需要更新的state合并，并触发异步更新方法`enqueueUpdate()`。所以如果直接通过this.state去更新组件，那么就不会调用到真正的更新方法，就不会完成re-render的需求。

## 批量更新

**事务**是state实现批量更新的方法，在一个事物中的setState会在事务结束时进行合并批量更新，允许使用setState的生命周期方法基本上都是一个事务，所以都能合并更新提高性能。但React的设计不建议自建事务。