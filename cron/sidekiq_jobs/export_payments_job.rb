require './models'
require './s3_class'

class ExportPaymentsJob
  include Sidekiq::Worker

  def perform(date = Date.today)
    filename = "export_payments_#{date}.csv"
    File.open(filename, "w:utf-8") do |file|
      file.puts "КодКассы;НомерЗаказа;Время;Тип;Сумма;ВнутреннийId;Комментарий;Клиент"
      OfflinePayment.where(payment_type: PaymentMethodOffline.exclude(name: 'Долг').where(return: false))
        .filter_by_date(date: date).each do |p|
        file.puts [
          p.cashbox.id,
          (p.order || p.debt&.order)&.order_id,
          p.date,
          p.payment_type&.name,
          p.money_paid.to_f,
          p.id,
          "Оплата #{p.debt_id == 0 ? 'продажи' : 'долга'}",
          (p.user || p.debt&.user)&.name
        ].join(";")
      end

      Expense.dataset.filter_by_date(date: date).each do |e|
        file.puts [
          e.cashbox.id,
          '',
          e.date,
          'Расходы',
          e.sum,
          e.id,
          e.comment,
          e.user&.name
        ].join(";")
      end

      Inkass.where(:confirmed).filter_by_date(confirm_date: date).each do |i|
        file.puts [
          i.cashbox&.id,
          '',
          i.date,
          'Инкассация',
          i.sum,
          i.id,
          i.comment,
          i.user&.name
        ].join(";")
      end

    end

    if `wc -l '#{filename}'`.to_i > 1
      S3Wrapper.new.put(filename)
    end
    File.delete(filename)
  end
end
