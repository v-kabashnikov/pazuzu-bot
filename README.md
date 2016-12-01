Ruby 2.3.1
Rails 5.0.0.1

rvm gemset create pazuzu
rvm use 2.3.1@pazuzu
gem install bundler
bundle
bundle exec figaro install

config/application.yml

default: &default
   database_username:
   database_password:
   token:


DB: PostgreSQL 9.5.5

rake db:create
rake db:migrate

Telegram webhook set task:

rake telegram_bot:set_webhook url="subdomain.domain.asd"
