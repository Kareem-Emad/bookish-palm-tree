class Movie < ApplicationRecord
    has_many :reviews

    def update_average_rating
        update_column(:average_rating, reviews.average(:rating))
      end
end
