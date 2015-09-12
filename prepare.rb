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

connection.xquery("SELECT * FROM memos").each do |row|
  user = connection.xquery("select username from users where id = ?", row["user"])
  connection.xquery("UPDATE memos SET username = ? WHERE id=?", user["username"], row["id"])
end
