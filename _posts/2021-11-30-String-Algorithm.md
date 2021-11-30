---
layout:     post
title:      String-Algorithm
subtitle:   几个简单的字符串算法
date:       2021-11-30
author:     Huang
header-img: img/post_bg_tunnel_man_light_entrance.jpg
catalog:    true
tags:
   - Programming
   - Algorithms
---

> 我们希望利用已有的信息，更加快速地完成精准字符串匹配。

### Rabin Karp
通过使用hash函数以达到快速判断的目的。

###### 伪代码描述

```pseudocode
Algorithm: Rabin-Karp(T, P)
Input: T, text; P, pattern
Output: index or -1
PROCEDURE BEGIN
M ← P.len()
N ← T.len()
q ← A prime larger than M
c ← 1  // c=pow(d, M-1) mod prime
FOR i ← 1 TO M-1
  c ← (c * d) mod q  // d is the size of alphabet
fp ← 0
ft ← 0
FOR i ← 0 TO M-1
  fp ← (fp * d + P[i]) mod q
  ft ← (ft * d + T[i]) mod q
FOR i ← 0 TO N-M
  IF fp = ft THEN
    IF P[0..M-1] == T[i..i+M-1] THEN
      RETURN i
  ft ← ((ft-T[i]*c)*d + T[i+M]) mod q
RETURN -1
PROCEDURE END
```

###### Python代码描述
```python
# rabin karp: finger print algorithm

def rabin_karp_search(text, pattern, prime):
    # parameter: alphabet size

    d = 256
    M = len(pattern)
    N = len(text)
    c = 1
    # c = pow(d, M - 1) mod prime

    for i in range(M - 1):
        c = (c * d) % prime
    # finger print: pattern

    fp = 0
    # finger print: txt

    ft = 0
    for i in range(M):
        fp = (d * fp + ord(pattern[i])) % prime
        ft = (d * ft + ord(text[i])) % prime
    # slide

    for i in range(N - M + 1):  # i: index of text

        if fp == ft:
            j = 0  # index of pattern

            for j in range(M):
                if pattern[j] != text[i + j]:
                    break
            j += 1
            if j == M:
                print("RK, Got it:", i)
                return i
        # update ft

        if i < N - M:
            ft = ((ft - ord(text[i]) * c) * d + ord(text[i + M])) % prime
            if ft < 0:
                ft = ft + prime
    print("RK, Do not find")
    return -1
```

### KMP
利用前缀表充分利用已经探测到的信息。

###### 伪代码描述

```pseudocode
Algorithm: KMP(T, P)
Input: T, text; P, pattern
Output: index or -1

FUNCTION Compute-Prefix-Table(P)
  π[0] ← 0
  // 从前向后扫描
  FOR i ← 1 TO M-2
    j ← π[i - 1]
    // 前缀表上一位数据，获取匹配的前后缀位置
    WHILE j > 0 AND P[j] ≠ P[i] 
      j ← π[j - 1]
    // 判断j位数据是否可以提高前后缀匹配位数
    IF P[j] = P[i] THEN
      j ← j + 1
    π[i] ← j

PROCEDURE BEGIN
M ← P.len()
N ← T.len()
π ← Compute-Prefix-Table(P)
q ← 0  // number of characters matched
FOR i ← 0 TO N - 1
  // 找到回溯位置
  WHILE q > 0 AND P[q] ≠ T[i]
    q ← π[q]
  IF P[q] = T[i] THEN
    q ← q+1
  IF q = M:
    RETURN i - M + 1
RETURN -1
PROCEDURE END
```

###### Python代码描述

```python
# KMP: partial search

class KMP:
    # compute partial table

    def partial(self, pattern):
        # Pi[0] = 0

        pi = [0]
        for i in range(1, len(pattern)):
            j = pi[i - 1]
            while j > 0 and pattern[j] != pattern[i]:
                j = pi[j - 1]
            pi.append(j + 1 if pattern[j] == pattern[i] else j)
        return pi

    def kmp_search(self, text, pattern):
        M = len(pattern)
        N = len(text)
        pi = self.partial(pattern)
        q = 0  # number of characters matched

        for i in range(N):
            while q > 0 and pattern[q] != text[i]:
                q = pi[q]
            if pattern[q] == text[i]:
                q += 1
            if q == M:
                print("KMP, Got it:", i - M + 1)
                return i - M + 1
        print("KMP, Do not find")
        return -1
```

### BMH
反向搜索，以求得跳过尽可能多的字符数。

$$
\text{shift[w]} = \begin{cases}
M - 1 - \max \{i < M - 1 | p[i] = w \}, & w \in \text{Pattern}[0..M-2] \\
M, & \text{otherwise}
\end{cases}
$$

###### 伪代码描述

```pseudocode
Algorithm: BMH(T, P)
Input: T, text; P, pattern
Output: index or -1
PROCEDURE BEGIN
M ← P.len()
N ← T.len()
// Compute Shift table
FOR i ← 0 TO d - 1  // d is the size of alphabet
  shift[alphabet[i]] ← M
FOR i ← 0 TO M - 2
  shift[pattern[i]] ← M - 1 - i
k ← M - 1
WHILE k < N  // 从后向前搜索
  j ← M - 1  // pattern pointer
  i ← k  // text pointer
  WHILE j ≥ 0 AND T[i] = P[j]
    j ← j - 1
    i ← i - 1
  IF j = -1 THEN
    RETURN i + 1
  k ← k + shift[text[k]]  // 按照text的指针位将pattern前移shift[k]位
RETURN -1
PROCEDURE END
```

###### Python代码实现

```python
# BMH: skip as much as possible

def BMH_search(text, pattern):
    N = len(text)
    M = len(pattern)
    if M > N:
        print("BMH, Do not find")
        return -1
    shift = []
    for k in range(256):
        shift.append(M)
    for k in range(M - 1):
        shift[ord(pattern[k])] = M - k - 1
    shift = tuple(shift)
    k = M - 1
    while k < N:
        j = M - 1
        i = k
        while j >= 0 and text[i] == pattern[j]:
            j -= 1
            i -= 1
        if j == -1:
            print("BMH, Got it:", i + 1)
            return i + 1
        k += shift[ord(text[k])]
    print("BMH, Do not find")
    return -1
```

