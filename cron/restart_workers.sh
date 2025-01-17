#!/usr/bin/env bash

# load rvm ruby
source /home/lsboutique/data/.rvm/environments/ruby-2.1.5

kill -3 $(cat resque.pid)
PIDFILE=./resque.pid BACKGROUND=yes QUEUES=* bundle exec rake resque:work

kill -3 $(cat resque_scheduler.pid)
PIDFILE=./resque_scheduler.pid BACKGROUND=yes bundle exec rake resque:scheduler

if ! ps -p $(cat resque_web.pid) > /dev/null
then
	bundle exec thin -R config.ru -d -p 4567 --pid resque_web.pid start
fi
