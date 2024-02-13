require 'csv'

MOVIES_BATCH_SIZE = 3
## Approach:
# Load batch of movies
# create movies and store them in a hash
# Load N batches of reviews till we encounter a new movie title
# clear movie cache and load a new batch
namespace :import do

  desc "Import Data from CSV file"
  task combined: :environment do 

  end
end