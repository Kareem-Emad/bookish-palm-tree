require 'csv'

MOVIES_BATCH_SIZE = 3

namespace :import do
  desc "Import Data from CSV file"
  task movies: :environment do 

    CSV.foreach("movies.csv", headers: true).each_slice(MOVIES_BATCH_SIZE) do |rows|
      movies_data = rows.map do |row|
        {
          title: row['Movie'],
          description: row['Description'],
          year: row['Year'].to_i,
          director: row['Director'],
          actor: row['Actor'],
          location: row['Filming location'],
          country: row['Country']
        }
      end

      Movie.create(movies_data)
    end
  end
end