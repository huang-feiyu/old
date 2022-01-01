import sqlite3
import datetime

conn = sqlite3.connect('mybook.db')
c = conn.cursor()

def get_time():
    today = datetime.date.today()
    return [today.year, today.month, today.day]

def check_author():
    author = input("请输入作者名: ")
    author_ex = "%" + author + "%"
    c.execute("""
            SELECT * FROM author
            WHERE name LIKE ?
              """, (author_ex, ))
    author_list = c.fetchall()
    if author_list:
        return (True, "", author_list[0][0])
    return (False, author)

def insert_author(name, country):
    c.execute("""
            SELECT MAX(id) FROM author
              """)
    author_id = c.fetchone()[0] + 1
    c.execute("""
            INSERT INTO author
            VALUES(?, ?, ?)
              """, (author_id, name, country))
    conn.commit()
    return author_id

def insert_book(name, isbn, press, tags, type, page_number, word_number, author,
                translator):
    c.execute("""
            SELECT MAX(id) FROM book
              """)
    book_id = c.fetchone()[0] + 1
    book_list = [book_id]
    book_list.append(name)
    book_list.append(isbn)
    book_list.append(press)
    book_list.append(tags)
    book_list.append(type)
    book_list.append(page_number)
    book_list.append(word_number)
    book_list.append(author)
    book_list.append(translator)
    book_list.append(book_id)
    book_list.append(0)
    print(book_list)
    c.execute("""
            INSERT INTO book
            VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
              """, tuple(book_list))
    # insert into my_info
    date_list = get_time()
    date_list.insert(0, book_id)
    c.execute("""
            INSERT INTO my_info
            VALUES(?, 2021, 12, 13, 0, 0, '已购', '无')
              """, tuple(date_list))
    conn.commit()

def main():
    count = 1
    while True:
        print("\n=========第" + str(count) + "本书==========")
        # author
        author_list = list(check_author())
        if not author_list[0]:
            author_country = input("请输入作者国家: ")
            author_list.append(insert_author(author_list[1], author_country))
        # book
        book_name = input("请输入书名: ")
        book_isbn = input("请输入ISBN: ")
        while len(book_isbn) != 13:
            book_isbn = input("请输入ISBN: ")
        book_press = input("请输入出版社: ")
        book_tags = input("请输入tags: #(虚构)#(经典)#(哲学) ")
        book_type = input("请输入书籍类型: ")
        page_number = int(input("请输入页数: "))
        word_number = int(input("请输入字数: "))
        book_author = author_list[2]
        book_translator = input("请输入译者: 没有为'null' ")
        insert_book(book_name, book_isbn, book_press, book_tags, book_type,
                page_number, word_number, book_author, book_translator)
        count += 1


if __name__ == '__main__':
    main()
