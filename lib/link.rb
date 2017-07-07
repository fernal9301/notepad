# encoding: utf-8
#
# Класс «Ссылка», разновидность базового класса «Запись»
class Link < Post
  def initialize
    super
    @url = ''
  end

  def read_from_console
    puts 'Url address (url):'
    @url = STDIN.gets.chomp

    puts 'What is it about'
    @text = STDIN.gets.chomp
  end

  def to_strings
    time_string = "Created at: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')} \n\r"
    [@url, @text, time_string]
  end

  # Метод to_db_hash у Задачи добавляет два ключа в хэш
  def to_db_hash
    super.merge(text: @text, url: @url)
  end

  # Метод load_data у Ссылки считывает дополнительно url ссылки
  def load_data(data_hash)
    super
    @url = data_hash['url']
  end
end
