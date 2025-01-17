require './models'
require 'twisted-caldav'
require 'google/apis/sheets_v4'
require 'google_drive'


class ImportCalendarJob
  include Sidekiq::Worker
  GOOGLE_SESSION = GoogleDrive::Session.from_service_account_key(ENV['GOOGLE_SERVICE_ACCOUNT_KEY'])
  SERVICE = Google::Apis::SheetsV4::SheetsService.new
  SERVICE.authorization = GOOGLE_SESSION.drive.request_options.authorization
  SPREADSHEET = GOOGLE_SESSION.spreadsheet_by_title("Отчёт по рабочим дням") || GOOGLE_SESSION.create_spreadsheet("Отчёт по рабочим дням")
  COLUMNS = ["Сотрудник", "Дней", "Часов"].freeze
  CALENDARS = ENV['CALDAV_CALENDAR_IDS'].to_s.split(",").map do |cal_id|
    TwistedCaldav::Client.new(uri: ENV['CALDAV_URI'].sub('default', cal_id),
      user: ENV['CALDAV_USER'], password: ENV['CALDAV_PASSWORD'])
  end.freeze


  def perform(args = {})
    @args = args
    if @args['monthly']
      monthly_import
    else
      workhour_import
      WorkHour.where(Sequel[:date] < Date.today).delete
    end
  end

  def monthly_import
    worksheet = month_worksheet
    worksheet_values.each { |values| worksheet.list.push values }
    worksheet.save
    share_spreadsheet
  end

  def worksheet_values
    ev_data = monthly_events.map {|events| event_data events }

    user_hours = ev_data.reduce({}) {|m,i| m.merge!(i) {|_,v1,v2| v1+v2}}
    user_days = ev_data.map(&:keys).flatten
      .each_with_object(Hash.new(0)) { |user_id,counts| counts[user_id] += 1 }
    user_days.map do |user_id, days|
      user = User[user_id] || next
      ws_row(user: user, days: days, hours: user_hours[user_id])
    end.compact
  end

  def monthly_events(date_from = first_day_of_prev_month)
    CALENDARS.map do |cal|
      (date_from...date_from.next_month).map do |date|
        events_for_date(cal, date)
      end
    end.reduce(&:+)
  end

  def month_worksheet(date_from = first_day_of_prev_month)
    worksheet_title = date_from.strftime("%m/%Y")
    SPREADSHEET.worksheet_by_title(worksheet_title)&.delete
    worksheet = SPREADSHEET.add_worksheet(worksheet_title)
    worksheet.update_cells(1, 1, [COLUMNS])
    worksheet
  end

  def clear_worksheet(ws)
    req = {delete_dimension: {range: {sheet_id: ws.gid, dimension: "ROWS", start_index: 1, end_index: ws.num_rows}}}
    SERVICE.batch_update_spreadsheet(ws.spreadsheet.id, {requests: [req]}, {})
  end

  def ws_row(data)
    user = data[:user]
    {
      "Сотрудник" => "=HYPERLINK(\"https://lsboutique.ru/admin/index.php?section=User&user_id=#{user.user_id}\",\"#{user.name}\")",
      "Дней" => data[:days],
      "Часов" => data[:hours]
    }
  end

  def first_day_of_prev_month
    today = Date.today
    Date.new(today.year, today.prev_month.month)
  end

  def event_data(events)
    events.inject({}) do |data, event|
      user_id = event.summary.split.last.to_i
      next data if user_id.zero?
      data[user_id] = (event.dtend.to_time - event.dtstart.to_time) / 3600
      data
    end
  end

  def default_hash
    Hash.new { |hash, key| hash[key] = {hours: 0, days: 0} }
  end

  def share_spreadsheet
    emails = @args['emails'] || ["lsboutique.ru@gmail.com", "megacuba@gmail.com"]
    emails.each do |email|
      subbed_emails = []
      for entry in SPREADSHEET.acl
        subbed_emails.push entry.email_address
      end
      SPREADSHEET.acl.push({type: "user", email_address: email, role: "writer"}) unless subbed_emails.include?(email)
    end
  end

  def events_for_date(calendar, date)
    calendar.find_events(start: date.to_time.to_i, end: date.succ.to_time.to_i) || []
  end

  def workhour_import
    date = Date.today
    CALENDARS.each do |cal|
      (date..date+2).each do |cdate|
        events = events_for_date(cal, cdate) || next
        events.each do |ev|
          uid = ev.summary.split.last
          user = User[uid] || next
          wh = WorkHour.find_or_create(user: user, date: cdate)
          wh.update(start: ev.dtstart.strftime("%H:%M"), end: ev.dtend.strftime("%H:%M"))
        end
      end
    end
  end

end
