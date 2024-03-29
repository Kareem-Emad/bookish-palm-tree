require 'csv'

REVIEWS_BATCH_SIZE = 3

namespace :import do
  desc "Import Data from CSV file"
  task reviews: :environment do 
    
    # since reviews are mostly sorted by movie title, this will save time by making a single query for each movie per batch
    # batch size should be adjusted based on the number of movies and reviews and the data distribution

    CSV.foreach("reviews.csv", headers: true).each_slice(REVIEWS_BATCH_SIZE) do |rows|
        movies_mp = {}
        reviews_by_movie = {}

        rows.map do |row|
            movie_title = row['Movie']
            movies_mp[movie_title] = movies_mp[movie_title] || Movie.find_by(title: movie_title)

            reviews_by_movie[movie_title] = [] unless reviews_by_movie.has_key?(movie_title)
            reviews_by_movie[movie_title] <<
            {
                rating: row['Stars'].to_i,
                comment: row['Review'],
                user: row['User'],
            }
        end

        reviews_by_movie.each do |movie_title, reviews|
            movie = movies_mp[movie_title]
            movie.reviews.create(reviews)
        end

    end
  end
end