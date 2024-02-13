class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :movies, null: false, foreign_key: true
      t.string :user
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
