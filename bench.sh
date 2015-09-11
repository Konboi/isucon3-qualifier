mysql -uisucon isucon < /home/isucon/webapp/config/schema.sql
cd /opt/isucon/data && pigz -dc init.sql.gz | mysql -uisucon isucon
cd /home/isucon/webapp/ruby && /home/isucon/env.sh bundle exec ruby prepare.rb
/home/isucon/bench test
