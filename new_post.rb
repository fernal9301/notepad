# encoding: utf-8
#
# Программа «Блокнот», демонстрирующая наследование классов в ruby.
# Версия 2.0, хранящая свои данные в базе данных SQLite
# Этот скрипт создает новые записи, чтением занимается другой скрипт
#
# (с) goodprogrammer.ru
#
# Этот код необходим только при использовании русских букв на Windows
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

def create_notepad
  begin
    db = SQLite3::Database.new('notepad.sqlite')
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS "posts"
        ("type" TEXT,
        "created_at" DATETIME,
        "text" TEXT,
        "url" TEXT,
        "due_date" DATETIME
        );
      SQL
  rescue SQLite3::Exception => e
    puts e
  ensure
    db.close if db
  end
end

# Подключаем класс Post и его детей: Memo, Link, Task
require_relative 'lib/post'
require_relative 'lib/memo'
require_relative 'lib/link'
require_relative 'lib/task'
require_relative 'lib/db_init'

# Создаем БД
include Init_db
create_notepad

# Здороваемся с пользователем и спрашиваем у него, какую запись он хочет создать
puts 'Hello, it\'s a simple notepad!'
puts 'Version 2 with SQlite support'
puts
puts 'What do you want to write?'

# Выводим массив возможных типов Записи (поста) с помощью метода post_types
# класса Post, который теперь возвращает не массив классов, а хэш.
choices = Post.post_types.keys

choice = -1
until choice >= 0 && choice < choices.size
  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end
  choice = gets.to_i
end

# Как только выбор сделан, мы можем создать запись нужного типа, передав выбор
# строку с название класса в статический метод create класса Post.
entry = Post.create(choices[choice])

entry.read_from_console

# Сохраняем пост в базу данных
rowid = entry.save_to_db

puts "Saved successfully, id = #{rowid}"
#
# Как обычно, при использовании классов программа выглядит очень лаконично!
