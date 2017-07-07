# encoding: utf-8
require 'sqlite3'

# Базовый класс «Запись» — здесь мы определим основные методы и свойства,
# общие для всех типов записей.
class Post
  SQLITE_DB_FILE = 'notepad.sqlite'.freeze

  def initialize
    @created_at = Time.now
    @text = []
  end

  def self.post_types
    { Memo: Memo, Task: Task, Link: Link }
  end

  def self.create(type)
    post_types[type.to_sym].new
  end


  # Метод Post.find находит в базе запись по идентификатору или массив записей
  # из базы данных, который можно например показать в виде таблицы на экране
  def self.find(limit, type, id)
    db = SQLite3::Database.open(SQLITE_DB_FILE)

    if !id.nil?
      db.results_as_hash = true
      result = db.execute('SELECT * FROM posts WHERE  rowid = ?', id)
      db.close

      if result.empty?
        puts "id #{id} not found:("
        return nil
      else
        result = result[0]
        post = create(result['type'])
        post.load_data(result)

        post
      end
    else
      db.results_as_hash = false
      query = 'SELECT rowid, * FROM posts '
      query += 'WHERE type = :type ' unless type.nil?
      query += 'ORDER by rowid DESC '
      query += 'LIMIT :limit ' unless limit.nil?

      statement = db.prepare query
      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?
      result = statement.execute!
      statement.close

      db.close
      
      result
    end
  end

  def read_from_console
  end

  def to_strings
  end

  # Метод load_data заполняет переменные эземпляра из полученного хэша
  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
    @text = data_hash['text']
  end

  # Метод to_db_hash должен вернуть хэш типа {'имя_столбца' -> 'значение'} для
  # сохранения новой записи в базу данных
  def to_db_hash
    { type: self.class.name, created_at: @created_at.to_s }
  end

  # Метод save_to_db, сохраняющий состояние объекта в базу данных.
  def save_to_db
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = true

    post_hash = to_db_hash

    db.execute(
      'INSERT INTO posts (' +
      post_hash.keys.join(', ') +
      ") VALUES (#{('?,' * post_hash.size).chomp(',')})",
      post_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close

    insert_row_id
  end

  def save
    file = File.new(file_path, 'w:UTF-8')
    to_strings.each { |string| file.puts(string) }
    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)
    file_time = @created_at.strftime('%Y-%m-%d_%H-%M-%S')
    "#{current_path}/#{self.class.name}_#{file_time}.txt"
  end
end

