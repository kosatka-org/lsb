#!/usr/bin/env bash
git pull
bundle install
cd cron && bundle e ruby db_migrate.rb
