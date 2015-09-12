require 'mysql2-cs-bind'
require 'redis'
require 'hiredis'
require 'json'
require 'tempfile'

def connection
  config = JSON.parse(IO.read(File.dirname(__FILE__) + "/../config/#{ ENV['ISUCON_ENV'] || 'local' }.json"))['database']

  Thread.current[:isu3_db] ||= Mysql2::Client.new(
    :host => config['host'],
    :port => config['port'],
    :username => config['username'],
    :password => config['password'],
    :database => config['dbname'],
    :reconnect => true,
  )
end

def redis_db
  Thread.current[:isu4_db] ||= Redis.new(
    :host   => "127.0.0.1",
    :port   => 6379,
    :driver => :hiredis
  )
end

def gen_markdown(md)
  tmp = Tempfile.open("isucontemp")
  tmp.puts(md)
  tmp.close
  html = `../bin/markdown #{tmp.path}`
  tmp.unlink
  return html
end

def memo_html_key(memo_id)
  return "memo:#{memo_id}"
end

threads = []
connection.xquery("SELECT memos.id, memos.user, users.username as username, memos.content, memos.is_private, memos.created_at, memos.updated_at FROM memos inner join users on users.id = memos.user").each do |row|
  threads << Thread.new do

    mysql.xquery("UPDATE memos SET username = ? WHERE id=?", row["username"], row["id"])

    puts "id: #{row["id"]} end"
  end
end
