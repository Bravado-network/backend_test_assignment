# frozen_string_literal: true

class RecommendedCarsIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      name: {
        tokenizer: 'keyword',
        filter: ['lowercase']
      }
    }
  }

  field :user_id
  field :id
  field :price
  field :label
  field :model, analyzer: 'name'
  field :brand do
    field :id
    field :name, analyzer: 'name'
  end
end
