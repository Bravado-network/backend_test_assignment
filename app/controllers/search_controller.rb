# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :set_user, only: :index

  def index
    cars = CarsFinder.new(search_params).call

    render json: ActiveModel::Serializer::CollectionSerializer.new(cars, scope: @user,
                                                                         serializer: RecommendedCarSerializer).to_json
  end

  private

  def permitted_params
    params.permit(:user_id, :query, :price_min, :price_max, :page)
  end

  def set_user
    @user = User.find(permitted_params.delete(:user_id))
  end

  def search_params
    permitted_params
  end
end
