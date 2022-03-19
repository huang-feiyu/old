---
layout:     post
title:      Git-Tutorial
subtitle:   Git 简明教程
date:       2022-03-19
author:     Huang
header-img: img/post_bg_git_natural.jpg
catalog:    true
tags:
   - Other
---

> 不同于其他技术性文章，本篇文章致力于通过示例理解**使用 Git** 进行版本控制管理的 WorkFlow。

> 示例为南京大学 PA 实验：[github.com/ics-nju-wl/icspa-public](https://github.com/ics-nju-wl/icspa-public)

本文面向初学者与初级用户。由于本人水平有限，可能出现谬误，敬请指正。

文章不需要读者跟着操作，只需要理解如何使用即可。可以将 [git-tutorial](https://github.com/huang-feiyu/git-tutorial) 克隆到本地，进行更细节地查看。

### 阶段一：Git 简介

###### 安装 Git

根据 [git-scm.com/downloads](https://git-scm.com/downloads) 教程进行安装，不要勾选 GUI。如果需要用户界面程序，推荐使用 [GitHub Desktop](https://desktop.github.com/)。

在 Windows 下，Git 安装附加一个 Bash 程序，名叫 *Git Bash*，接下来的命令都可以在其中运行。

###### Git 基础

Git 是一个版本控制系统（VCS），它记录的是文件的快照。为了高效，如果文件没有修改，Git 不再重新存储该文件，而是只保留一个链接指向之前存储的文件。 Git 对待数据更像是一个 **快照流**。

同时，Git 的每一个 commit 作为一个结点；两 commit $A、B$ 之间存在 $A\to B$ 的边，当且仅当 $B$ 在 $A$ 的基础上进行文件的修改（即 $B$ 继承 $A$）；所有 commit 共同构成一个有向无环图。（具体可参见[封面图](https://www.reddit.com/r/ProgrammerHumor/comments/te237d/git_natural_edition/)）

###### 前置准备

一、简单配置

Git 自带一个 `git config` 的工具来帮助设置控制 Git 外观和行为的配置变量。 有多个存储位置，详见 [Git first time](https://www.progit.cn/#_first_time)。

* 添加个人信息：

```bash
git config --global user.name "huang-feiyu"
git config --global user.email johndoe@example.com
```

* 更易读的 Log 信息：

```bash
git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
# 只看某个作者
git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --author=huang-feiyu
```

* 别名：

```bash
# 格式如下，alias 全凭个人喜好配置
git config --global alias.s status
```

* 默认文本编辑器：

```bash
git config --global core.editor vim
```

二、仓库初始化

将仓库 clone 到本地：

```bash
git clone https://github.com/ics-nju-wl/icspa-public
```

干掉本来含有的 Git 仓库信息：

```bash
rm .git/ -rf
```

本地初始化仓库：

```bash
git init
```

三、远程仓库的初始化

在 GitHub 上创建一个全新的空仓库 [git-tutorial](https://github.com/huang-feiyu/git-tutorial)，不勾选下面的复选框。

四、针对 PA 特定的配置

由于 PA 的每一次编译都会进行一次 commit，这不符合使用 Git 的初衷：更好地进行版本管理。

所以修改 `Makefile` 将其中的 commit 行全都删去。在 Vim 下，使用如下命令：

```vim
:g/commit/d
```

### 阶段二：工作流

> 本阶段分节采用 PA 实验的分节方式，对于使用示例 PA 1 进行讲解。

###### 正式开始

在正式开启一个项目的时候，往往会选择添加 README 介绍本项目、添加 LICENSE 说明项目、`.gitignore` 忽略某些文件。有些项目还会建立 CONTRIBUTING 文档说明项目贡献方式。

一、创建一个优质的 README

更多的参见 [awesome-readme](https://github.com/matiassingers/awesome-readme) 与 [中文技术文档写作规范](https://github.com/ruanyf/document-style-guide)。

```markdown
# NEMU Lab

本仓库为南京大学 [icspa-public](https://github.com/ics-nju-wl/icspa-public) 实验代码。

> 详见仓库。
```

二、LICENSE

更多有关许可证的信息，参见 [开源许可证教程](https://www.ruanyifeng.com/blog/2017/10/open-source-license-tutorial.html)。本仓库采用 MIT 许可证。

---

接下来会进行仓库的简单配置：

一、仓库初始化

此前已经进行过 `git init` 操作，可以在根目录下发现 `.git` 文件夹。

```bash
# 查看当前状态
git status
# 添加所有文件
git add .
# 创建commit，通过`-m`添加commit信息
git commit -m "init project"
```

<strong>*</strong> `git status` 命令下，可能存在三种状态：已提交（committed）、已修改（modified）和已暂存（staged）。`git add` 命令就是将文件放到暂存区，供下一次 commit 命令进行快照。

![git status](https://www.progit.cn/images/areas.png)

二、设置远程仓库

在 GitHub 创建完仓库且没有勾选任何东西时，GitHub 会给出两条路对用户进行指导。

这里选择遵循 "push an existing repository from the command line" 进行操作：

```bash
# 添加远程仓库
git remote add origin https://github.com/huang-feiyu/git-tutorial.git
# 默认分支改名，原为master，似乎是因为政治因素改为main
git branch -M main
# 将远程仓库设置为默认的远程仓库，这样之后就能够直接使用git push进行操作
git push -u origin main
```

<strong>*</strong> 更多的有关细节指令，例如 查看远程分支 `git branch -r`等 可以直接 Google 搜到，不在此赘述。

###### PA 1-1：最基础的修改

修改 `nemu/include/cpu/reg.h` 文件。

回到根目录，使用 `git status` 查看当前状态：

```
Changes not staged for commit:
        modified:   nemu/include/cpu/reg.h
```

此时，`reg.h` 文件还没有被添加到暂存区，使用 `git add` 添加到暂存区：

```bash
# 将整个项目添加
git add .
# 选择特定文件添加
git add nemu/include/cpu/reg.h
```

创建 commit：

```bash
# 进入到默认editor，可以使用`-m`直接在命令行添加
git commit
```

在 editor 中写入 "finish pa 1-1"，保存退出。使用 `git log` 查看所有的 commit，可以看到本次 commit。

###### PA 1-2：更优质的commit

一个优质的 commit 是完成一个模块的、使项目能够运行的、加入所有应该加入的文件的。

本阶段被 [manual](https://github.com/ics-nju-wl/icspa-public-guide/blob/master/ch/ch_pa-1-2_alu.md) 分为四个部分，也就是四个模块，对应四个 commit。（其实，可以将每一个具体操作的实现作为一个 commit，例如加减操作包含 `add`、`adc`、`sub`、`sbb`，可以分别对应一个 commit）本处采用其加减操作进行讲解：

在修改完成 `alu.c` 与 `alu.h` 后，希望将一个 commit 分为 4 个，但是我们已经将所有的修改加入到暂存区：

一、将文件移出暂存区

```bash
git reset
```

二、查看修改

```bash
git diff
```

三、加入 `add` 模块

```bash
git commit -p nemu/src/cpu/alu.c
```

可以看到如下问句：

```
(1/2) Stage this hunk [y,n,q,a,d,j,J,g,/,s,e,?]?
```

<strong>*</strong> 选择[合适的指令](https://gist.github.com/mattlewissf/9958704#:~:text=git%20add%20%2Dp%20is%20basically,the%20quality%20of%20the%20commits.)进行操作即可。对于 `s` 之后的块仍然过大，选择使用 `e` 进行操作，修改 diff 文件。

To remove '-' lines, make them ' ' lines (context).

To remove '+' lines, delete them.

Lines starting with '#' will be removed.

同样地，对 `alu.h` 进行操作。

四、进行提交

```bash
git commit -m "pa1-1: implement add"
# 写错了，应该是pa1-2
```

其他的以同样的方式进行操作。由于比较麻烦，不在仓库中全部使用 `git add -p` 进行操作。

——后续还有一个 `pa1-1` 的 commit，那仅仅提交了第一个模块。之后的 `pa1-2` 的 commit 才是正确的。

###### PA 1-3：工作流

> 本部分采用 GitHub Workflow，更多细节参见：[git workflow](https://www.ruanyifeng.com/blog/2015/12/git-workflow.html)。

此处直接在本地进行编辑，不提交 PR。——毕竟就一个用户。

〇、查看本地分支

```bash
git branch
```

一、创建新分支

```bash
# 创建新分支
git branch pa1-3
# 切换到该分支
git checkout pa1-3

# => 创建并切换到该分支
git checkout -b pa1-3
```

二、在当前分支提交 commit

仅修改了一个文件 `fpu.c`，采取前面的策略创建一个 commit。

```bash
git add .
git commit -m "finish `pa1-3`"
```

——当复制我自己的代码到文件时，c 的 `\n` 转义成了行，不作修改。

三、合并到 main 中

```bash
git merge pa1-3

# => 另外，选择一个commit，合并进当前分支
git cherry-pick [commit]
```

### 阶段三：GitHub

> To be continue.

### 参考资料

1. [Git for Professional](https://www.youtube.com/watch?v=Uszj_k0DGsg&ab_channel=freeCodeCamp.org)
2. [Pro Git](https://www.progit.cn/)
3. [Git 工作流程](https://www.ruanyifeng.com/blog/2015/12/git-workflow.html)
4. [Git 命令清单](https://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
5. [Git 远程操作详解](https://www.ruanyifeng.com/blog/2014/06/git_remote.html)
6. [Git 使用规范](https://www.ruanyifeng.com/blog/2015/08/git-use-process.html)
7. [Git tips](https://github.com/521xueweihan/git-tips)
