# encoding: utf-8
require_relative 'lib/post'
require_relative 'lib/memo'
require_relative 'lib/link'
require_relative 'lib/task'
require_relative 'lib/init_db'
require 'optparse'

# Windows hack for encoding utf-8 to work properly
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

# create db if not exist
include InitDb
create_notepad

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать ' \
         '(по умолчанию любой)') { |o| options[:type] = o }

  opt.on('--id POST_ID', 'если задан id — показываем подробно ' \
         ' только этот пост') { |o| options[:id] = o }

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

      element_text << ' ' * (21 - element_text.size)

      print element_text
    end
  end

  print "\n\n"
end
