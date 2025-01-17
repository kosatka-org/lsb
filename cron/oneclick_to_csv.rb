# encoding: utf-8
require './db_connect.rb'
require './models.rb'

filename = "oneclick.csv"

status_hash = {"out_of_stock" => "Нужного размера нет в наличии",
  "offline_shop" => "Самовывоз из магазина",
  "consultation" => "Оказана консультация",
  "unreachable" => "Не удалось связаться",
  "ordered" => "Сформирован заказ",
  "other" => "Другое"}

File.open(filename,"w:utf-8") do |file|
  file.puts "﻿Имя;Телефон;Дата;Модель;Цена;Артикул;Результат обработки"
  OneClick.association_join(:product).each do |o|
    file.puts "#{o.name};#{o.phone};#{o.date};#{o[:model]};#{o[:price]};#{o[:sku]};#{status_hash[o.disable_info]}"
  end
end
