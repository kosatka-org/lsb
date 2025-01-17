require './db_connect'

`mkdir db_dump`

schema_only_tables = [
	"app_sessions",
	"discount",
	"messages",
	"orders_events",
	"prodazhi",
	"product_views",
	"search_history",
	"users2web_sessions",
	"users_actions",
	"users_crm",
	"web_sessions"
]

DB.tables.each do |table|
	no_data = schema_only_tables.include?(table.to_s) ? '--no-data' : ''
	`mysqldump -u #{ENV['DB_USER']} -p#{ENV['DB_PASS']} #{no_data} #{ENV['DB_NAME']} #{table} > "db_dump/#{table}.sql"`
end

`tar -zcf db_dump.tar.gz db_dump`
`rm -rf db_dump`
