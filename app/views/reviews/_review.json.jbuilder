json.extract! review, :id, :movies_id, :user, :rating, :comment, :created_at, :updated_at
json.url review_url(review, format: :json)
