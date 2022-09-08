require 'net/http'

class RecommendedCarsFetcher
  def initialize(user_id)
    @user_id = user_id
    @uri = recommended_cars_uri
  end

  def fetch
    cached_data_or_fetch || {}
  end

  private

  attr_reader :user_id, :uri

  def cached_data_or_fetch
    # TODO: clear after recommended cars update
    Rails.cache.fetch("recommended_cars/#{user_id}", expires_in: 1.day, skip_nil: true) {
      response = fetch_data
      return if response.nil?

      recommended = parse(response)
      hash_by_car_id(recommended) if recommended
    }
  end

  def logger
    @logger ||= Rails.logger
  end

  def recommended_cars_uri
    URI("#{ENV["RECOMMENDATION_SERVICE_URL"]}/recomended_cars.json?user_id=#{user_id}")
  end

  def fetch_data
    Net::HTTP.get(uri)
  rescue Net::ReadTimeout => e # TODO: it may not work as expected
    logger.error("#{uri.host} is not reachable (ReadTimeout)")
    nil
  rescue StandardError => e
    logger.error("cannot receive data from #{uri.host}: #{e.class} #{e.message}")
    nil
  end

  def parse(response)
    JSON.parse(response)
  rescue JSON::ParserError => e
    logger.error("cannot parse response from #{uri.host}: #{e.message}")
    nil
  end

  def hash_by_car_id(array)
    array.map { |a| [a["car_id"], a["rank_score"]]}.to_h
  end
end
