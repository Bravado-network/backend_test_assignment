# frozen_string_literal: true

class UsersIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      email: {
        tokenizer: 'uax_url_email',
        filter: %w[lowercase]
      }
    }
  }

  index_scope User
  field :id
  field :email, type: 'text', analyzer: 'email'
  field :preferred_price_range
end
