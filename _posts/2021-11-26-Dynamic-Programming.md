---
layout:     post
title:      Dynamic-Programming
subtitle:   动态规划 
date:       2021-11-26
author:     Huang
header-img: img/post_bg_tunnel_man_light_entrance.jpg
catalog:    true
tags:
   - Programming
   - Algorithms
---

> 动态规划是一种编程思想，本质上是通过空间换得时间的优化算法。

### 算法原理
动态规划背后的基本思想非常简单。大致上，若要解一个给定问题，我们需要解其不同部分（即子问题），再根据子问题的解以得出原问题的解。

通常许多子问题非常相似，为此动态规划法试图仅仅解决每个子问题一次，从而减少计算量：
一旦某个给定子问题的解已经算出，则将其记忆化存储(使用`dp`数组存储起来)，以便下次需要同一个子问题解之时直接查表。

* 使用条件
  * 问题具有优化子结构: 原问题的优化解包含子问题的优化解
  * 重叠子结构: 子问题的优化解可以多次复用
* 设计步骤
  * 确定状态
    * 分析子问题结构
  * 建立状态转移方程
  * 初始情况与边界条件
  * 自底向上求解

### 矩阵链乘法
$$
m[i,j]=
\begin{cases}
0 & ,i=j\\
\min\limits_{i \le k< j}\{m[i,k]+m[k+1,j]+p_{i-1} p_k p_j\} & ,i < j
\end{cases}
$$

伪代码描述：
```pseudocode
MATRIX-CHAIN-ORDER(p)
n ← len(p) - 1
// m is cost array(dp), s is location array
let m[1..n][1..n], s[1..n-1][2..n] be new tables
FOR i ← 1 TO n DO
  m[i, i] ← 0
FOR l ← 2 TO n DO
  FOR i ← 1 TO n - l + 1 DO
    j ← i + l - 1
    m[i][j] ← ∞ 
    FOR k ← i TO j DO
      temp ← m[i][k] + m[k+1][j] + p[i-1] * p[k] * p[j]
      IF temp < m[i][j] THEN 
        m[i][j] ← temp
        s[i][j] ← k
RETURN m, s 

// 打印矩阵乘法顺序
PRINT-CHAIN-ORDER(s, i, j)
IF i=j THEN
  print "A" + i
ELSE
  print "("
  PRINT-CHAIN-ORDER(s, i, s[i,j])
  PRINT-CHAIN-ORDER(s, s[i,j] + 1, j)
  print ")"
```

Python代码描述
```python
# 矩阵链乘法动态规划实现

class MatrixMul:
    def matrix_chain_order(self, p):
        # p是矩阵大小序列

        n = len(p) - 1
        m = [[0 for i in range(n)] for j in range(n)]
        s = [[0 for i in range(n)] for j in range(n)]
        # 对角线

        for l in range(2, n):
            # 行

            for i in range(1, n - l + 1):
                j = i + l - 1
                m[i][j] = float('inf')
                for k in range(i, j):
                    q = m[i][k] + m[k + 1][j] + p[i - 1] * p[k] * p[j]
                    if q < m[i][j]:
                        m[i][j] = q
                        s[i][j] = k
        return m, s

    def print_optimal_parens(self, s, i, j):
        if i == j:
            print('A' + str(i + 1), end='')
        else:
            print('(', end='')
            self.print_optimal_parens(s, i, s[i][j])
            self.print_optimal_parens(s, s[i][j] + 1, j)
            print(')', end='')
```

### 最长公共子序列问题
$C[i,j]=
\begin{cases}
0&, i=0 \ \text{or}  j=0\\
C[i-1,j-1]+1&, i,j>0 \ text{and}\ x_i=y_i\\
\max(C[i,j-1],C[i-1,j])&,i,j>0 \ text{and} \ x_i\neq y_j
\end{cases}$

伪代码描述: 
```pseudocode
LCS(X,Y)
m ← len(X)
n ← len(Y)
// C is cost array(dp), B is arrow array
let C[0..n][0..n], B[1..n][1..n] be new tables
FOR i ← 1 TO m DO
  C[i][0] ← 0
FOR j ← 1 TO m DO
  C[1][0] ← 0
FOR i ← 1 TO m DO
  FOR j ← 1 TO n DO
    IF X[i] = Y[j] THEN
      C[i][j] ← C[i-1][j-1] + 1
      B[i][j] ← "↖"
    ELSE IF C[i-1][j] > C[i][j-1] THEN
      C[i][j] ← C[i-1][j]
      B[i][j] ← "↑"
    ELSE
      C[i][j] ← C[i][j-1]
      B[i][j] ← "←"
RETURN C AND B

// 打印公共子序列
PRINT-LCS(B, X, i, j)
IF B[i][j] = "↖" THEN
  print X[i]
ELSE IF B[i][j] = "↑" THEN
  PRINT-LCS(B, X, i-1, j)
ELSE
  PRINT-LCS(B, X, i, j-1)
```

