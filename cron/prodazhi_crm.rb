# encoding: utf-8
require './db_connect.rb'

users = DB[:users]
prodazhi = DB[:prodazhi]
users_crm = DB[:users_crm]

puts prodazhi.where(:card).to_a.length
