---
layout:     post
title:      Learning-Git
subtitle:   Git学习笔记
date:       2021-07-28
author:     Huang
header-img: img/post_bg_the_stranger.jpg
catalog: true
tags:
   - Programming
---

### Git学习笔记

[Git Pro](https://www.progit.cn/)

[Git MIT](https://missing-semester-cn.github.io/2020/version-control/)

###### 数据模型

1. 快照

Git将点击目录中的文件和文件夹作为集合，通过一系列快照来管理其历史记录。文件被称作Blob对象(数据对象)，目录被称为树。

下面是一棵树的例子。

```pseudocode
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
|
+- baz.txt (blob, contents = "git is wonderful")
```

2. 历史记录建模：关联快照

Git中，历史记录是一个由快照组成的有向无环图。快照被称为`commit`，`commit`是不能改变的——只能够通过修改重新`commit`。

3. 数据模型

```pseudocode
// 文件就是一组数据
type blob = array<byte>

// 一个包含文件和目录的目录
type tree = map<string, tree | blob>

// 每个提交都包含一个父辈，元数据和顶层树
type commit = struct {
    parent: array<commit>
    author: string
    message: string
    snapshot: tree
}
```

4. 对象和内存寻址

对象

```pseudocode
type object = blob | tree | commit
```

内存寻址通过SHA-1散列寻址 

```pseudocode
objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

5. 引用

所有的快照都能通过哈希值来标记，可以通过向各个散列值赋予具有可读性的名字，也就是引用。

master一般作为最新一次提交，HEAD是一个特殊的索引——表示我们的当前位置。

```pseudocode
references = map<string, string>

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```

6. 仓库

在硬盘中，Git仅仅存储对象和引用：因为其数据模型中仅仅包含这些东西。

7. 暂存区

staging area允许指定提交那些修改。

###### 特点

* 速度
* 简单化
* 非线性开发
* 完全分布式

###### 基础

* 直接记录快照，而非差异比较：利用指针索引
* 文件内容由SHA-1散列计算，以此保证数据完整性
* Git一般只添加数据
* 三种状态：已修改、已暂存、已提交
* 一般需要在刚开始就设置好`.gitignore`
  * 所有空行或者`#`注释行被忽略
  * 使用标准glob模式匹配——简化的正则表达式 
  * `/`开头防止递归
  * `/`结尾指定目录
  * 要忽略指定模式以外的文件或者目录，可以加上`!`取反
  * [gitignore](https://github.com/github/gitignore)
* `git diff`只显示尚未暂存的改动
* `git commit`进入vim修改提交messagea，每一次的commit，都是一次快照
  * git commit --amend: 重新提交
* `git rm` `git mv`: 文件修改
* `git log`：列出所有更新，存在很多参数个性化输出
  * git log --all --graph --decorate
* git reset HEAD \<file>：取消暂存
* git remote: 远程仓库
  * git remote -v: 查看远程仓库及其URL
  * git remote add \<shortname> \<url>: 添加远程仓库 
  * git remote show \[remote-name]: 查看远程仓库更多信息
  * git remote rename: 重命名一个远程仓库
  * git remote rm: 删除一个远程仓库
* git fetch [remote-name]: 拉取远程仓库的信息
* git pull: 拉取并合并
* git push \[remote-name] [branch-name]: 将本地master分支推送到original服务器上
* git tag: 列出已有标签
  * 标签分为：轻量标签和附注标签
  * git tag -a v1.4 -m "my version 1.4": 创建一个附注标签
  * git show v1.4: 查看标签信息
  * git tag v1.2-lw: 创建轻量标签
  * git tag -a v1.2 9fceb02: 对过去提交打标签
* git config --global alias ci commit: 命令别名

###### 分支模型

* 分支本质上是**指向提交对象的可变指针**，默认分支为master，在多次提交操作之后，head不断向前移动
  * master并非一个特殊分支，它可以修改成其他的名字
* `HEAD`是特殊指针：指向当前所在的本地分支
* `git log --oneline --decorate --graph --all`:查看各个分支的指向以及项目的分支分叉情况
* git branch: branch列表
  * git branch \[new-branch-name]:创建testing分支，也就是可以移动的新指针(创建分支却并不会移动到新分支上去)
  * git branch -d \[branch-name]: 删除一个分支
  * git branch -v: 查看每个分支最后一次提交
  * git branch -D \[branch-name]: 强制删除一个分支
* git checkout \[branch-name]: 切换到指定分支
  * 分支切换时，会改变工作目录里的文件
  * git checkout -b \[branch-name]: 新建一个分支并切换上去
* git merge \[another-branch]: 在一个分支上，合并另一个分支
* 分支开发工作流
  * 长期分支：可以使用master作为稳定版本，develop开发指针不断右移，test平行指针，当稳定时合并到master中
  * 特性分支
* 远程分支
  * git remote show: 获取远程分支信息
  * `(remote)/(branch)`: 远程分支命名
    * [remote-name]=origin并没有特殊含义，默认的远程仓库名；可以`git clone -o [specific-name]` 自定义名字
  * git fetch origin: 抓取本地没有的数据，移动origin/master到更新的位置，而本地不变
  * git push (remote) (branch): 推送到远程仓库的特定分支上去
  * git checkout --track origin/serverfix: 跟踪分支
  * git pull ≈ git fetch; git merge
    * 推荐使用后者
  * git push origin --delete serverfix: 删除origin服务器上的serverfix分支
* 变基：rebase，弄不清楚

###### 常用的几个命令

- `git help <command>`: 获取 git 命令的帮助信息

- `git init`: 创建一个新的 git 仓库，其数据会存放在一个名为 `.git` 的目录下

- `git status`: 显示当前的仓库状态

- `git add <filename>`: 添加文件到暂存区

- `git commit`: 创建一个新的提交

  - 如何编写 [良好的提交信息](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)!
  - 为何要 [编写良好的提交信息](https://chris.beams.io/posts/git-commit/)

- `git log`: 显示历史日志

- `git log --all --graph --decorate`: 可视化历史记录（有向无环图）

- `git diff <filename>`: 显示与暂存区文件的差异

- `git diff <revision> <filename>`: 显示某个文件两个版本之间的差异

- `git checkout <revision>`: 更新 HEAD 和目前的分支

**分支和合并**

- `git branch`: 显示分支

- `git branch <name>`: 创建分支

- `git checkout -b <name>`: 创建分支并切换到该分支
  - 相当于 `git branch <name>; git checkout <name>`
  
- `git merge <revision>`: 合并到当前分支

- `git mergetool`: 使用工具来处理合并冲突

- `git rebase`: 将一系列补丁变基（rebase）为新的基线

**远端操作**

- `git remote`: 列出远端
- `git remote add <name> <url>`: 添加一个远端
- `git push <remote> <local branch>:<remote branch>`: 将对象传送至远端并更新远端引用
- `git branch --set-upstream-to=<remote>/<remote branch>`: 创建本地和远端分支的关联关系
- `git fetch`: 从远端获取对象/索引
- `git pull`: 相当于 `git fetch; git merge`
- `git clone`: 从远端下载仓库

**撤销**

- `git commit --amend`: 编辑提交的内容或信息
- `git reset HEAD <file>`: 恢复暂存的文件
- `git checkout -- <file>`: 丢弃修改

**Git 高级操作**

- `git config`: Git 是一个 [高度可定制的](https://git-scm.com/docs/git-config) 工具
- `git clone --depth=1`: 浅克隆（shallow clone），不包括完整的版本历史信息
- `git add -p`: 交互式暂存
- `git rebase -i`: 交互式变基
- `git blame`: 查看最后修改某行的人
- `git stash`: 暂时移除工作目录下的修改内容
- `git bisect`: 通过二分查找搜索历史记录
- `.gitignore`: [指定](https://git-scm.com/docs/gitignore) 故意不追踪的文件

