---
layout:     post
title:      Git-Tutorial
subtitle:   Git 简明教程
date:       2022-03-19
author:     Huang
header-img: img/post_bg_git_natural.jpg
catalog:    true
tags:
   - Guide
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

> 本阶段分节采用 PA 实验的分节方式，对于使用示例 PA 2 进行讲解。
>
> 为了更好地完成本部分内容，本阶段将使用两个账号进行操作：[huang-feiyu](https://github.com/huang-feiyu) 与 [i-want-to-eat-flying-fish](https://github.com/i-want-to-eat-flying-fish)。

###### PR 简介

PR 全称 Pull Request，是全球各地开发者在 GitHub 进行协作的主要手段。（此外还有 issue，由于太过简单，这里不作介绍）Pull Request 本质上是一种软件的合作方式，是将涉及不同功能的代码，纳入主干的一种流程。这个过程中，还可以进行讨论、审核和修改代码。

此前所谈论的 GitHub Workflow，即维护一个分支，依靠提交 PR 向项目推送迭代更新操作。

###### PA 2-3：提交 PR

一、`fork` 仓库

进入到 [git-tutorial](https://github.com/huang-feiyu/git-tutorial) 仓库，点击右上角的 `fork` 按钮。完成操作后，就能够在自己的页面看到仓库。

二、远程仓库

clone **自己的**仓库到本地，在命令行上进行操作。

查看远程仓库：

```bash
git remote -v

# => 只有自己的仓库，下面为REPL的Reply
origin  https://github.com/i-want-to-eat-flying-fish/git-tutorial (fetch)
origin  https://github.com/i-want-to-eat-flying-fish/git-tutorial (push)
```

此时还需要与[起初的仓库](https://github.com/huang-feiyu/git-tutorial)建立联系，即此前项目作为 上游仓库 (upstream)：

```bash
git remote add upstream https://github.com/huang-feiyu/git-tutorial
```

再次使用 `git remote -v` 命令能够观察到上游仓库已经被添加。

三、提交 commit

与前面所说的 PA1-3 类似，采用 GitHub Workflow。

```bash
# 创建分支
git checkout -b pa2-3

# 在本地完成修改操作

# 创建commit
git add .
git commit -m "finish pa2-3"

# 推送到自己的仓库中
git push origin pa2-3 # 不要推送到上游仓库，因为没有权限
```

由于切换账号的问题，我在本地无法 push 到 origin，所以采用 GUI 操作，即在 GitHub 网页进行操作。这与使用上面操作是等价的。

<strong>*</strong> 在 `push` 之前还需要拉取上游仓库的最新修改：

```bash
git fetch upstream
# 合并上游修改
git rebase upstream/main

# 如果存在冲突，修改文件冲突再进行提交
git rebase --continue
```

更多有关 `rebase`，请参见 [Git 分支-变基](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%8F%98%E5%9F%BA)。

四、创建 PR

进入自己的仓库，可以看到 "`pa2-3` had recent pushes 1 minute ago `Compare & pull request`"。

点击 <font color=green>`Compare & pull request`</font> ，可以看到<font color=green>This branch has no conflicts with the base branch</font>。之后就等待 maintainer 进行 check 和 merge 了。

<strong>*</strong> 一般来说，长期维护的项目 PR 都会很快地被审查。

###### PA 2-1：合并 commit

提交 PR 可能并不是一个 commit 就能够搞定的，往往会做一些修改，然后再提交 commit。最后可能出现多个 commit，此时就需要合并为一个 commit。

而 PA 2-1 需要实现很多个指令，此时合并 commit 也就迫在眉睫。由于已经在前面演示了如何提交 PR，此处选择在本地进行操作。

〇、创建多个 commit

使用 `git lg` 查看：

```console
* d2975e0 - (HEAD -> main) finish `and` (11 seconds ago) <huang-feiyu>
* 7c45695 - finish `add.c` (39 seconds ago) <huang-feiyu>
* b8b655d - finish `adc.c` (67 seconds ago) <huang-feiyu>
*   531c749 - (origin/main) Merge pull request #1 from i-want-to-eat-flying-fish/pa2-3 (30 minutes ago) <Huang>
```

一、合并分支

此时需要合并 `d2975e0`、`7c45695`、`b8b655d`：

```bash
# 从HEAD开始往后3个commit
git rebase -i HEAD~3

# 等价命令：合并之前的版本号
git rebase -i 531c749 # 不包含此版本
```

二、进入到 REPL 或 Editor 中

vim 中显示为：

```gitrebase
pick b8b655d finish `adc.c`
pick 7c45695 finish `add.c`
pick d2975e0 finish `and`
```

修改为：

```gitrebase
pick b8b655d finish `adc.c` `add.c` `and.c`
s 7c45695 finish `add.c`
s d2975e0 finish `and`
```

* pick：简写为 `p`，选择合并到此 commit
* squash：简写为 `s`， 此 commit 会被合并到前一个 commit（有一点递归的思想）

<strong>*</strong> 如果出现错误可以使用 `git rebase --abort` 回溯。

特殊地，合并**最近**两个 commit，可以使用：

```bash
git reset --soft HEAD^1
git commit --amend
```

###### 最后

Git 是非常强大的工具，此篇文章仅仅介绍了能够让人正常使用的命令。更多有关 Git 的资料可以看下面的参考资料，也期待每个人都能够使用规范的操作。

### 参考资料

1. [Pro Git](https://www.progit.cn/)
2. [Git tips](https://github.com/521xueweihan/git-tips)
3. [Ruanyifeng: Git 工作流程](https://www.ruanyifeng.com/blog/2015/12/git-workflow.html)
4. [Ruanyifeng: Git 命令清单](https://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
5. [Ruanyifeng: Git 远程操作详解](https://www.ruanyifeng.com/blog/2014/06/git_remote.html)
6. [Ruanyifeng: Git 使用规范](https://www.ruanyifeng.com/blog/2015/08/git-use-process.html)
7. [Ruanyifeng: Pull Request 的命令行管理](https://www.ruanyifeng.com/blog/2017/07/pull_request.html)
8. [YouTube: Git for Professional](https://www.youtube.com/watch?v=Uszj_k0DGsg&ab_channel=freeCodeCamp.org)
9. [Stackoverflow: Combining multiple commits before pushing in Git](https://stackoverflow.com/questions/6934752/combining-multiple-commits-before-pushing-in-git)
