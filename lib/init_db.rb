# encoding: utf-8
# init_db.rb
require 'sqlite3'

module InitDb
  SQLITE_DB_FILE = 'notepad.sqlite'.freeze

  def create_notepad
    db = SQLite3::Database.new(SQLITE_DB_FILE)
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
