# frozen_string_literal: true

class Car < ApplicationRecord
  belongs_to :brand

  scope :search, lambda { |params|
    cars = all.joins(:brand)
    cars = cars.where(Brand.arel_table[:name].matches("%#{params[:query]}%")) if params[:query]
    cars = cars.where(Car.arel_table[:price].gteq(price_min)) if params[:price_min]
    cars = cars.where(Car.arel_table[:price].lteq(price_max)) if params[:price_max]
    cars
  }
end
