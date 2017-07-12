# encoding: utf-8
# new_post.rb

require_relative 'lib/post'
require_relative 'lib/memo'
require_relative 'lib/link'
require_relative 'lib/task'
require_relative 'lib/init_db'

# Windows hack for encoding utf-8 to work properly
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

InitDb.create_notepad

puts 'Hello, it\'s a simple notepad!'
puts 'Version 2 with SQlite support'
puts
puts 'What do you want to write?'

choices = Post.post_types.keys
choice = -1
until choice >= 0 && choice < choices.size
  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end
  choice = gets.to_i
end

entry = Post.create(choices[choice])
entry.read_from_console

rowid = entry.save_to_db

puts "Saved successfully, id = #{rowid}"
