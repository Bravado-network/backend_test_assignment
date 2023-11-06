# frozen_string_literal: true

class FetchRecommendedCarsService
  include BaseService

  ENDPOINT = '/recomended_cars.json'

  def initialize(user_id)
    @user_id = user_id
  end

  def call
    response = JSON.parse HTTPX.get(api_url).to_s

    response.map { |h| h.merge('user_id' => user_id) }
  end

  private

  attr_reader :user_id

  def api_url
    "#{base_api_url}?user_id=#{user_id&.to_s}"
  end
end
