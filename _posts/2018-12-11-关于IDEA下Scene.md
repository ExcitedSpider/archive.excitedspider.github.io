---
layout: post
title: "关于IDEA下SceneBuilder分辨率的问题"
date: 2018-12-11
excerpt: "javafx"
tags: ["JavaFX","Java"]
comments: True
---

# 关于IDEA下SceneBuilder分辨率的问题

用IDEA编写Javafx程序时遇到的，win下调用SceneBuilder低分辨率问题。

在JB社区看见一条回答：<https://youtrack.jetbrains.com/issue/IDEA-190669>

在help->VM Options中添加一条虚拟机参数：`-Dsun.java2d.uiScale.enabled=false`

这样就有高分辨率了。