# encoding: utf-8
# class Memo inherited from Post

class Memo < Post
  def read_from_console
    puts 'New memo (type "end" on a new line to quit):'

    line = nil

    until line == 'end'
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop
  end

  def to_strings
    time_string = "Created at: #{@created_at.strftime('%Y.%m.%d, %H:%M:%S')}\n\r"
    @text.unshift(time_string)
  end

  # Method to_db_hash add 1 key to hash
  def to_db_hash
    super.merge(text: @text.join('\n\r'))
  end

  # Method load_data reads text
  def load_data(data_hash)
    super(data_hash)
    @text = data_hash['text'].encode('UTF-8').split('\n\r')
  end
end

