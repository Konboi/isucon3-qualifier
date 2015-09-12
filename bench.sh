mysql -uisucon -pisucon isucon < /home/isucon/webapp/config/schema.sql
cd /opt/isucon/data && pigz -dc init.sql.gz | mysql -uisucon -pisucon isucon
mysql -uisucon -pisucon isucon < /home/isucon/webapp/config/index.sql
# cd /home/isucon/webapp/ruby && /home/isucon/env.sh bundle exec ruby prepare.rb
/home/isucon/bench test
