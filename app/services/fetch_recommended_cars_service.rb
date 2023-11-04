# frozen_string_literal: true

class FetchRecommendedCarsService
  include BaseService

  ENDPOINT = '/recomended_cars.json'

  def self.call(user_id:)
    new(user_id).call
  end

  def initialize(user_id)
    @user_id = user_id.to_s
  end

  def call
    HTTPX.get(api_url).to_s
  end

  private

  attr_reader :user_id

  def api_url
    base_api_url + '?user_id=' + user_id
  end
end
