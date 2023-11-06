# frozen_string_literal: true

class SearchController < ApplicationController
  PAGE_SIZE = 20
  DEFAULT_PAGE = 1

  def index
    recommended_cars = RecommendedCarsFinder.new(permitted_params).call
    recommended_cars = recommended_cars.limit(PAGE_SIZE).offset(page_number)

    render json: recommended_cars.to_json
  end

  private

  def permitted_params
    params.permit(:user_id, :query, :price_min, :price_max, :page)
  end

  def page_number
    (params[:page] || DEFAULT_PAGE) - 1
  end
end
