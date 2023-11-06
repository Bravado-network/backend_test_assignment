# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    recommended_cars = RecommendedCarsFinder.new(permitted_params).call

    render json: recommended_cars.to_json
  end

  private

  def permitted_params
    params.permit(:user_id, :query, :price_min, :price_max, :page)
  end
end
