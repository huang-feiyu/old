---
layout:     post
title:      Summer-vacation-Journal-16
subtitle:   2021暑假手记-16
date:       2021-07-12
author:     Huang
header-img: img/post_bg_castle_dark_moon.jpg
catalog: true
tags:
   - Journal
---

### 前言

2021夏季的暑假手记——虽然不是手写的，这里会大概记录我暑假的每一天(如果我记了的话)。

今天写出来的的内容是：将需求抽象化为Relational Database Schema以及《城堡》书评。

其他有：将个人阅读的书目弄到数据库中去——熟练使用SQL&寻找简单方法(本次使用SQLite DBMS)。

### 需求抽象化为Schema

######  建立几个表项

在这里我选择参考[MusicBrainz](https://musicbrainz.org/doc/MusicBrainz_Database)，将Book作为主表，其他的表项通过Ref Key与主表产生联系。表项后面的数字表示实现了那些需求。

* Book: 1, 2, 10
* MyInfo: 3, 4, 5, 6
* Type: 7
* Release: 8
* Author: 9
* Language
* Press
* Country
* Gender

如果根据我之前的经验的话，仅仅需要创建两个表项就能够涵盖之前的所有内容。

###### 抽象为Schema

```pseudocode
// Database Schema: mybook.db
// Copyright (c) huang-feiyu@github
// MIT LICSENCE

// Creating Tables
// LEVEL 1
Table book as B {
  id INTEGER [pk, increment]
  name TEXT [not null]
  description TEXT [default: null]
  page_number INTEGER [not null]
  word_number INTEGER [not null]
  my_info INTEGER [not null]
  language INTEGER [not null]
  type INTEGER [not null]
  release INTEGER [not null]
  author INTEGER [not null]
}

// LEVEL 2
Table my_info {
  id INTEGER [pk, increment]
  date_year INTEGER [not null]
  date_month INTEGER [not null]
  date_day INTEGER [notnull]
  read_times INTEGER [not null]
  book_link TEXT [default: null]
  score INTEGER [not null]
}
Ref: B.my_info > my_info.id

Table type {
  id INTEGER [pk] 
  name TEXT [not null]
  is_fiction INTEGER [not null]
  is_classic INTEGER [not null]
  is_philosophy INTEGER [not null]
}
Ref: B.type > type.id

Table language {
  id INTEGER [pk, increment]
  name TEXT [not null]
}
Ref: B.language > language.id

Table release {
  id INTEGER [pk]
  date_year INTEGER [not null]
  date_month INTEGER [not null]
  ean_number INTEGER [not null]
  area_number INTEGER [not null]
  press_number INTEGER [not null]
  release_number INTEGER [not null]
  code_number INTEGER [not null]
}
Ref: B.release > release.id

Table author {
  id INTEGER [pk, increment]
  name TEXT [not null]
  translator TEXT [default: null]
  country INTEGER [not null]
  begin_date_year INTEGER [not null]
  begin_date_month INTEGER [not null]
  begin_date_day INTEGER [not null]
  end_date_year INTEGER [not null]
  end_date_month INTEGER [not null]
  end_date_day INTEGER [not null]
  gender INTEGER [not null]
}
Ref: B.author > author.id

// LEVEL 3
Table country {
  id INTEGER [pk]
  name TEXT [not null]
}
Ref: author.country > country.id

Table press {
  id INTEGER [pk]
  name TEXT [not null]
}
Ref: release.press_number > press.id

Table gender {
  id INTEGER [pk]
  name TEXT [not null]
}
Ref: author.gender > gender.id
```

![Schema](https://github.com/huang-feiyu/huang-feiyu.github.io/blob/master/img/post_bg_mybook_schema.png?raw=true)

```mysql
CREATE TABLE `book` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT null,
  `page_number` int NOT NULL,
  `word_number` int NOT NULL,
  `my_info` int NOT NULL,
  `language` int NOT NULL,
  `type` int NOT NULL,
  `release` int NOT NULL,
  `author` int NOT NULL
);

CREATE TABLE `my_info` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `date_year` int NOT NULL,
  `date_month` int NOT NULL,
  `date_day` int NOT NULL,
  `read_times` int NOT NULL,
  `book_link` varchar(255) DEFAULT null,
  `score` int NOT NULL
);

CREATE TABLE `type` (
  `id` int PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `is_fiction` int NOT NULL,
  `is_classic` int NOT NULL,
  `is_philosophy` int NOT NULL
);

CREATE TABLE `language` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL
);

CREATE TABLE `release` (
  `id` int PRIMARY KEY,
  `date_year` int NOT NULL,
  `date_month` int NOT NULL,
  `ean_number` int NOT NULL,
  `area_number` int NOT NULL,
  `press_number` int NOT NULL,
  `release_number` int NOT NULL,
  `code_number` int NOT NULL
);

CREATE TABLE `author` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `translator` varchar(255) DEFAULT null,
  `country` int NOT NULL,
  `begin_date_year` int NOT NULL,
  `begin_date_month` int NOT NULL,
  `begin_date_day` int NOT NULL,
  `end_date_year` int NOT NULL,
  `end_date_month` int NOT NULL,
  `end_date_day` int NOT NULL,
  `gender` int NOT NULL
);

CREATE TABLE `country` (
  `id` int PRIMARY KEY,
  `name` varchar(255) NOT NULL
);

CREATE TABLE `press` (
  `id` int PRIMARY KEY,
  `name` varchar(255) NOT NULL
);

CREATE TABLE `gender` (
  `id` int PRIMARY KEY,
  `name` varchar(255) NOT NULL
);

ALTER TABLE `book` ADD FOREIGN KEY (`my_info`) REFERENCES `my_info` (`id`);

ALTER TABLE `book` ADD FOREIGN KEY (`type`) REFERENCES `type` (`id`);

ALTER TABLE `book` ADD FOREIGN KEY (`language`) REFERENCES `language` (`id`);

ALTER TABLE `book` ADD FOREIGN KEY (`release`) REFERENCES `release` (`id`);

ALTER TABLE `book` ADD FOREIGN KEY (`author`) REFERENCES `author` (`id`);

ALTER TABLE `author` ADD FOREIGN KEY (`country`) REFERENCES `country` (`id`);

ALTER TABLE `release` ADD FOREIGN KEY (`press_number`) REFERENCES `press` (`id`);

ALTER TABLE `author` ADD FOREIGN KEY (`gender`) REFERENCES `gender` (`id`);
```

###### 补充

**Type**

一般来说，一个id能够确定一种书籍类型，需要将所有已经创建过的书籍类型组合在一起，便于查找。在这里，我选择使用《如何阅读一本书》中的分类方式。

* 文学(id 0~19)
  * 想象文学(id 0~9)
    * 小说
      * 长篇小说  id=1
      * 中篇小说  id=2
      * 短篇小说集 id=3
    * 诗歌  id=4
    * 散文集 id=5
    * 戏剧  id=6
    * etc.
  * 纪实文学(id 10~19在这里我选择将历史纳入到其中，毕竟历史作者文字功底非常强)
    * 历史 id=10
    * 日记/手记 id=11
    * 传记 id=12
    * 报告文学 id=13
    * etc.
* 哲学(id 20~29)
  * 科普类哲学 id=20
  * 存在主义 id=21
  * 女性主义 id=22
  * 古典哲学 id=23
  * etc
* 科学(包括数学, id 30~39)
  * 科普类 id=30
  * 心理学 id=31
  * etc.
* 社会科学(id 40~49)
  * 科普类 id=40
  * 社会学 id=41
  * 人类学 id=42
  * etc.
* 其他(id 50~59), 这里包括我所没有列举出来的书籍类型
  * 绘本 id=50
  * 工具书 id=51
  * etc.

**Language**

* 中文 id=0
* 英文 id=1
* etc.

**Country**

* 中国 id=0
* 俄罗斯 id=1
* 法国 id=2
* 德国 id=3
* 日本 id=4
* 意大利 id=5
* 美国 id=6
* 捷克 id=7
* etc

**Gender**

* 男异性恋 id=0
* 女异性恋 id=1
* 男同性恋 id=2
* etc.

### 《城堡》

[《城堡》](https://book.douban.com/subject/1081422/)，这本书我读的是人民文学出版社的《卡夫卡小说全集》的第二册，本册还有《变形记》以及《地洞》——都是卡夫卡极富盛名的小说篇章。而对于卡夫卡，我还阅读过《卡夫卡小说全集》的第三册——中短篇小说集。

我首先读的是《变形记》以及《地洞》，大概用了一下午的时间，第三册是我在前几天用了几个晚上读完的。在读完这几个篇目之后，我并没有真切地感受到卡夫卡的魅力，我甚至在读完中短篇小说集之后给出了一个评价——我想读不懂卡夫卡是件好事，至少说明了你并非你想的那样痛苦，“尽管许多读不懂，我还是能够体会到卡夫卡风格的怪诞，同时又为他感到绝望——是怎么样的心境才能够写出这么多痛苦、孤独的小说。”

在《城堡》之前，我读懂的大概只有《变形记》以及几篇短篇小说——其中我最喜欢的是《饥饿艺术家》。我想《城堡》是每一个人都能读懂的，无论从哪个方面，因为像这样的小说几乎涵盖了所有人性探索小说的母题。

###### Para 1

首先给出评价，这部小说是一部无与伦比的杰作。

本书译者高年生写的前言中已经指出了：

* “城堡是神和神的恩典的象征。K寻求进入城堡之路，以求得灵魂的拯救，但他的努力是徒劳的，因为神的恩典是不可能强行取得的，最后K离开人世时才得到补偿。因此，《城堡》是一则宗教寓言；
* 城堡是权力象征、国家统治机器的缩影。这个高高在上的衙门近在咫尺，但对广大人民来说却可望而不可即。《城堡》是为官僚制度描绘的滑稽讽刺画，是极权主义的预示；
* 卡夫卡生活的时代，欧洲盛行排犹主义。《城堡》是犹太人无家可归的写照；
* K的奋斗是为了寻求真理。人们所追求的真理，不管是自由、公正还是法律，都是存在的，但这个荒诞的世界给人们设置了种种障碍，无论你怎样努力，总是追求不到，最后只能以失败告终；
* K是被社会排斥在外的“局外人”，不仅得不到上面的许可，也得不到下面的认可。他自始至终是一个“陌生人”。K的这种处境是现代人命运的象征。人不能不生活在社会之中，但社会不允许、也不承认他是社会的真正成员；
* 《城堡》反映了卡夫卡和他父亲之间极其紧张的关系。城堡是父亲形象的象征。K想进入城堡，而城堡将其拒之门外，这反映了父子对立和冲突……”

当然他最后给了一个结论：”当然，这些评说只是人们所作的诸多评说的几种可能性。**未来世代还将不断地评说下去。**每一种评说，即便正确，也可能只涉及到其中某一侧面，因为一部优秀的作品往往具有多义性和复杂性，很难加以单一的概括。**卡夫卡作品的本质在于提出问题而不在于获得答案。**“

###### Para 2

就像高年生所说的那样”未来世代还将不断地评说下去“，我发现我所读到的和前面所提到的几种解读全都不一样。

我更倾向于将这本书看作是卡夫卡的心理自传。当然，K毫无疑问是Kafka本人了。其他的几个人物，我总是会在阅读过程中不断地对他们的印象改变。两个助手，我将其看作是心理的杂念。而几位女性，我将其看作是卡夫卡的救赎——有些是自己的对抗、有些是外界的人们对于卡夫卡心理的帮助。规则，大多是卡夫卡所处时代的外界的道德规范，也有他自己的偏见。城堡中的大人，我认为是卡夫卡所遇见的像他父亲那样的能够显著影响卡夫卡的权威。当然，对于最为重要的城堡我也有一定的看法——我认为这可能是卡夫卡所追求的解脱之道，一条真正的救赎之路。

仅仅是我现在的想法，一家之言，而且只读了一遍，看看就好。

###### Para 3

近来的一个小念头。

最近在读的书，也许还包括以前的书，常常给我一个“我们每个人都有罪”的印象。而写这本书，要么是说明救赎之路无法找到，要么是说明死亡是唯一的救赎之道。

以《城堡》为例，我所理解的城堡是救赎——救赎Kafka的灵魂，每个人心中都会有一个城堡，那是我们可望而不可即的。当我们坚毅地去寻求救赎的时候，无论什么时候，都会有杂念去阻碍我们接触城堡。我推测城堡之后的情节是：K在不断地辗转中**意外**——换言之，充满荒诞气息地死亡，发现自己的灵魂进入了城堡——而城堡中的大人都是像他一样的灵魂，K也成为了大人。K在城堡中探索救赎之路的时候，发现了另一座城堡……

我感觉自己的续写挺有意思的，等过几年我可以写出来，毕竟现在文字功底太差，也没有时间。

我的观点是：我们从来就没有罪，每个人声称自己有罪都是为了对抗虚无——寻找一个心灵上的工作去对抗虚无感。至于原因，我还没想到——最简单的原因当然是“主观性就是真理”，有时候这个靠不住的。

###### Para 4

卡夫卡的文字是极具特色的，在这部作品中体现得尤为明显。

如此荒诞的故事在卡夫卡冷淡的极其客观的笔触之下，似乎显得容易接受了一点——就像梦境中那种非常不符合现实常理的东西，我们却能够欣然接受。我们常常会用卡夫卡式去形容这样的写作风格，用最为平淡的文字去揭示人性的奥秘。无论所描写的故事是多么的荒诞不经，无论其中蕴含的思想是多么的深刻，他从始至终都是一样地写，不带任何情绪地去描述。这样的文字往往会极端压抑，让人在短短几段中喘不过气来——仿佛身处梦魇。

以我此次的阅读为例。我阅读这部作品大概用了4个半小时，其中有很长一段时间，我是紧皱眉头的——不是改bug时候的样子，而是陷入无法逃脱的心灵困境的那种。一般来说，我阅读的时候是最能够逃离那种困境的——我阅读《地下室手记》的时候，感到的是酣畅淋漓，陀哥的癫狂的文字风格就是人物内心。而阅读卡夫卡的时候，那些笼罩在K头上的雾霾仿佛就在你的头顶。我是在K栋7楼休息区读的，只有我一个人，有时候会感觉害怕——而以前我在这里自习都是不会害怕的。与之前的读书经验不同的是，读这本书的时候我上厕所的次数相对地多了——不是书的尿点多，而是有些太压抑了。

其他的一些点，比如人物形象非常诡异、隐喻特别多、情节跳跃、对话特别长等等就不说了——因为已经挺晚了，现在是22:44。

另，~~……其实我刚刚有点东西想写出来，然后忘了。~~想起来了，我最近总是用破折号，标点怪异等等——我猜是卡夫卡的缘故。

###### 后记

像卡夫卡一类的作家，我将他们称为陀思妥耶夫斯基一脉的作家：从陀思妥耶夫斯基的心理小说开始，后世的很多优秀的作家将文学的笔调转向了对于人性的探索——他们的文字的力量往往在于敏锐的发现、表现的深刻，在感性的图像中展现世界的真相和人性深处的奥秘。

卡夫卡、安德烈·纪德、赫尔曼·黑塞、伊塔洛·卡尔维诺、阿尔贝·加缪、博尔赫斯……这些最为顶级的作家也是我非常喜欢的作家，他们往往不仅会受到陀思妥耶夫斯基的影响，还有丹麦哲学家克尔凯郭尔(祁克果)、尼采的影响。我阅读往往带着目的——实际上我认为任何行为都是有目的的，只不过有时候我们不愿意承认——，最为根本的一个目的就是了解自己，进而去寻找人生的意义——当然，现在我对于人生意义的答案是**不可知**。了解自己之后，对于一些困扰我的思想、念头，我都能够在自身寻找到一种比较好的方法去避免，甚至对抗。

歪个楼，人文的这部《卡夫卡小说全集》保留了卡夫卡手稿的原始风貌——真的太难读了。我上一次读的别人的手稿还是加缪的[《第一个人》](https://book.douban.com/subject/26908216/)，没能读下去。而同样的，甚至卡夫卡的手稿风格更为混乱疯狂——和他的小说一样，我读了下来。一方面是因为我对于卡夫卡的巨大期望，另一方面是卡夫卡的确写得比加缪好，虽然笔调冷淡，但是在体会文字的时候所体会到的悲哀与绝望、对于人的把握能够抓住你的心灵继续读下去。

### 其他

* 这几天早上一直都有课——日本文化与社会，老师挺漂亮的。但是，我总是感觉我最近所认识的人都是我早已见过的，难道柏拉图是对的吗？记得有一句话，“当你活到某一个岁数的时候，你所认识的死人会比活人更多”。我在他们身上看到的往往是我曾经认识的同学、朋友的身影，他们的差距如此之大，我却依旧认为是非常相似的。**我看到了什么？**
* 今天本来说建数据库的，然后读了书之后感觉不得不花费时间去思考，还有记录……于是，明日复明日<sub>啰</sub>。
