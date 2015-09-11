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
  puts "id: #{row["id"]} start"
  content = row['content']
  memo_id = row['id']

  content_html = gen_markdown(content)
  memo_html_key = memo_html_key(memo_id)

  redis_db.set(memo_html_key, content_html)
  puts "id: #{row["id"]} end"
end
