---
layout:     post
title:      Greedy-Strategy
subtitle:   贪心策略的简单笔记
date:       2021-11-27
author:     Huang
header-img: img/post_bg_tunnel_man_light_entrance.jpg
catalog:    true
tags:
   - Programming
   - Algorithms
---

> 贪心算法希望通过局部最优达到全局最优。

### 算法原理

* 算法思想
  * 每一步都有选择
  * 作出在当时看起来最好的选择
* 贪心算法**使用条件**(需要证明)
  * 贪心选择性：一个问题的全局最优解能够通过局部优化选择得到
  * 优化子结构：一个问题的优化解包含子问题的优化解

### 任务安排问题

不断选择最早结束的事件，直到无法选择。

###### 算法正确性

* 优化子结构：如果原问题$S_{ij}$包含活动$a_k$，那么子问题$S_{ik}, S_{kj}$也包含$a_k$.

  $\Rightarrow c[i,j]=\begin{cases}0,& S_{ij}=\varnothing \\ \max\\{c[i,k]+c[k,j]+1\\},&S_{ij}\neq \varnothing 且 i<k<j \end{cases}$

* 贪心选择性：最早结束的任务$a_m$必然存在于$S_{ij}$的一个优化解中

  1. $S_{ij}$中的活动只有$a_m$

     如果不选择$a_m$，那么就$c[i,j]=0 \Rightarrow a_m$在$S_{ij}$的一个优化解中中

  2. $S_{ij}$中的活动不仅$a_m$

     假设一个得到最多任务的选择

     1. 如果该选择包含$a_m$，那么$a_m$在优化解中
     2. 如果该选择不包含$a_m$，那么减去该选择中最早结束的任务，我们能够将$a_m$加入到该选择中去构成一个新的选择，从而得到一个优化解 $\Rightarrow a_m$在优化解中

###### 伪代码描述

```pseudocode
// 使用递归方法
Selector(s, f, k, n)
m ← k + 1
WHILE m≤n AND s[m]<f[k]
	m ← m + 1
IF m≤n THEN
	RETURN {a[m] ∪ Selector(s, f, m, n)}
ELSE
	RETURN NIL
```

### 哈夫曼编码

不断取频率最小的两个结点生成一棵子树，直到取得所有结点获得一棵树。

###### 算法正确性

