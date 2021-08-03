---
layout:     post
title:      Summer-vacation-Journal-38
subtitle:   2021暑假手记-38
date:       2021-08-03
author:     Huang
header-img: img/post_bg_xiaoyin_and_i.jpg
catalog: true
tags:
   - Journal
---

### 前言

2021夏季的暑假手记——虽然不是手写的，这里会大概记录我暑假的每一天(如果我记了的话)。

今天写出来的的内容是：bash学习笔记。

其他有: C++学习、MIT计算机知识学习。

### Bash学习笔记

 学习[Bash](https://wangdoc.com/bash/)使用的资料是阮一峰的bash教程。（当然，这篇文章中的bash和Shell是同义的）

###### 简单介绍

* Shell: 人与计算机系统交互的工具
* `echo`: 输出文本（多行使用双引号）
  * -n: 取消换行符
  * -e: 解释特殊字符
* `;`：命令结束符
*  command1 `&&` command 2: 1运行成功，则继续运行2
* command1 `||` command 2: 1运行失败，则运行2
* `type`: 查看命令类型

###### 行操作

```bash
set editing-mode vi
```

使用vim可以更加迅速

* `ctrl+l`: 清屏
* `ctrl+c`: 中止
* `shift+Pageup`: 向上滚动
* `shift+Pagedown`: 向下滚动
* `ctrl+u`: 删除光标前所有
* `ctrl+k`: 删除光标后所有
* `ctrl+d`: 关闭shell会话
* `ctrl+a`: 回到行首
* `Ctrl + j`：等同于回车键（LINEFEED）
* `Ctrl + m`：等同于回车键（CARRIAGE RETURN）
* `Ctrl + o`：等同于回车键，并展示操作历史的下一个命令
* `Ctrl + v`：将下一个输入的特殊字符变成字面量，比如回车变成`^M`
* `Ctrl + [`：等同于 ESC
* `Alt + .`：插入上一个命令的最后一个词
* `Alt + _`：等同于`Alt + .`

###### 模式扩展

* 模式扩展：特殊字符、通配符的扩展。bash先进行扩展，再执行命令
  * 并没有[正则表达式](https://github.com/huang-feiyu/Learning-Space/tree/master/Other/RegEx-Learning)那样强大灵活，但是胜在简单和方便
* `~`: 扩展为当前用户(Huang)的主目录
* `?`: 扩展为文件路径中任意一个非空格字符
* `*`: 扩展为文件路径中任意数量的任意字符
* `[]`: 当文件存在时扩展，取任意方括号中的一个字符
* `[start-end]`: 连续范围扩展
* `{}`: 表示分别扩展括号里的所有值
* `{start..end}`: 连续范围扩展
  * 建立文件(夹)
  * 在for循环中使用
  * {start..end..step}: 指定步长
* `$`: 变量扩展、子命令扩展`$()`、算术扩展`$(())`
* `[[:class:]]`: 字符类扩展
* `shopt`：可以调整bash行为
  * -s: 打开
  * -u: 关闭
  * shopt [optionname]: 查询参数打开还是关闭
  * dotglob: 隐藏文件显示
  * nullglob: 通配符不匹配任何文件名的时候，返回空字符
  * failglob: 不匹配任何文件名，报错
  * extglob: 支持量词语法
  * nocaseglob: 让通配符扩展不区分大小写
  * globstar

###### 转义和引号

* 特殊字符`\`转义
* `''` `""`:字符串
*  here 文档是一种输入多行字符串的方法

```here
<< token
text
token
```

###### 变量

* 环境变量: 
  * `env`查看
* 用户变量:
  * `set`查看
  * `unset`: 删除变量
* `export`: 输出变量
* 特殊变量

###### 字符串操作

* `${#varname}`: 查看字符串长度
* `${varname:offset:length}`: 字符串提取子串
* 搜索和替换
* 改变大小写
  * `${varname^^}`: 转为大写
  * `${varname,,}`: 转为小写

###### 算术运算

`$(())`支持算术运算

* 逻辑运算
  
	* `<`：小于
	
	* `>`：大于
	* `<=`：小于或相等
	* `>=`：大于或相等
	* `==`：相等
	* `!=`：不相等
	* `&&`：逻辑与
	* `||`：逻辑或
	* `!`：逻辑否

###### 目录堆栈

* `cd -`: 回到上一次的目录
* `pushd` 和 `popd`: 操作目录堆栈
* `dirs`: 显示堆栈的内容

###### 脚本入门

脚本：包含一系列命令的文本文件，可以重复使用、自动调用

* Shebang: 脚本第一行的名称，指定脚本通过什么解释器执行
  * 脚本文件通常使用`.sh`后缀名

```bash
#!/bin/bash
#或者
#!/bin/zsh
```

* 执行权限和路径

```bash
# 给所有用户执行权限
$ chmod +x script.sh

# 给所有用户读权限和执行权限
$ chmod +rx script.sh
# 或者
$ chmod 755 script.sh

# 只给脚本拥有者读权限和执行权限
$ chmod u+rx script.sh
```

* `env`命令

```bash
# 新建一个不带任何环境变量的shell
env -i /bin/sh
```

* 注释

```bash
# 注释
echo 'hello world' # 注释
```

* 脚本参数
  * 在脚本文件内部通过特殊变量来调用这些参数
  * `$0`：脚本文件名，即`script.sh`。
  * `$1`~`$9`：对应脚本的第一个参数到第九个参数。
  * `$#`：参数的总数。
  * `$@`：全部的参数，参数之间使用空格分隔。
  * `$*`：全部的参数，参数之间使用变量`$IFS`值的第一个字符分隔，默认为空格，但是可以自定义。

* `shift`命令：改变脚本参数

---

To be continue……

读不下去了

---

### 其他

* 今天真的只有我一个人了，最后一个舍友也走了。我现在连一个望着孤月的人的悲哀都没有了，月亮藏了起来，她在躲着我。
* 又读了一遍《地下室手记》，心里好受了一些——当我看到有人和我具有类似的想法的时候，总是会这样。但是，不久之后，我又会感到沮丧。
