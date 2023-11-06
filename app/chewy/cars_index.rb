# frozen_string_literal: true

class CarsIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      model: {
        tokenizer: 'keyword',
        filter: ['lowercase']
      }
    }
  }

  index_scope ::Car.includes(:brand)

  field :id
  field :model, analyzer: 'model'
  field :price
end