Python代码描述: 
```python
class LCS:
    def LCS_len(self, x, y):
        m = len(x) + 1
        n = len(y) + 1
        # 长度

        c = [[0 for i in range(n)] for j in range(m)]
        # 箭头

        b = [[0 for i in range(n)] for j in range(m)]
        for i in range(1, m):
            for j in range(1, n):
                if x[i - 1] == y[j - 1]:
                    c[i][j] = c[i - 1][j - 1] + 1
                    b[i][j] = '↖'
                elif c[i - 1][j] >= c[i][j - 1]:
                    c[i][j] = c[i - 1][j]
                    b[i][j] = '↑'
                else:
                    c[i][j] = c[i][j - 1]
                    b[i][j] = '←'
        return c, b

    def print_LCS(self, b, x, i, j):
        if i == 0 or j == 0:
            return None
        if b[i][j] == '↖':
            self.print_LCS(b, x, i - 1, j - 1)
            print(x[i - 1], end='')
        elif b[i][j] == '↑':
            self.print_LCS(b, x, i - 1, j)
        else:
            self.print_LCS(b, x, i, j - 1)
```

### 0-1背包问题
* 状态转移方程: $$
m(i,j)=
\begin{cases}
m(i+1,j) & 0 \le j < w_i\\
\max\{m(i+1,j),m(i+1,j-w_i)+v_i\} & j \ge w_i
\end{cases}
$$

* 边界条件: $$
m(n,j)=
\begin{cases}
0, & 0 \le j < w_n\\
v_n, & j \ge w_n
\end{cases}
$$

伪代码描述:
```pseudocode
// W: Weight array; V: Value array; C: Capacity
ZERO-ONE-BAG(W, V, C)
n ← len(W)
FOR j ← 0 TO min(C, W[n]-1) DO
  m[n][j] ← 0
FOR j ← W[n] TO C DO
  m[n][j] ← V[n]
FOR i ← n - 1 TO 2 DO
  FOR j ← 0 TO min(C, W[i]-1) DO
    m[i][j] ← m[i+1][j]
  FOR j ← W[i] TO C DO
    m[i][j] ← min(m[i+1][j], m[i+1][j-W[i]] + V[i])
IF C > W[1] THEN
  m[1][C] ← min(m[2][C-W[1]] + V[1] + m[2][C])
ELSE
  m[1][C] ← m[2][C]

RETURN m
```

Python代码描述:
```python
class Knapsack:
    def zero_one(self, c, w, v):
        # (0,0)不作为物品

        n = len(w) - 1
        # m[0..n][0..c] => 其中m[0][0..c]与m[0..n][0]弃用

        m = [[0 for _ in range(c + 1)] for _ in range(n + 1)]

        # 背包容量大于等于最后一个物品: j > w[n]

        for j in range(w[n], c + 1):
            m[n][j] = v[n]

        for i in range(n - 1, 1, -1):
            for j in range(1, c + 1):
                # 背包容量不足

                if j < w[i]:
                    m[i][j] = m[i + 1][j]
                # 背包容量足以容纳下一个物品

                else:
                    m[i][j] = max(m[i + 1][j], m[i + 1][j - w[i]] + v[i])
        if c < w[0]:
            m[1][c] = m[2][c]
        else:
            m[1][c] = max(m[2][c], m[2][c - w[1]] + v[1])
        return m[1][c]
```

### 最优二分搜索树
* 状态转移方程
  * $$
    E(i,j)=
    \begin{cases}
    q_{i-1}&,j=i-1\\
    \min_{i\le r \le j}\{E(i,r-1)+E(r+1,j)+W(i,j)\}&,j\ge i
    \end{cases}
    $$
  
  * $$
    W(i,j)=
    \begin{cases}
    q_{i-1}&, j = i-1\\
    W(i,j-1)+p_j+q_j&, j\ge i
    \end{cases}
    $$

伪代码描述:
```pseudocode
// p: 内结点概率; q: 叶子节点概率; n: 内结点个数
OPTIMAL-BST(p, q, n)
let E[1..n+1][0..n], W[1..n+1][0..n], Root[1..n][1..n] be new tables
FOR i ← 1 TO n+1 DO
  E[i][i-1] ← q[i-1]
  W[i][i-1] ← q[i-1]
FOR l ← 1 TO n DO
  FOR i ← 1 TO n-l+1 DO
    j ← i + l - 1
    E[i][j] ← ∞
    W[i][j] ← W[i][j-1] + q[i-1] + p[i-1]
    FOR r ← i TO j DO
      temp ← E[i][r-1] + E[r+1][j] + W[i][j]
      IF temp < E[i][j] THEN
        E[i][j] ← temp
        Root[i][j] ← r
RETURN E AND Root
```

Python代码描述:
```python
# 最优二叉搜索树

class OptimalBST:
    # p: 内结点概率; q: 叶节点概率; n: 内结点个数
    
    def best_BST(self, p, q, n):
        e = [[0 for _ in range(n + 1)] for _ in range(n + 2)]
        w = [[0 for _ in range(n + 1)] for _ in range(n + 2)]
        root = [[0 for _ in range(n + 1)] for _ in range(n + 1)]
        # 初始化边界情况

        for i in range(1, n + 2):
            e[i][i - 1] = q[i - 1]
            w[i][i - 1] = q[i - 1]
        for l in range(1, n + 1):
        #长度

            for i in range(1, n - l + 2):
                # 对角线

                j = i + l - 1
                e[i][j] = float('inf')
                # 加入树后增加的代价

                w[i][j] = w[i][j - 1] + p[j] + q[j]
                # 每一个结点都充当子树根节点

                for r in range(i, j + 1):
                    temp = e[i][r - 1] + e[r + 1][j] + w[i][j]
                    if temp < e[i][j]:
                        # 选择最小的代价

                        e[i][j] = temp
                        root[i][j] = r
        return e, root
```

