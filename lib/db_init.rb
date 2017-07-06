# encoding: utf-8
# db_init.rb 
require 'sqlite3'

module Init_db
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
end 
