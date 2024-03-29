class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.belongs_to :movie, foreign_key: true
      t.string :user
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
