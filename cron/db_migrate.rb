require './db_connect'
require './error_service'

Dir.chdir("../db")

begin
  last_migration = File.read("migration.lock")
rescue
  puts "Migration lock file not found: creating blank"
  last_migration = "2016-03-30_1.sql"
  File.write("migration.lock", last_migration)
end

Dir.glob("*.sql").select {|sql| sql > last_migration && !sql.include?("nomigrate") }.sort.each do |sql|
  puts "Applying migration #{sql}"

  DB.transaction do
    File.read(sql).strip.split(/;$/).each do |query|
      DB.run(query)
    end
  end

  File.write("migration.lock", sql)
end.empty? and begin
  puts "No new migrations found"
end
