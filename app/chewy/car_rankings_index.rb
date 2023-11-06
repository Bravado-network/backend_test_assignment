# frozen_string_literal: true

class CarRankingsIndex < Chewy::Index
  field :user_id
  field :car_id
  field :rank_score
end
