require 'csv'

## WIP
## Approach:
# Load batch of movies
# create movies and store them in a hash
# Load N batches of reviews till we encounter a new movie title
# clear movie cache and load a new batch
namespace :import do

  desc "Import Data from CSV file"
  task combined: :environment do 

    reviews_reader = CSV.foreach('reviews.csv', headers: true).each_slice(REVIEWS_BATCH_SIZE)

    remaining_rows = []
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

        movies = Movie.create(movies_data)

        movies_map = {}
        movies.each do |movie|
            movies_map[movie.title] = movie
        end

        remaining_rows = load_reviews_batch(remaining_rows, movies_map, remaining_rows) unless remaining_rows.empty?
        next unless remaining_rows.empty?

        begin 
            begin
                batch = reviews_reader.next()
                remaining_rows = load_reviews_batch(batch, movies_map)
            rescue StopIteration
                break
            end
        end while remaining_rows.empty? 

    end
end

def load_reviews_batch(batch, movies_mp, remaining_rows = [])
    reviews_by_movie = {}
        
    batch.each do |row|
        movie_title = row['Movie']

        reviews_by_movie[movie_title] = [] unless reviews_by_movie.has_key?(movie_title)
        reviews_by_movie[movie_title] <<
        {
            rating: row['Stars'].to_i,
            comment: row['Review'],
            user: row['User'],
        }
    end

    reviews_by_movie.each do |movie_title, reviews|
        next if movie_title.nil?
        if movies_mp.has_key?(movie_title)
            movie = movies_mp[movie_title]
            movie.reviews.create(reviews)
        else
            # puts "Movie not found: #{movie_title} with reviews: #{reviews}.."
            remaining_rows.concat(reviews)
        end
    end

    remaining_rows
end
end