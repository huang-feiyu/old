---
layout:     post
title:      Summer-vacation-Journal-17
subtitle:   2021暑假手记-17
date:       2021-07-13
author:     Huang
header-img: img/post_bg_castle_dark_moon.jpg
catalog: true
tags:
   - Journal
---

### 前言

2021夏季的暑假手记——虽然不是手写的，这里会大概记录我暑假的每一天(如果我记了的话)。

今天写出来的的内容是：将Schema抽象为SQL语句。

其他有：将个人阅读的书目弄到数据库中去——熟练使用SQL&寻找简单方法(本次使用SQLite DBMS)、化学实验。

### 将Schema写成SQL语句

今天，我修改了之前的schema的不足之处。具体修改了哪里，可以看下面的代码。

```sqlite
-----------------------LEVEL 1------------------------------------
CREATE TABLE [book] (
    [id]            INTEGER PRIMARY KEY NOT NULL,
    [name]          TEXT NOT NULL,
    [description]   TEXT NOT NULL,
    [page_number]   INTEGER NOT NULL,
    [word_number]   INTEGER NOT NULL,
    [is_fiction]    INTEGER NOT NULL,
    [is_classic]    INTEGER NOT NULL,
    [is_philosophy] INTEGER NOT NULL,
    [my_info]       INTEGER NOT NULL,
    [language]      INTEGER NOT NULL,
    [type]          INTEGER NOT NULL,
    [release]       INTEGER NOT NULL,
    [author]        INTEGER NOT NULL,
    [translator]    INTEGER NOT NULL
);

-----------------------LEVEL 2-----------------------------------
CREATE TABLE [author] (
    [id]                 INTEGER PRIMARY KEY NOT NULL,
    [name]               TEXT NOT NULL,
    [country]            INTEGER NOT NULL,
    [begin_date_year]    INTEGER NOT NULL,
    [begin_date_month]   INTEGER NOT NULL,
    [begin_date_day]     INTEGER NOT NULL,
    [end_date_year]      INTEGER NOT NULL,
    [end_date_month]     INTEGER NOT NULL,
    [end_date_day]       INTEGER NOT NULL,
    [gender]             INTEGER NOT NULL,
    FOREIGN KEY(id) REFERENCES book(author)
);

CREATE TABLE [language] (
    [id]                 INTEGER PRIMARY KEY NOT NULL,
    [name]               TEXT NOT NULL,
    FOREIGN KEY(id) REFERENCES book(language)
);

CREATE TABLE [my_info] (
    [id]          INTEGER PRIMARY KEY NOT NULL,
    [date_year]   INTEGER NOT NULL,
    [date_month]  INTEGER NOT NULL,
    [date_day]    INTEGER NOT NULL,
    [read_times]  INTEGER NOT NULL,
    [book_link]   TEXT NOT NULL,
    [score]       INTEGER NOT NULL,
    FOREIGN KEY(id) REFERENCES book(my_info)
);

CREATE TABLE [release] (
    [id]             INTEGER PRIMARY KEY NOT NULL,
    [date_year]      INTEGER NOT NULL,
    [date_month]     INTEGER NOT NULL,
    [ean_number]     INTEGER NOT NULL,
    [area_number]    INTEGER NOT NULL,
    [press_number]   INTEGER NOT NULL,
    [release_number] INTEGER NOT NULL,
    [code_number]    INTEGER NOT NULL,
    FOREIGN KEY(id) REFERENCES book(release)
);

CREATE TABLE [translator] (
    [id]            INTEGER PRIMARY KEY NOT NULL,
    [name]          TEXT NOT NULL,
    FOREIGN KEY(id) REFERENCES book(translator)
);

CREATE TABLE [type] (
    [id]            INTEGER PRIMARY KEY NOT NULL,
    [name]          TEXT NOT NULL,
    FOREIGN KEY(id) REFERENCES book(type)
);

-----------------------LEVEL 3-----------------------------------
CREATE TABLE [country] (
    [id]                 INTEGER PRIMARY KEY NOT NULL,
    [name]               TEXT NOT NULL,
    FOREIGN KEY(id) REFERENCES author(country)
);

CREATE TABLE [gender] (
    [id]                 INTEGER PRIMARY KEY NOT NULL,
    [name]               TEXT NOT NULL,
    FOREIGN KEY(id) REFERENCES author(gender)
);

CREATE TABLE [press] (
    [id]        INTEGER PRIMARY KEY NOT NULL,
    [name]      TEXT NOT NULL,
    FOREIGN KEY(id) REFERENCES release(press_number)
);
```

当然，修改之后的schema还是存在不足之处，需要写的东西太多了——突然发现，三个`is`是可以建成一个表的……算了，写得好累。

### 其他

* 今天，我录入了一些数据，发现很难录入——这应该可以通过一个程序来实现，可以将这些写成一个GUI程序，能够根据所选择的tag进行实现……过几天再说吧，现在还挺忙的。

  
