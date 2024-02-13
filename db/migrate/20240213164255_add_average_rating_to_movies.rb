class AddAverageRatingToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :average_rating, :float
  end
end
