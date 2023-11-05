# frozen_string_literal: true

class Car < ApplicationRecord
  belongs_to :brand

  update_index('cars') { self }
  update_index('brands') do
    previous_changes['brand_id'] || brand
  end

  scope :search, lambda { |params|
    cars = all.joins(:brand)
    cars = cars.where(Brand.arel_table[:name].matches("%#{params[:query]}%")) if params[:query]
    cars = cars.where(Car.arel_table[:price].gteq(price_min)) if params[:price_min]
    cars = cars.where(Car.arel_table[:price].lteq(price_max)) if params[:price_max]
    cars
  }
end
