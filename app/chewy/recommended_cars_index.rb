# frozen_string_literal: true

class RecommendedCarsIndex < Chewy::Index
  field :user_id, type: 'short'
  field :id, type: 'integer'
  field :price, type: 'float'
  field :label, type: 'keyword'
  field :rank_score, type: 'float'
  field :model, type: 'text'
  field :brand do
    field :id
    field :name, type: 'text'
  end
end
