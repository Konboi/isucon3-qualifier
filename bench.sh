mysql -uisucon isucon < /home/isucon/webapp/config/schema.sql
cd /opt/isucon/data && pigz -dc init.sql.gz | mysql -uisucon isucon
/home/isucon/bench test
