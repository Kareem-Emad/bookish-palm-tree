class AddIndexToMoviesAverageRating < ActiveRecord::Migration[7.1]
  def change
    add_index :movies, :average_rating
  end
end
