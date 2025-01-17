require "sequel"
require "dotenv"

# Gets environment variables from .env file

Dotenv.load

DB = Sequel.mysql2({
  host: ENV["DB_HOST"],
  user: ENV["DB_USER"],
  password: ENV["DB_PASS"],
  database: ENV["DB_NAME"],
  encoding: "utf8",
  max_connections: 8
})
Sequel.extension :core_extensions
DB.extension :pagination
DB.extension :connection_validator
