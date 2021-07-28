---
layout:     post
title:      The-Items-of-Reinstall-OS
subtitle:   重装系统的一点注意事项
date:       2021-07-17
author:     Huang
header-img: img/post_bg_windows_10.png
catalog: true
tags:
   - Other
---

### 前言

俗话说得好：“重启解决90%的问题，重装解决99%的问题，重买解决100%的问题。”当然，这句话和我的这篇文章没有半毛钱关系。

这篇文章简单地讲述重装系统的注意事项——其实就是我最近发现电脑上有些东西配置的不够好，需要重装一遍而已。这篇文章并不会告诉你如何重装系统，这只是我重装系统的提醒自己的一些东西。

### 主体

###### Item 0: 重装的预备知识

[Windows 10](https://www.bilibili.com/video/BV1b7411L785)简单介绍+[如何重装系统](https://www.zhihu.com/question/54059979)，当然只有电脑小白需要这些看一下。

电脑小白=只会操作GUI程序=不会快捷键=只会用Office套件=计算机二级水平之下≈毛都不懂

快捷键的使用能够大大提高工作效率，我现在基本都不需要鼠标和触摸板了——vim永远的神！

###### Item 1: 重装的目的

重装的目的大概有几种，我也列举不完。做任何事情都需要想清楚自己的目的，中途最好不要忘记，如果想要改变自己的目的就需要重新调整一整个计划。

此次我重装的目的是：

1. 更新自己的大脑，毕竟学习什么的都是在电脑上进行
2. 更新一些软件——VS2022，干掉一些软件：一些我现在还不是很需要的软件
3. 换张壁纸——这个不需要重装
4. 整理电脑文件，让电脑更加有条理一些

###### Item 2: 文件的备份

推荐使用固态硬盘备份，当然我没有固态硬盘，所以我就把文件放在了百度云盘上面——SVIP不是盖的。要了解自己需要什么文件还有想要干掉哪些文件。经过前几次的经验之后，我会选择直接安装JetBrains Tool Box

我这里列举一个例子：比如说我经常忘记密码，那么我可以选择通过一个软件将密码存储在云端。在之后就可以仅仅通过登录一个软件获取自己的所有密码。

包括一些配置文件等等的都需要自己导出，大概知道需要什么文件就行了：

* Windows Terminal：setting.json

* IDEA: settings.zip

* VS Code: 使用插件`Setting Sync`来同步配置，当然我并不需要同步vs code的设置——因为我上个学期没怎么用vs code

* Chrome: 登录Google账号就可以拉取配置

* Windows 10: 登录Microsoft账号就能拉取设置

* WSL: 文件路径

  `C:\Users\36542\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu18.04onWindows_79rhkp1fndgsc\LocalState\rootfs\home\huang`

  * Vim: vimrc
  * Project

###### Item 3: 软件的记录

* Tools: 一些简单的工具，直接上传到网盘上就可以
* 软件：
  * 360zip
  * Adobe Acrobat-DC-Pro
  * BaiduNetdisk
  * CCleaner
  * Clash
  * EVCapture
  * Firefox
  * PotPlayer
  * Snipaste
  * Telegram
  * Tencent
    * Meeting
    * QQ
    * QQMusic
    * WeChat
  * Typora
  * UWP
    * To Do
    * Terminal
    * EarTrumpet
    * Bluetooth Audio Receiver
    * Ubuntu 18.04: 可以换成20.04
  * Chrome: 插件已经在Google账号中存储
  * Easy Connect
  * Power Toys
  * Edge
* 生产工具：
  * NaviCat
  * Git
  * JetBrains Tool Box
  * Microsoft
    * VS Code
    * VS 2022
  * 微信开发者工具
  * VMware

###### Item 4: 简单事项

* 分盘
  * Windows C: 175GB
  * Develop D: 40GB
  * Files F: 175GB
  * Project P: 30GB
  * Software: 30GB
  * Other O: 26.4GB
* Windows的一些简单设置

### 后记

~~还没写，等我重装完之后再写。~~我只安装了一些软件，那些生产工具还没有安装。唯一的一个体验就是找壁纸太难了！
