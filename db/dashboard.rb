require 'active_record'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./db/dashboard.db"
)

class Link < ActiveRecord::Base
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_length_of     :name, :maximum => 100

  validates_presence_of   :url
end