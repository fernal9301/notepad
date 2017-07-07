# encoding: utf-8
require 'date'

# Класс «Задача», разновидность базового класса «Запись»
class Task < Post
  def initialize
    super
    @due_date = Time.now
  end

  def read_from_console
    puts 'What to do?'
    @text = STDIN.gets.chomp

    puts 'Write date in format DD.MM.YY, ' \
      'f.ex. 12.05.2003'
    input = STDIN.gets.chomp

    @due_date = Date.parse(input)
  end

  def to_strings
    deadline = "Deadline: #{@due_date.strftime('%Y.%m.%d')}"
    time_string = "Created at: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n\r"

    [deadline, @text, time_string]
  end

  # Метод to_db_hash у Задачи добавляет два ключа в хэш
  def to_db_hash
    super.merge(text: @text, due_date: @due_date.to_s)
  end

  # Метод load_data у Задачи считывает дополнительно due_date задачи
  def load_data(data_hash)
    super
    @due_date = Date.parse(data_hash['due_date'])
  end
end

