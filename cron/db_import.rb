require "dotenv"
require "pathname"
Dotenv.load
Pathname.pwd.ascend do |path|
  filepath = path + "db_dump.tar.gz"
  next unless File.exist? filepath
  `tar -xzf #{filepath}`
  Dir["db_dump/*.sql"].each do |table_file|
    `mysql --protocol=tcp --port=3306 -u#{ENV["DB_USER"]} -p#{ENV["DB_PASS"]} #{ENV["DB_NAME"]} < #{table_file}`
  end
  `rm -rf db_dump`
end
