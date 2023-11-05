# frozen_string_literal: true

class Brand < ApplicationRecord
  has_many :cars, dependent: :destroy

  update_index('brands') { self }
  update_index('cars') { cars }
end
