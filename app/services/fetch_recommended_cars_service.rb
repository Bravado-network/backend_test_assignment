# frozen_string_literal: true

class FetchRecommendedCarsService
  include BaseService

  ENDPOINT = '/recomended_cars.json'

  def self.call
    new.call
  end

  def call
    HTTPX.get(api_url).to_s
  end

  def api_url
    BASE_API_URL + ENDPOINT
  end
end
