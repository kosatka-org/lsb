require './models'
require './s3_class'
require './email_class'
require './error_service'

if ARGV[0]
  date = Date.parse(ARGV[0])
else
  date = Date.today
end

filename = "movements_#{date}.csv"
File.open(filename, "w:utf-8") do |file|
  file.puts "ID Перемещения;Откуда;Куда;Штрихкод;Время;Количество;ОткудаКодСклада;КудаКодСклада"
  movements = Movement.where(need_confirmation: false, accepted: true)
    .filter_by_date(accepted_date: date).all
  reservations = Reservation.dataset.filter_by_date.all
  (movements+reservations).each do |m|
    next unless (m.original_warehouse && m.destination_warehouse)
    m.items.each do |item|
      next unless (item[:accepted] || m.is_a?(Reservation))
      file.puts [
        m.movement_id,
        m.original_warehouse.name,
        m.destination_warehouse.name,
        item.barcode,
        m.date,
        item[:quantity],
        m.original_warehouse.code,
        m.destination_warehouse.code
      ].join(";")
    end
  end
end

if ENV['ENVIRONMENT'] == 'production'
  S3Wrapper.new.put(filename)
  File.delete(filename)
end
