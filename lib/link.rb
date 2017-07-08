# encoding: utf-8
# class Link inherited from Post

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

  # Method to_db_hash add 2 keys to hash
  def to_db_hash
    super.merge(text: @text, url: @url)
  end

  # Method load_data reads url
  def load_data(data_hash)
    super
    @url = data_hash['url']
  end
end
