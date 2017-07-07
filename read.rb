# encoding: utf-8
require_relative 'lib/post'
require_relative 'lib/memo'
require_relative 'lib/link'
require_relative 'lib/task'
require_relative 'lib/db_init'
require 'optparse'

# Этот код необходим только при использовании русских букв на Windows
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# Создаем БД
include InitDb
create_notepad

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  # Вывод в случае, если запросили help
  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  # Опция --type будет передавать тип поста, который мы хотим считать
  opt.on('--type POST_TYPE', 'какой тип постов показывать ' \
         '(по умолчанию любой)') { |o| options[:type] = o }

  # Опция --id передает номер записи в базе данных (идентификатор)
  opt.on('--id POST_ID', 'если задан id — показываем подробно ' \
         ' только этот пост') { |o| options[:id] = o }

  # Опция --limit передает, сколько записей мы хотим прочитать из базы
  opt.on('--limit NUMBER', 'сколько последних постов показать ' \
         '(по умолчанию все)') { |o| options[:limit] = o }
end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

if result.is_a? Post
  puts "Запись #{result.class.name}, id = #{options[:id]}"
  result.to_strings.each { |line| puts line }
else
  puts
  puts "Take a look at notepad:"
  result.each do |row|
    puts

    row.each do |element|
      element_text = "#{element.to_s.encode('UTF-8').strip[0..17]}"

      # Если текст элемента короткий, добавляем нужное количество пробелов
      element_text << ' ' * (21 - element_text.size)

      print element_text
    end

    #print ' '
  end

  puts
end
