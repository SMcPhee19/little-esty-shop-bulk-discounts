require 'csv'

namespace :csv_load do
  desc "Imports data from items.csv"
  task :items => :environment do

    CSV.foreach("db/data/items.csv", headers: true) do |row|
        Item.create!(row.to_h)
    end
  end
end