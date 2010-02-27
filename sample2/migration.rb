require "rubygems"
require "dm-core"
require "dm-timestamps"
require "models"

DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db.sqlite3")
DataMapper.auto_migrate!