* 优化子结构：$T$是$C$生成的优化哈夫曼树，$x,y$是以$z$为父节点的子节点，那么$T'=T-\{x,y\}$是$C-\{x,y\}+\{z\}$生成的优化哈夫曼树

  假设$T'$不是优化前缀树，那么存在一棵优化前缀树$T''$。在$T''$中加入$\{x,y\}$，得到一棵树$T'''$，而这棵树的代价$B(T''')=B(T'')+f(x)+f(y) < B(T')+f(x)+f(y)=B(T)$，与前提$T$为优化前缀树( $B(T)\le B(T^{'..'})$ )相矛盾。

* 贪心选择性：取$C$的两个频率最小的结点$x,y$，存在一颗优化树：其中$x,y$拥有相同的编码长度且仅有最后一位不同

  取一颗优化树$T$

  1. 该优化树恰好满足定理条件
  2. 该优化树不满足定理条件，那么有深度最深的两个相邻的叶子节点$u,v$。交换$x和u$，得到$T'$，再交换$y和v$，得到$T''$
     $$
     \begin{split}
     B(T)-B(T')&=f(x)d_T(x) + f(u)d_T(u) - f(x)d_T(u)-f(u)d_T(x)\\
     & = [f(u)-f(x)]\cdot [d_T(u)-d_T(x)]
     \end{split}
     $$
	
	其中$f(u)-f(x)\ge 0 , d_T(u) -d_T(x) \ge 0$，则$B(T)\ge B(T')\ge B(T'')$，又有$B(T'') \le B(T)$，故$B(T)=B(T'')$.
	
	$T''$即为满足定理条件的优化树

###### 伪代码描述

```pseudocode
Huffman(C,F)
n ← |C|
// 建立最小堆Q
Q ← C
let T be new Tree
FOR i ← 1 TO n-1 DO
	z ← T.Allocate-Node()
	x ← z.left ← Extract-MIN(Q)
	y ← z.right ← Extract-MIN(Q)
	f(z) ← f(x) + f(y)
	Insert(Q, z)
RETURN T
```

###### Python代码描述

```python
# 哈夫曼编码问题

# 制备每个字符的概率表

def findTheCharFrequency(text):
    result = dict()
    with open(text, 'r') as f:
        for line in f.readlines():
            line = line.lower()
            for i in line:
                # 判断字符是否为英文字母
                
                if i.isalpha():
                    if i in result:
                        result[i] += 1
                    else:
                        result.update({i: 1})
    return result


# 创建节点类

class Node:
    def __init__(self, name=None, value=None):
        # 结点代表的字母
        
        self.name = name
        # 结点频率
        
        self.value = value
        self.lchild = None
        self.rchild = None


# 哈夫曼树类

class HuffmanTree:
    # 创建Huffman树
    
    def __init__(self, dic_k_v):
        self.leaf_arr = [Node(k, v) for k, v in dic_k_v.items()]
        # 不断向上建树
        
        while len(self.leaf_arr) != 1:
            # 按照每个结点的频率排序
            
            self.leaf_arr.sort(key=lambda node: node.value, reverse=True)
            # 构建此刻最小的两个结点
            
            n = Node(None, self.leaf_arr[-1].value + self.leaf_arr[-2].value)
            n.lchild = self.leaf_arr.pop(-1)
            n.rchild = self.leaf_arr.pop(-1)
            self.leaf_arr.append(n)
        self.root = self.leaf_arr[0]
        self.Buffer = list(range(10))

    def pre_code(self, tree, length):
        node = tree
        if not node:
            return None
        # 叶子节点打印前缀码
        
        elif node.name:
            print(node.name + ", Huffman-code: ", end="")
            for i in range(length):
                print(self.Buffer[i], end="")
            print("")
            return
        self.Buffer[length] = 0
        self.pre_code(node.lchild, length + 1)
        self.Buffer[length] = 1
        self.pre_code(node.rchild, length + 1)

    def huf_generate(self):
        self.pre_code(self.root, 0)
```

### 最小生成树

* Kruskal：不断选择权值最小且不使图中出现环的边，直到边的个数为$V-1$
  * 全局最小的边
* Prim：从任意一个根节点开始生长，不断加入与已有顶点相邻的其他顶点的最短的一条边，加入到集合中，直到边的个数为$V-1$
  * 连接已有顶点和其他顶点的全局最小的边

###### 算法正确性

$G\cdot uv$为收缩$uv$后的图

* 优化子结构：$T$是$G$的最小生成树，那么$T\cdot uv$是$G\cdot uv$的最小生成树

  $T\cdot uv$包含$G\cdot uv$的所有节点且连通，边的个数为顶点个数减一 $\Rightarrow$ $T\cdot uv$是树

  如果$T\cdot uv$不是最小生成树，那么存在一颗$G\cdot uv$的最小生成树$T'$。将$T'$中的结点$uv$扩张，得到$T''$: $W(T'') = W(T') + W_{uv} < W(T\cdot uv)+W_{uv}=W(T)$，这与$T$为优化树相矛盾

* 贪心选择性：权值最小的边$uv$必然存在于一颗最小生成树中

  给定一颗最小生成树$T$

  1. $T$中存在$uv$，$uv$在最小生成树中
  2. $T$中不存在$uv$，加入$uv$，同时删去因加入$uv$产生环中除$uv$外权值最小的边$xy$。因为$W_{uv}\le W_{xy}$且新生成的图是树$T'$，那么$T'$是最小生成树，故$uv$在$T'$中

###### 伪代码描述

```pseudocode
/* Kruskal算法 */
MST-KRUSKAL(G,w)
A ← ∅ /*一个不相交集合维护几个互不相交的元素集合，每个集合代表一棵树*/
FOREACH vertex v∈G.V
	MAKE-SET(v)
sort the edges of G.E into nondecreasing order by weight w
FOREACH edge(u,v)∈G.E, taken IN nondecreasing order by weight
	IF FIND-SET(u)≠FIND-SET(v) THEN /*判断u,v是否属于同一棵树*/
		 A ← A∪{(u,v)}
		UNION(u,v)
RETURN A

/*Prim算法*/
MST-PRIM(G,w,r)
FOREACH u∈G.V
	u:key←∞
	u:π←NIL
r:key←0
Q←G.V
WHILE Q≠∅
	u←EXTRACT-MIN(Q)
	FOREACH v∈G.Adj[u]
	IF v∈Q AND w(u,v)<v.key THEN
		v.π ← u
		v.key ← w(u,v)
RETURN A←{(v,π[v])|v∈V[G]-r}
```

###### Python代码描述

```python
# 最小生成树:Prim算法实现

class MST:
    # 随机生成有权矩阵
    
    def generate_map(self, ver_num=6):
        graph = []
        for i in range(ver_num):
            raw = []
            for j in range(ver_num):
                if i == j:
                    raw.append(np.inf)
                else:
                    raw.append(random.randint(1, 31))
            graph.append(raw)
        print(graph)
        return graph

    # 相邻的最短边
    
    def min_edge(self, select, candidate, graph):
        temp_min = np.inf
        v, u = 0, 0
        for i in select:
            for j in candidate:
                if temp_min > graph[i][j]:
                    temp_min = graph[i][j]
                    v, u = i, j
        # 返回最短边的两个顶点
        
        return u, v

    # Prim算法实现
    
    def prim(self, graph):
        V = len(graph)
        # 集合A
        
        select = [0]
        # 集合G-A
        
        candidate = list(range(1, V))
        # 选择的边
        
        edge = []
        for i in range(1, V):
            v, u = self.min_edge(select, candidate, graph)
            edge.append((u, v))
            select.append(u)
            candidate.remove(v)
        print(edge)
        return edge
```



