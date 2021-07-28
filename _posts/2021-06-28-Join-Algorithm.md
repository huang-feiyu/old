---
layout:     post
title:      Join-Algorithm
subtitle:   数据库连接算法
date:       2021-06-28
author:     Huang
header-img: img/post_bg_beach_magic.jpg
catalog: true
tags:
   - Programming
   - Database	
   - Algorithms
---

### Join-Algorithm

###### 定义与需求

join是relational database非常重要的一部分：

* 关系型数据库几乎完全消除了数据冗余
* 通过table将数据组织起来，与此同时还可以通过join重新将各个元组组织起来形成一个所需要获取的结果
* join的使用真实地提高了关系型数据库的作用

遵循late materialization的原则，join操作最后只会呈现出需要的column：

* 只复制连接键(join key)和特定的列
* 比较小的table作left table(outer table)

(这里只讨论两个表的Join操作)为后续算法分析作出铺垫，I/O复杂度分析：复杂度向上取整打不出来，可以查看[pdf](https://15445.courses.cs.cmu.edu/fall2019/slides/11-joins.pdf)

* 表R有M个pages，m个tuples
* 表S有N个pages，n个tuples

###### 嵌套循环连接算法

* 简单嵌套循环算法：对于每一个在R中的元组，都扫描S一遍

* Cost: M + (m\*N)

* 伪代码实现：

  ```pseudocode
  foreach tuple r ∈ R:
    foreach tuple s ∈ S:
      emit, if r and s match
  ```



* 块嵌套循环算法：对于每一个R中的块，都扫描S一遍

* Cost: M+(M*N);  Use B-2 buffers for scanning R: M+(M/(B-2)\*N) M+ ($\lceil M / (B-2) \rceil$ ∙ N)

* 伪代码实现：

  ```pseudocode
  foreach block Br ∈ R:
    foreach block Bs ∈ S:
      foreach tuple r ∈ Br:
        foreach tuple s ∈ Bs:
          emit, if r and s match
  ```



* 索引嵌套循环算法：使用已经存在或者临时创建的index去简化连接
* Cost: M + (m\*C)
* 伪代码实现：

```pseudocode
foreach tuple r ∈ R:
  foreach tuple s ∈ Index(ri = sj):
    emit, if r and s match
```



对于嵌套循环连接，这种方法一般不使用，因为效率太低了。正因为如此，那些算法科学家不断地改进然后出现了许许多多的优秀的算法：效率大大提升了，于是世界变化得更加地迅速，我们会自食恶果的——扯远了，下面是两种优秀的算法。

###### 排序-归并连接算法

* 步骤一——排序：利用内部排序或者外部归并排序将join key排序
* 步骤二——归并：使用两个游标分别标记两张排序好的表，然后顺序比较tuple(可能需要backtrack，视情况而定)
* Sort Cost: 2M\*(log M / log B) + 2N\*(log N / log B)   
* Merge Cost: (M + N)

```pseudocode
sort R,S on join keys
cursorR <- Rsorted, cursorS <- Ssorted
while cursorR and cursorS:
  if cursorR > cursorS:
    increment cursorS
  if cursorR < cursorS:
    increment cursorR
  elif cursorR and cursorS match:
    emit
    increment cursorS
```

使用时机：

* 存在表已经根据join key排好序了
* 输出要求有序
* 输入关系可以通过显式排序运算符排序，也可以通过使用连接键上的索引扫描关系来排序

###### 哈希连接算法

* If tuple r ∈ R and a tuple s ∈ S satisfy the join condition, then they have the same value for the join attributes
* If that value is hashed to some partition i, the R tuple must be in r<sub>i</sub> and the S tuple in s<sub>i</sub>
* Therefore, R tuples in r<sub>i</sub> need only to be compared with S tuples in s<sub>i</sub>

* 步骤一——建立哈希函数：扫描outer table并使用连接属性上的哈希函数填充哈希表
* 步骤二——查询：扫描inner table并使用哈希函数判断值，再与该值对应的outer table的元组进行比较，判断是否满足条件

```pseudocode
build hash table HTr for R
foreach tuple s ∈ S
  output, if h1(s) ∈ HTr
```

哈希函数：

* key为join key
* value根据需求的变化而变化，一般不会使用full tuple

还有Grace Hash Join 用于memory不够的情况下的哈希连接，这里就不展开介绍。

###### 布隆过滤器——Bloom Filter

[Wikipedia](https://en.wikipedia.org/wiki/Bloom_filter)

一种数据结构，形式为位图(Bitmap)，是一种十分优秀的数据结构。

* 如果是假的，那么绝对是假
* 如果是真的，不一定为真

只有两种操作：

* 插入：插入一个东西时，使用k个哈希函数分别对其求值，设置位图相应位置的真假
* 查找：查找一个东西时，使用k个哈希函数分别对其求值，查找是否全部为真

当哈希表中可能不存在密钥时，在构建阶段创建Bloom过滤器，能够大大提高效率。