sudo gem install rails --version=2.3.4 --no-rdoc --no-ri
sudo gem install highline --version=1.4.0 --no-rdoc --no-ri 
sudo gem install authlogic --version=2.0.11 --no-rdoc --no-ri 
sudo gem install activemerchant --version=1.4.1 --no-rdoc --no-ri 
sudo gem install tlsmail --version=0.0.1 --no-rdoc --no-ri 
sudo gem install activerecord-tableless --version=0.1.0 --no-rdoc --no-ri 
sudo gem install haml-edge --version=2.1.37 --no-rdoc --no-ri 
sudo gem install chriseppstein-compass --version=0.6.15 --no-rdoc --no-ri 
sudo gem install calendar_date_select --version=1.15 --no-rdoc --no-ri 
sudo gem install rsl-stringex  --no-rdoc --no-ri 
sudo gem install chronic --no-rdoc --no-ri 
sudo gem install javan-whenever  --no-rdoc --no-ri 
sudo gem install searchlogic --version=2.1.13 --no-rdoc --no-ri 
sudo gem install mislav-will_paginate --version=2.3.11 --no-rdoc --no-ri 
sudo gem install mysql --no-rdoc --no-ri 
 
echo WC_DB_ENGINE=${WC_DB_ENGINE}
 
echo "
login: &login
adapter: ${WC_DB_ENGINE}
database: ${WC_APP_NAME}
username: ${WC_APP_NAME}
password: ${WC_DB_PASSWORD}
host: localhost
" > config/database.yml
 
if [ "${WC_DB_ENGINE}" == "mysql" ]; then
echo "
production:
<<: *login
encoding: utf8
" >> config/database.yml
fi
 
if [ "${WC_DB_ENGINE}" == "postgresql" ]; then
echo "
production:
<<: *login
encoding: unicode
pool: 5
port: 5432
" >> config/database.yml
fi
 
rake db:bootstrap RAILS_ENV=production
chown www-data log
