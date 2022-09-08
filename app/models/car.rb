class Car < ApplicationRecord
  belongs_to :brand

  validates :model, presence: true
end
