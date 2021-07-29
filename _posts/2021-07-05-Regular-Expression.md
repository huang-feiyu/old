---
layout:     post
title:      Regular-Expression
subtitle:   正则表达式
date:       2021-07-05
author:     Huang
header-img: img/post_bg_regular_expression.png
catalog: true
tags:
   - Programming
---


### 正则表达式

(下面有些图片加载不出来，因为我把我之前的仓库干掉了。有些格式乱了，不推荐用这篇文章学习，下面的仓库就够了)

Thanks to [cdoco](https://github.com/cdoco)，这是我学习正则表达式所使用的两个仓库：

* [learn-regex-zh](https://github.com/cdoco/learn-regex-zh)
* [common-regex](https://github.com/cdoco/common-regex)

### 前言

为什么学习正则表达式(regular expression)：**第一要义就是检索特定模式的数据**，而且还可以在学习生活中帮助你做到迅速快捷地修改文件，十分方便。

~~在这篇文章中，我不会告诉你怎么用正则表达式，毕竟这只是我的笔记罢了——如果你学习的话，用上面的两个仓库学习就足够了。~~ 突然发现基本涵盖了上面两个仓库的内容，有些更加清晰。

### 1. 基本匹配

(区分大小写)根据模式串进行匹配，可能会利用KMP算法等等模式匹配算法，不再多言。

### 2. 元字符

正则表达式的基本组成元素，通过特定方式去解析元字符：

>  下面的元字符全部采用`这种方式`来展现，使用[这种方式](https://huang-feiyu.github.io)来表示根据正则表达式匹配的字符串——当然下面的是没有链接的。(使用引用的方式来表达字符串匹配，=> 表示被匹配的字符串，“RegExp”表示正则表达式)

![元字符](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_1.png?raw=true)

### 2.1 英文句号

`.`可以匹配除换行符之外的任何一个字符。

>  “.ar”  =>  The [car]() [par]()ked in the [gar]()age

### 2.2 字符集/字符类

`[]`用于指定字符集，使用字符集内的连字符来指定字符范围，中括号内字符范围不重要。

> "[Tt]he" =>  [The]() car parked in [the]() garage.



在下面的字符往往只是字符，而不能使用嵌套的正则表达式——要不然不就乱套了。
> "ar[.]"  =>  A garage is a good place to park a c[ar.]()

###### 2.2.1 否定字符集

插入字符`^`表示一个字符串的开始，但是在方括号内表示否定——取消匹配该字符串

> "[ ^c]ar" => The car [par]()ked in the [gar]()age.

其中，car没有匹配成功，因为c在否定字符集中被干掉了。(正则表达式内空格需要干掉)

### 2.3 重复
`+`, `*`, `?`

###### 2.3.1 星号

`*`表示匹配上一个匹配规则零次或者多次。"a\*"表示小写字母a可以重复零次或者多次。如果出现在字符集之后，表示整个字符集的重复，"[a-z\*]"表示一行中包含任意数量的小写字母。

> "[a-z]\*" =>  [The car parked in the garage]() #21. 



`*` 可以与 `.`一起使用，用来匹配任意字符串`.*`。`*`可以和空格转义符`\s`一起使用，匹配一串空白符号。

> "\s\*cat\s\*" =>  The fat[ cat ]()sat on the[ cat].

markdown原编码更清晰。

###### 2.3.2 加号

`+`表示匹配上一个字符一次或者多次。

> "c.+t" => The fat [cat sat on the mat]().

上面的表达从 c 到 t，之间可以出现任意字符串。

###### 2.3.3 问号

`?`表示前一个字符是可选的，匹配前一个字符零次或者一次。

> "[T]he" => [The]() car is parked in the garage.



在下面的正则表达式中，也就是匹配 The 或者 he.
> "[T]?he" => [The]() car is parked in t[he]() garage.

### 2.4 花括号

`{}` 用来指定字符或者一组字符可以重复的次数。

> "[0-9]{2,3}" => The number was 9.[999]()7 but we rounded it off to [10].0.
> 上面的正则表达式用来匹配三位或者两位连续的数字。

> "[0-9]{2,}" => The number was 9.[9997]() but we rounded it off to [10].0.
> 上面的正则表达式用来匹配两位及以上的连续的数字。

> "[0-9]{2,3}" => The number was 9.[99]()[97]() but we rounded it off to [10].0.
> 上面的正则表达式用来匹配两位连续的数字, 看markdown编码更清楚。

### 2.5 字符组

字符组是一组写在`()`的子模式。如果把`{some_number}`放在一个字符之后，会重复前一个字符。如果把`{some_number}`放在字符组之后会重复整个字符组。

> "(c|g|p|v)ar" => The [car]() is [par]()ked in the [gar]()age.
> 上面的正则表达式匹配car, gar, par, var.

### 2.6  分支结构

`|`被用来定义分支结构，不同于字符集的是，分支结构可以在表达式级别使用。

![2.6](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_2_6.png?raw=true)

上面的正则表达式匹配 The, the, car.

### 2.7 转义特殊字符

`\`用来转义下一个字符，`{ } [ ] / \ + * . $ ^ | ?`均可以使用转义字符进行匹配。

![2.7](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_2_7.png?raw=true)

上面的正则表达式匹配 fat, cat, mat, 以及各个三个单词后跟一句点的字符串，使用markdown编码模式更清晰。

### 2.8 定位符

定位符可以检查匹配符号是否为起始符号或者结尾符号

###### 2.8.1 插入符号

`^`用于检查匹配字符是否为字符串的第一个字符。

> "^a" => [a]()bc
> "^b" => abc               (nothing happened)

![2.8](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_2_8.png?raw=true)

上面的例子表明字符串通过特殊符号结尾，而不是空格。

###### 2.8.2 美元符号

`$`用于检查匹配字符是否为字符串的最后一个字符，和插入符号差不多。

> "(at\.)" => The fat c[at.]() s[at.]() on the m[at.]()
> "(at\.)" => The fat cat sat on the m[at.]()

### 3. 简写字符集

常用字符集，被简化成这样了

| 简写 | 描述                                     |
| ---- | ---------------------------------------- |
| .    | 匹配除换行符以外的任意字符               |
| \w   | 匹配所有字母和数字的字符：`[a-zA-Z0-9_]` |
| \W   | 匹配非字母和数字的字符：`[^\w]`          |
| \d   | 匹配数字：`[0-9]`                        |
| \D   | 匹配非数字：`[^\d]`                      |
| \s   | 匹配空格符：`[\t\n\f\r\p{Z}]`            |
| \S   | 匹配非空格符：`[^\s]`                    |

### 4. 断言

特殊类型的***非捕获组***——用于匹配模式，但不包括在匹配列表中。

| 符号 | 描述         |
| ---- | ------------ |
| ?=   | 正向先行断言 |
| ?!   | 负向先行断言 |
| ?<=  | 正向后行断言 |
| ?<!  | 负向后行断言 |

###### 4.1 正向先行断言

`(?=...)`认为第一部分的表达式的后面必须是先行断言表达式。返回的匹配结果仅包含与第一部分表达式匹配的文本。

![4.1](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_4_1.png?raw=true)

上面的东西(如果没有断言)实际上匹配到了 [The fat]() ，但是使用了正向先行断言，于是后面的 [ fat]() 就被干掉了。

###### 4.2 负向先行断言

`(?!...)`表示匹配到的表达式的后面**不跟随**某些内容，返回到第一部分的表达式。

![4.2](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_4_2.png?raw=true)

由于不包含 [ fat]() ，于是匹配到了 [the mat]() ，后面的 [ mat]() 被干掉了。

###### 4.3 正向后行断言

`(?<=...)`获取跟随在特定模式之后的所有匹配内容。

![4.3](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_4_3.png?raw=true)

上面的正则表达式表示获取所有**紧紧**跟在 [The ]() 或者 [the ]() 后面的 [fat]() 和 [mat]() 。

###### 4.4 负向后行断言

`(?<!...)`获取不跟随在特定模式之后的所有匹配内容。

![4.4](https://github.com/huang-feiyu/RegEx-Learning/blob/main/image/img_4_4.png?raw=true)

获取所有不跟在 [The ]() 和 [the]() 后面的 [cat]() 。

### 5. 标记

也叫做修饰符，它会修改正则表达式的输出。

| 标记 | 描述                                       |
| ---- | ------------------------------------------ |
| i    | 不区分大小写：将匹配设置为不区分大小写。   |
| g    | 全局搜索：搜索整个输入字符串中的所有匹配。 |
| m    | 多行匹配：会匹配输入字符串每一行。         |

###### 5.1 不区分大小写

`/some_words/i`修饰符用于执行不区分大小写匹配。

> “The”  => [The]() fat cat sat on the mat.

> “/The/gi”  =>  [The]() fat cat sat on [the]() mat.

上面的正则表达式不仅使用了`i`还是用了`g`，表示在整个输入字符串中搜索匹配不区分大小写的 [The]() .

###### 5.2 全局搜索

`/some_words/g`修饰符执行全局匹配，会查找所有匹配，而不会在查找到第一个匹配之后就停止。

> “.(at)”  =>  The [fat]() cat sat on the mat.

> “/.(at)/g”  =>  The [fat]() [cat]() [sat]() on the [mat]().

全局索引，显而易见。

###### 5.3 多行匹配

`/some_words/m`用于执行多行匹配。

> “/.at(.)?$/”  =>  The fat
>
> 						   cat sat
> 	
> 						  on the [mat.]()

输入字符串的结尾为最后一个词，根据最后一个词定位。



> “/.at(.)?$/gm”  =>  The [fat]()
>
> 						       cat [sat]()
> 	
> 						       on the [mat.]()

根据每一行的最后一个词定位。

### 6. 常用的正则表达式

- **正整数**：`^\d+$`
- **负整数**：`^-\d+$`
- **电话号码**：`^+?[\d\s]{3,}$`
- **电话代码**：`^+?[\d\s]+(?[\d\s]{10,}$`
- **整数**：`^-?\d+$`
- **用户名**：`^[\w\d_.]{4,16}$`
- **字母数字字符**：`^[a-zA-Z0-9]*$`
- **带空格的字母数字字符**：`^[a-zA-Z0-9 ]*$`
- **密码**：`^(?=^.{6,}$)((?=.*[A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z]))^.*$`
- **电子邮件**：`^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})*$`
- **IPv4 地址**：`^((?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))*$`
- **小写字母**：`^([a-z])*$`
- **大写字母**：`^([A-Z])*$`
- **网址**：`^(((http|https|ftp):\/\/)?([[a-zA-Z0-9]\-\.])+(\.)([[a-zA-Z0-9]]){2,4}([[a-zA-Z0-9]\/+=%&_\.~?\-]*))*$`
- **VISA 信用卡号码**：`^(4[0-9]{12}(?:[0-9]{3})?)*$`
- **日期（MM/DD/YYYY）**：`^(0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)?[0-9]{2}$`
- **日期（YYYY/MM/DD）**：`^(19|20)?[0-9]{2}[- /.](0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])$`
- **万事达信用卡号码**：`^(5[1-5][0-9]{14})*$`

### 7. 可以使用正则表达式的地方——Almost EVERYWHERE

* 神之编辑器vim:  [网址](https://jianshu.com/p/3abd6fbc3322)
* Linux查找命令:  [网址](https://blog.csdn.net/xy010902100449/article/details/51426354)
* VS Code, Sublime Text: `Crtl+H`
* All kinds of IDEs
* etc.

在我的仓库中更清晰，还可以在[这个网站](https://github.com/ziishaned/learn-regex)中找到练习题，网上的资源很多。

