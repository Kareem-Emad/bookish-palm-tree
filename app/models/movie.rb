class Movie < ApplicationRecord
    has_many :reviews

    default_scope -> { order(average_rating: :desc) }

    def search_by_actor(text)
        where("actor LIKE ?", "%#{q}%")
    end
    # we can avoid the extra average query by using a counter + a sum of the ratings
    # but this may grow big if we have a lot of reviews
    def update_average_rating
        update_column(:average_rating, reviews.average(:rating))
    end
end
