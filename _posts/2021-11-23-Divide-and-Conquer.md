---
layout:     post
title:      Divide-and-Conquer
subtitle:   分治方法笔记 
date:       2021-11-23
author:     Huang
header-img: img/post_bg_tunnel_man_light_entrance.jpg
catalog:    true
tags:
   - Programming
   - Algorithms
---

> 简单笔记，仅仅作为复习使用。
记得第一次见到分治算法的时候，我就想到了凯撒大帝的“I came, I see, I conquer.”

### 算法原理
* 算法步骤
  * Divide: 整个问题划分为多个子问题
  * Conquer: 求解各个子问题
  * Combine/Merge: 合并子问题的解，形成原始问题的解
* 分析过程
  * 建立**递归方程**
  * 求解递归方程

### 快速排序
选择一个基准元素，将数组以其为基准分为两半

伪代码描述:

```pseudocode
Algorithm: QuickSort
Input: A[1..n]
Output: Sorted A[1..n]

QuickSort(A)
  PartitionSort(A, 1, n)

PartitionSort(A, i, j)
  temp ← rand(i, j)
  x ← A[temp]
  k ← Partition(A, i, j, x)
  PartitionSort(A, i, k)
  PartitionSort(A, k+1, j)

Partition(A, i, j, x)
  low ← i 
  high ← j
  WHILE (low < high)
    Swap(A[low], A[high])
    WHILE (A[low] < x)
      low ← low + 1
    WHILE (A[high] >= x)
      high ← high - 1
  RETURN high

// Another one for Partition (without preset x)
Partition(A, p, r)
  x ← A[r]
  i ← p - 1
  FOR j ← p TO r - 1
    DO IF A[j] ≤ x
      THEN i ← i + 1
           Swap(A[i], A[j])
  Swap(A[i+1], A[r])
  RETURN i+1
```

Python代码描述:

```python
def quicksort(array):
    if len(array) <= 1:
        return array
    pivot = array[0]
    left = []
    for i in range(1, len(array)):
        if array[i] < pivot:
            left.append(array[i])
    right = []
    for i in range(1, len(array)):
        if array[i] >= pivot:
            right.append(array[i])
    return quicksort(left) + [pivot] + quicksort(right)
```

### 二分搜索
已排序的数组，根据中间值进行划分，每次迭代舍弃其中一半。

伪代码描述:
```pseudocode
Algorithm: BinarySearch
Input: A[1..n], k 
Output: Index of k OR -1
BinarySearch(A, k)
  low ← 1
  high ← n
  WHILE (low ≤ high) DO
    mid ← low + (high - low) / 2
    IF (A[mid] = k)
      RETURN mid
    ELSE IF (A[mid] < k)
      low ← mid + 1
    ELSE
      high ← mid - 1
  RETURN -1
```

Python代码描述:
```python
def binary_search(arr, k):
  low = 0
  high = len(arr) - 1
  while low <= high:
    mid = low + (high - low) // 2
    if arr[mid] == k:
      return mid
    elif arr[mid] < k:
      low = mid + 1
    else:
      high = mid - 1
  return -1
```
### 两个数组求中位数
假设A和B是长度为n排好序的数组，且数组中每个数都是不同的。
设计一个算法，在O(logn)时间里找出这2n个数的中位数，其中2n个数的中位数为从小到大排序的第n个数。

伪代码描述:
```pseudocode
FIND_TWO_ARR_MID(A, B):
lefBegin←0, lefEnd←n-1
rigBegin←0, rigEnd←n-1
while(lefBegin < lefEnd && rigBegin < rigEnd) {
	if(lefBegin == lefEnd-1 && rigBegin == rigEnd-1)
		break;
	lefMid ← (lefBegin + lefEnd)/2
	rigMid ← (rigBegin + rigEnd)/2
	if(A[lefMid] == B[rigMid])
		return A[lefMid]
	elseif(A[lefMid] < B[rigMid])
		lefBegin←lefMid, rigEnd←rigMid;
	elseif(A[lefMid] > B[rigMid])
  		lefEnd←lefMid, rigBegin←rigMid;
	if(lefBegin == lefEnd && rigBegin == rigEnd)
  		return min(A[lefBegin], B[rigBegin])
	elseif(lefBegin == lefEnd-1 && rigBegin == rigEnd-1) {
  		if(A[lefBegin] < B[rigBegin])
    		return min(A[lefEnd],B[rigBegin]);
   		else
    		return min(A[lefBegin],B[rigEnd]);
    }
}
```

