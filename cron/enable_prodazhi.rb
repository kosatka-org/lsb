#encoding: utf-8
require './db_connect.rb'

prodazhi    = DB[:prodazhi]

prodazhi.where(enabled: 0).reverse_order(:p_date).limit(500).update(enabled: 1)