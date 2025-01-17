#!/usr/bin/env puma
require 'dotenv'
Dotenv.load

rackup 'roda_app.ru'
environment ENV['ENVIRONMENT'] || 'production'

pidfile 'pids/roda.pid'

stdout_redirect 'logs/roda.stdout', 'logs/roda.stderr'

threads 0, 16

bind 'tcp://0.0.0.0:17888'
