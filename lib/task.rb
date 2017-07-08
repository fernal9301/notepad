# encoding: utf-8
# class Memo inherited from Post
require 'date'

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

  # Method to_db_hash add 2 keys to hash
  def to_db_hash
    super.merge(text: @text, due_date: @due_date.to_s)
  end

  # # Method load_data reads due_date
  def load_data(data_hash)
    super
    @due_date = Date.parse(data_hash['due_date'])
  end
end

