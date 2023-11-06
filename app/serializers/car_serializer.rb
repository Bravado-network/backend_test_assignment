# frozen_string_literal: true

class CarSerializer < ActiveModel::Serializer
  attributes :id, :model, :price
  belongs_to :brand
end
