class AddIndexToMoviesActor < ActiveRecord::Migration[7.1]
  def change
    add_index :movies, :actor
  end
end
