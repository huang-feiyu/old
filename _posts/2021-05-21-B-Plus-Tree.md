---
layout:     post
title:      B-Plus-Tree
subtitle:   B+树，在任何方面都很优秀
date:       2021-05-21
author:     Huang
header-img: img/post_bg_B_Plus_Tree.jpg
catalog: true
tags:
   - Programming
   - Database

---

> 简单的B<sup>+</sup> 树笔记，查询、插入、删除的简单解释。


算法可视化**[Track Visualization](https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html)**

#### [B+Tree Definition](https://zh.wikipedia.org/wiki/B%2B%E6%A0%91)

**由于技术原因，在本篇文章中我们约定m/2就是 ![\lfloor m/2\rfloor ](https://wikimedia.org/api/rest_v1/media/math/render/svg/87be5eefdb8fa8b05d4e77a49222798c08e66318)**

**由于懒，在这篇文章中一律将`节点`看作`结点`**

B+Tree之中最为重要的就是节点的结构：

* 叶子节点与非叶子节点之间差别很大：叶子节点存储值，所有一般是一个顺序数组(这是源自B<sup>link</sup> Tree, 我的B+Tree定义来自于CMU15-445)；非叶子节点存储指针，兄弟之间顺序排列，但是没有相互关系
* 在B+树中的节点通常被表示为一组有序的元素和子指针。如果此B+树的阶数是m，则**除了根之外的每个节点都包含最少 m/2 个元素最多m-1个元素**，对于任意的结点有最多 m 个子指针。对于所有内部节点，子指针的数目总是比元素的数目多一个。所有叶子都在相同的高度上，叶结点本身按关键字大小从小到大链接。

```c++
class BPTree;
class Node {
 public:
   Node();

 private:
  // leaf节点和internal节点
  bool IS_LEAF;
  // 在这里key|value一样，但是需要记住internal节点没有value
  // key是一个有序的数组 
  int *key, size;
  // Node指针数组
  Node **ptr;
  friend class BPTree;
};
class BPTree {
 public:
   BPTree();
   void search(int);
   void insert(int);
   void remove(int);
   void display(Node *);
   Node *getRoot();

 private:
  Node *root;
  void insertInternal(int, Node *, Node *);
  void removeInternal(int, Node *, Node *);
  Node *findParent(Node *, Node *);
};
```



#### B<sup>+</sup> Tree的查询

##### 自然语言描述：

查找值为V的节点

从根节点出发，比较V与节点索引值大小。

当V的值在两个索引之间或者说在两端时向下寻找，重复该过程。

找到节点，或者没有找到。

##### 伪代码：

![Selection](https://raw.githubusercontent.com/huang-feiyu/huang-feiyu.github.io/master/img/Selection_B_Plus_Tree.png)



##### C++代码实现：

```c++
void BPTree::search(int x) {
  // 从根节点出发
  if (root == NULL) {
    cout << "Tree is empty\n";
  } else {
    Node *cursor = root;
    // 当结点指针指向的节点是internal时，不断缩小范围
    while (cursor->IS_LEAF == false) {
      for (int i = 0; i < cursor->size; i++) {
        if (x < cursor->key[i]) {
          cursor = cursor->ptr[i];
          break;
        }
        if (i == cursor->size - 1) {
          cursor = cursor->ptr[i + 1];
          break;
        }
      }
    }
    // 可以使用二分查找优化
    for (int i = 0; i < cursor->size; i++) {
      if (cursor->key[i] == x) {
        cout << "Found\n";
        return;
      }
    }
    cout << "Not found\n";
  }
}
```



#### B<sup>+</sup> Tree的插入

##### 自然语言描述：

查找要插入其中的节点的位置，插入值到节点中去

如果每一个节点都是的元素数目都满足**除了根之外的每个节点都包含最少 m/2 个元素最多m-1个元素**，则插入完成

如果插入的那个节点有过多元素，则**取中间值**，中间值成为了父节点，把它分裂为两个节点，保证了每个都有最小数目的元素。沿着父节点向上继续这个处理直到到达根节点，如果根节点被分裂，则创建一个新根节点。插入完成

##### CMU15445 Description:

* Find correct leaf node L
* Put data entry into L in sorted order
  * If L has enough space, done
  * Otherwise, split L keys into L and a new node L2
    * Redistribute entries evenly, copy up middle key.
    * Insert index entry pointing to L2 into parent of L

**To split inner node, redistribute entries evenly, but push up middle key.**

##### 伪代码：

![Insertion](https://raw.githubusercontent.com/huang-feiyu/huang-feiyu.github.io/master/img/Insertion_B_Plus_Tree.png)



##### C++代码实现：

```c++
void BPTree::insert(int x) {
  if (root == NULL) {
    // 初始化根节点
    root = new Node;
    root->key[0] = x;
    root->IS_LEAF = true;
    root->size = 1;
  } else {
    Node *cursor = root;
    Node *parent;
    // 查找节点位置
    while (cursor->IS_LEAF == false) {
      parent = cursor;
      for (int i = 0; i < cursor->size; i++) {
        if (x < cursor->key[i]) {
          cursor = cursor->ptr[i];
          break;
        }
        if (i == cursor->size - 1) {
          cursor = cursor->ptr[i + 1];
          break;
        }
      }
    }
    // 如果存在空闲空间，直接插入
    if (cursor->size < MAX) {
      int i = 0;
      while (x > cursor->key[i] && i < cursor->size)
        i++;
      for (int j = cursor->size; j > i; j--) {
        cursor->key[j] = cursor->key[j - 1];
      }
      cursor->key[i] = x;
      cursor->size++;
      cursor->ptr[cursor->size] = cursor->ptr[cursor->size - 1];
      cursor->ptr[cursor->size - 1] = NULL;
    } else {
      // 分裂结点，注意有序性
      Node *newLeaf = new Node;
      int virtualNode[MAX + 1];
      for (int i = 0; i < MAX; i++) {
        virtualNode[i] = cursor->key[i];
      }
      int i = 0, j;
      while (x > virtualNode[i] && i < MAX)
        i++;
      for (int j = MAX + 1; j > i; j--) {
        virtualNode[j] = virtualNode[j - 1];
      }
      virtualNode[i] = x;
      newLeaf->IS_LEAF = true;
      cursor->size = (MAX + 1) / 2;
      newLeaf->size = MAX + 1 - (MAX + 1) / 2;
      cursor->ptr[cursor->size] = newLeaf;
      newLeaf->ptr[newLeaf->size] = cursor->ptr[MAX];
      cursor->ptr[MAX] = NULL;
      for (i = 0; i < cursor->size; i++) {
        cursor->key[i] = virtualNode[i];
      }
      for (i = 0, j = cursor->size; i < newLeaf->size; i++, j++) {
        newLeaf->key[i] = virtualNode[j];
      }
      if (cursor == root) {
        // 根节点被分裂，创建一个新的根节点
        Node *newRoot = new Node;
        newRoot->key[0] = newLeaf->key[0];
        newRoot->ptr[0] = cursor;
        newRoot->ptr[1] = newLeaf;
        newRoot->IS_LEAF = false;
        newRoot->size = 1;
        root = newRoot;
      } else {
        // 判断上一个结点是否因为本次插入发生split
        insertInternal(newLeaf->key[0], parent, newLeaf);
      }
    }
  }
}

void BPTree::insertInternal(int x, Node *cursor, Node *child) {
  if (cursor->size < MAX) {
    // 有空闲空间，插入完成
    int i = 0;
    while (x > cursor->key[i] && i < cursor->size)
      i++;
    for (int j = cursor->size; j > i; j--) {
      cursor->key[j] = cursor->key[j - 1];
    }
    for (int j = cursor->size + 1; j > i + 1; j--) {
      cursor->ptr[j] = cursor->ptr[j - 1];
    }
    cursor->key[i] = x;
    cursor->size++;
    cursor->ptr[i + 1] = child;
  } else {
    // 分裂结点
    Node *newInternal = new Node;
    int virtualKey[MAX + 1];
    Node *virtualPtr[MAX + 2];
    for (int i = 0; i < MAX; i++) {
      virtualKey[i] = cursor->key[i];
    }
    for (int i = 0; i < MAX + 1; i++) {
      virtualPtr[i] = cursor->ptr[i];
    }
    int i = 0, j;
    while (x > virtualKey[i] && i < MAX)
      i++;
    for (int j = MAX + 1; j > i; j--) {
      virtualKey[j] = virtualKey[j - 1];
    }
    virtualKey[i] = x;
    for (int j = MAX + 2; j > i + 1; j--) {
      virtualPtr[j] = virtualPtr[j - 1];
    }
    virtualPtr[i + 1] = child;
    newInternal->IS_LEAF = false;
    cursor->size = (MAX + 1) / 2;
    newInternal->size = MAX - (MAX + 1) / 2;
    for (i = 0, j = cursor->size + 1; i < newInternal->size; i++, j++) {
      newInternal->key[i] = virtualKey[j];
    }
    for (i = 0, j = cursor->size + 1; i < newInternal->size + 1; i++, j++) {
      newInternal->ptr[i] = virtualPtr[j];
    }
    if (cursor == root) {
      // 根节点被分裂，创建一个新的根节点
      Node *newRoot = new Node;
      newRoot->key[0] = cursor->key[cursor->size];
      newRoot->ptr[0] = cursor;
      newRoot->ptr[1] = newInternal;
      newRoot->IS_LEAF = false;
      newRoot->size = 1;
      root = newRoot;
    } else {
      // 向上递归至所有节点满足黑体字条件
      insertInternal(cursor->key[cursor->size],
          findParent(root, cursor), newInternal);
    }
  }
}
```



#### B<sup>+</sup> Tree的删除

##### 自然语言描述：

查找要删除的值，从包含它的节点L中删除这个值。

如果每一个节点都是的元素数目都满足**除了根之外的每个节点都包含最少 m/2 个元素最多m-1个元素**，则删除完成

存在节点不满足上述论述的两种情况：

1. L的兄弟节点Sibling，可以把一个Sibling的子节点转移到节点L，而把L的元素数目增加一使得它满足 **包含至少 m/2 个元素**，同时Sibling的元素数目也满足 **包含至少 m/2 个元素**。那么Sibling减少一个元素分给L，改变两者共同的父节点的值(即两个兄弟节点之间的最近中间值)。
2. L的兄弟节点的元素不足的情况下, **元素数目也正好处于 m/2 情况之下**。把两个兄弟节点合并到一个单一的节点中，沿父节点向上递归判断是否满足 **包含至少 m/2 个元素** 。持续这个处理直到当前节点是均满足 **包含至少 m/2 个元素** 或者 到达根节点，如果根节点的所有孩子合并成了一个节点 **NEW**，那么删除原来的根节点，让 **NEW**成为新的根节点。

##### CMU15445 Description:

* Start at root, find leaf L where entry belongs
* Remove the entry
  * If L is at least half-full, done
  * If L has only M/2-1 entries
    * Try to re-distribute, borrowing from sibling(adjacent node with same
      parent as L)
    * If re-distribution fails, merge L and sibling

**If merge occurred, must delete entry (pointing to L or sibling) from parent of L**

##### 伪代码：

![Deletion](https://raw.githubusercontent.com/huang-feiyu/huang-feiyu.github.io/master/img/Deletion_B_Plus_Tree.png)



##### C++代码实现：

```c++
void BPTree::remove(int x) {
  if (root == NULL) {
    // 空树
    cout << "Tree empty\n";
  } else {
    // 查找结点位置
    Node *cursor = root;
    Node *parent;
    int leftSibling, rightSibling;
    while (cursor->IS_LEAF == false) {
      for (int i = 0; i < cursor->size; i++) {
        parent = cursor;
        leftSibling = i - 1;
        rightSibling = i + 1;
        if (x < cursor->key[i]) {
          cursor = cursor->ptr[i];
          break;
        }
        if (i == cursor->size - 1) {
          leftSibling = i;
          rightSibling = i + 2;
          cursor = cursor->ptr[i + 1];
          break;
        }
      }
    }
    bool found = false;
    int pos;
    for (pos = 0; pos < cursor->size; pos++) {
      if (cursor->key[pos] == x) {
        found = true;
        break;
      }
    }
    if (!found) {
      cout << "Not found\n";
      return;
    }
    // 找到了节点位置
    // 移动节点，其实有个方法可以高效移动连续内存
    for (int i = pos; i < cursor->size; i++) {
      cursor->key[i] = cursor->key[i + 1];
    }
    cursor->size--;
    if (cursor == root) {
      // 节点正好是根节点，此时树可能会被干掉
      for (int i = 0; i < MAX + 1; i++) {
        cursor->ptr[i] = NULL;
      }
      if (cursor->size == 0) {
        cout << "Tree died\n";
        delete[] cursor->key;
        delete[] cursor->ptr;
        delete cursor;
        root = NULL;
      }
      return;
    }
    cursor->ptr[cursor->size] = cursor->ptr[cursor->size + 1];
    cursor->ptr[cursor->size + 1] = NULL;
    // 满足黑体字条件直接返回
    if (cursor->size >= (MAX + 1) / 2) {
      return;
    }
    if (leftSibling >= 0) {
      // 先看左兄弟有没有多余的节点分给该节点
      // 重新分配 Redistribute
      Node *leftNode = parent->ptr[leftSibling];
      if (leftNode->size >= (MAX + 1) / 2 + 1) {
        for (int i = cursor->size; i > 0; i--) {
          cursor->key[i] = cursor->key[i - 1];
        }
        cursor->size++;
        cursor->ptr[cursor->size] = cursor->ptr[cursor->size - 1];
        cursor->ptr[cursor->size - 1] = NULL;
        cursor->key[0] = leftNode->key[leftNode->size - 1];
        leftNode->size--;
        leftNode->ptr[leftNode->size] = cursor;
        leftNode->ptr[leftNode->size + 1] = NULL;
        parent->key[leftSibling] = cursor->key[0];
        return;
      }
    }
    if (rightSibling <= parent->size) {
      // 再看右兄弟有没有多余的节点分给该节点(先左还是先右没有影响，都认为是对的)
      // 重新分配 Redistribute
      Node *rightNode = parent->ptr[rightSibling];
      if (rightNode->size >= (MAX + 1) / 2 + 1) {
        cursor->size++;
        cursor->ptr[cursor->size] = cursor->ptr[cursor->size - 1];
        cursor->ptr[cursor->size - 1] = NULL;
        cursor->key[cursor->size - 1] = rightNode->key[0];
        rightNode->size--;
        rightNode->ptr[rightNode->size] = rightNode->ptr[rightNode->size + 1];
        rightNode->ptr[rightNode->size + 1] = NULL;
        for (int i = 0; i < rightNode->size; i++) {
          rightNode->key[i] = rightNode->key[i + 1];
        }
        parent->key[rightSibling - 1] = rightNode->key[0];
        return;
      }
    }
    // 如果都没有多余的位置，合并两个节点，此时需要向上递归看看parent节点是否满足黑体字
    // 合并 Coalesce
    if (leftSibling >= 0) {
      Node *leftNode = parent->ptr[leftSibling];
      for (int i = leftNode->size, j = 0; j < cursor->size; i++, j++) {
        leftNode->key[i] = cursor->key[j];
      }
      leftNode->ptr[leftNode->size] = NULL;
      leftNode->size += cursor->size;
      leftNode->ptr[leftNode->size] = cursor->ptr[cursor->size];
      removeInternal(parent->key[leftSibling], parent, cursor);
      delete[] cursor->key;
      delete[] cursor->ptr;
      delete cursor;
    } else if (rightSibling <= parent->size) {
      Node *rightNode = parent->ptr[rightSibling];
      for (int i = cursor->size, j = 0; j < rightNode->size; i++, j++) {
        cursor->key[i] = rightNode->key[j];
      }
      cursor->ptr[cursor->size] = NULL;
      cursor->size += rightNode->size;
      cursor->ptr[cursor->size] = rightNode->ptr[rightNode->size];
      cout << "Merging two leaf nodes\n";
      removeInternal(parent->key[rightSibling - 1], parent, rightNode);
      delete[] rightNode->key;
      delete[] rightNode->ptr;
      delete rightNode;
    }
  }
}
void BPTree::removeInternal(int x, Node *cursor, Node *child) {
  if (cursor == root) {
    // 如果是根节点的话
    if (cursor->size == 1) {
      // 判断哪一个孩子成为根节点，因为合并成了一个节点，这样根节点就只有一个孩子
      // 干掉原来的根节点，然后用孩子结点代替根节点
      if (cursor->ptr[1] == child) {
        delete[] child->key;
        delete[] child->ptr;
        delete child;
        root = cursor->ptr[0];
        delete[] cursor->key;
        delete[] cursor->ptr;
        delete cursor;
        cout << "Changed root node\n";
        return;
      } else if (cursor->ptr[0] == child) {
        delete[] child->key;
        delete[] child->ptr;
        delete child;
        root = cursor->ptr[1];
        delete[] cursor->key;
        delete[] cursor->ptr;
        delete cursor;
        cout << "Changed root node\n";
        return;
      }
    }
  }
  // 后续和之前删除Leaf一样，就是多了个递归的过程
  int pos;
  for (pos = 0; pos < cursor->size; pos++) {
    if (cursor->key[pos] == x) {
      break;
    }
  }
  for (int i = pos; i < cursor->size; i++) {
    cursor->key[i] = cursor->key[i + 1];
  }
  for (pos = 0; pos < cursor->size + 1; pos++) {
    if (cursor->ptr[pos] == child) {
      break;
    }
  }
  for (int i = pos; i < cursor->size + 1; i++) {
    cursor->ptr[i] = cursor->ptr[i + 1];
  }
  cursor->size--;
  if (cursor->size >= (MAX + 1) / 2 - 1) {
    return;
  }
  if (cursor == root)
    return;
  Node *parent = findParent(root, cursor);
  int leftSibling = 0;
  int rightSibling = 0;
  for (pos = 0; pos < parent->size + 1; pos++) {
    if (parent->ptr[pos] == cursor) {
      leftSibling = pos - 1;
      rightSibling = pos + 1;
      break;
    }
  }
  if (leftSibling >= 0) {
    Node *leftNode = parent->ptr[leftSibling];
    if (leftNode->size >= (MAX + 1) / 2) {
      for (int i = cursor->size; i > 0; i--) {
        cursor->key[i] = cursor->key[i - 1];
      }
      cursor->key[0] = parent->key[leftSibling];
      parent->key[leftSibling] = leftNode->key[leftNode->size - 1];
      for (int i = cursor->size + 1; i > 0; i--) {
        cursor->ptr[i] = cursor->ptr[i - 1];
      }
      cursor->ptr[0] = leftNode->ptr[leftNode->size];
      cursor->size++;
      leftNode->size--;
      return;
    }
  }
  if (rightSibling <= parent->size) {
    Node *rightNode = parent->ptr[rightSibling];
    if (rightNode->size >= (MAX + 1) / 2) {
      cursor->key[cursor->size] = parent->key[pos];
      parent->key[pos] = rightNode->key[0];
      for (int i = 0; i < rightNode->size - 1; i++) {
        rightNode->key[i] = rightNode->key[i + 1];
      }
      cursor->ptr[cursor->size + 1] = rightNode->ptr[0];
      for (int i = 0; i < rightNode->size; ++i) {
        rightNode->ptr[i] = rightNode->ptr[i + 1];
      }
      cursor->size++;
      rightNode->size--;
      return;
    }
  }
  if (leftSibling >= 0) {
    Node *leftNode = parent->ptr[leftSibling];
    leftNode->key[leftNode->size] = parent->key[leftSibling];
    for (int i = leftNode->size + 1, j = 0; j < cursor->size; j++) {
      leftNode->key[i] = cursor->key[j];
    }
    for (int i = leftNode->size + 1, j = 0; j < cursor->size + 1; j++) {
      leftNode->ptr[i] = cursor->ptr[j];
      cursor->ptr[j] = NULL;
    }
    leftNode->size += cursor->size + 1;
    cursor->size = 0;
    removeInternal(parent->key[leftSibling], parent, cursor);
  } else if (rightSibling <= parent->size) {
    Node *rightNode = parent->ptr[rightSibling];
    cursor->key[cursor->size] = parent->key[rightSibling - 1];
    for (int i = cursor->size + 1, j = 0; j < rightNode->size; j++) {
      cursor->key[i] = rightNode->key[j];
    }
    for (int i = cursor->size + 1, j = 0; j < rightNode->size + 1; j++) {
      cursor->ptr[i] = rightNode->ptr[j];
      rightNode->ptr[j] = NULL;
    }
    cursor->size += rightNode->size + 1;
    rightNode->size = 0;
    removeInternal(parent->key[rightSibling - 1], parent, rightNode);
  }
}
```



#### B+ Tree的并发编程

这里描述经典蟹行协议(crabbing protocol)，还有B-link tree locking protocol。

这两种协议都可以在[CMU Course 9](https://15445.courses.cs.cmu.edu/fall2020/slides/09-indexconcurrency.pdf)中找到，我就不在这里实现了。(被GradeScope摧残的太惨了)

##### 自然语言描述:

* 先移动一边的腿，然后移动另一边的腿，如此交替进行.
* 在向下的搜索操作中和由于分裂、合并或者重新分布传播向上的操作之间有可能出现死锁
  系统能够很容易处理这种死锁，它先让搜索操作释放锁，然后从树根重启它

* 查找一个key时，蟹行协议首先用共享模式锁住根节点。沿树向下遍历，它在子节点上获得
  一个共享锁，以便向更远处遍历，在子节点上获得锁之后，它释放父节点上的锁，直至叶子节点
* 插入或者删除一个key时
  * 采取与查找相同的协议直至希望的叶子节点，到此为止，只获得和释放共享锁
  * 用排他锁锁住叶子节点，并且插入或者删除key
  * 如果需要分裂节点或者将它与兄弟节点合并，或者在兄弟节点之间重新分配key，蟹行协议
    使用排他锁锁住父节点，在完成这些操作之后，释放该节点和兄弟节点上的锁
        如果父节点需要分裂、合并或者重新分布码值，该协议保留父节点上的锁，以同样的方式
    分裂、合并或者重新分布码值，并且传播更远。否则，该协议释放父结点上的锁。

##### CMU15445 Description:

###### 我的笔记:

* Protocol to allow multiple threads to access/modify B+Tree at the same time
* Basic Idea:
  * Get Latch for parent
  * Get Latch for child
  * Release latch for parent if safe
* A safe node is one that will not split or merge when updated
  * Not full
  * More than half-full

* Find: Start at root and go down; repeatedly,
  * Acquire R latch on child
  * Then unlatch parent
* Insert/Delete: Start at root and go down, obtaining W latches as needed.
      Once child is latched, check if it is safe:
  * If child is safe, release all latches on ancestors

###### [官方笔记:](https://15445.courses.cs.cmu.edu/fall2020/notes/09-indexconcurrency.pdf)

* Basic Latch Crabbing Protocol: 

* Search: Start at the root and go down, repeatedly acquire latch on the child and then unlatch parent. 

* Insert/Delete: Start at the root and go down, obtaining X latches as needed. Once the child is latched, check if it is safe. If the child is safe, release latches on all its ancestors. 

* Note that read latches do not need to worry about the “safe” condition. The notion of “safe” also depends on whether the operation is an insertion or a deletion. A full node is “safe” for deletion since a merge will not be needed but is not “safe” for an insertion since we may need to split the node. The order in which latches are released is not important from a correctness perspective. However, from a performance point of view, it is better to release the latches that are higher up in the tree since they block access to a larger portion of leaf nodes.



#### 参考文献：

* [The Ubiquitous B-tree](http://carlosproal.com/ir/papers/p121-comer.pdf)
* Database System Concepts Sixth Edition, Chapter 11.3, 11.4, 15.10
* [CMU15445 Fall2019](https://www.youtube.com/watch?v=JHZFc4hMGhk&list=PLSE8ODhjZXjbohkNBWQs_otTrBTrjyohi&index=7&ab_channel=CMUDatabaseGroupCMUDatabaseGroup), Course 7，8，9

#### 完整的代码：

声明: 该代码大部分是从[programiz](https://www.programiz.com/dsa/b-plus-tree)拷贝下来的，用作演示。

##### 至于我为什么不写：

* 第一是因为有点懒；
* 第二就是CMU15-445要求代码不得公开；
* 第三就是我的代码写得有点烂， 只拿到了一半的分数
  * 包含经典蟹行协议实现，错误是因为对Latch的不够良好的实现导致time out，同时还有5%的内存泄露. Debug快一个星期时间，很累的
  * 但是我的代码还是比这个代码写得好一些。这个代码仅仅只有演示作用，如果你把这个代码用上了你的database，后果**不堪设想**.



**最好是理解之后才开始写代码，最开始可以照着敲一遍，但是一定要自己实现一遍。**可以在网络上多找几篇文章，同时辅以**[Track Visualization](https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html)**理解 。

[完整代码地址](https://github.com/huang-feiyu/huang-feiyu.github.io/blob/master/Resources/B_Plus_Tree.cpp)：遵循Google Style, 没有进行很多测试，应该没有错.

