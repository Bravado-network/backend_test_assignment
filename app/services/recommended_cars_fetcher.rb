require 'net/http'

class RecommendedCarsFetcher
  def initialize(user_id)
    @user_id = user_id
    @uri = recomended_cars_uri
  end

  def fetch
    response = fetch_data
    return [] if response.nil?

    parse(response)
  end

  private

  attr_reader :user_id, :uri

  def logger
    @logger ||= Rails.logger
  end

  def recomended_cars_uri
    URI("#{ENV["RECOMMENDATION_SERVICE_URL"]}/recomended_cars.json?user_id=#{user_id}")
  end

  def fetch_data
    Net::HTTP.get(uri)
  rescue Net::ReadTimeout => e
    logger.error("#{uri.host} is not reachable (ReadTimeout)")
  rescue StandardError => e
    logger.error("cannot receive data from #{uri.host}: #{e.class} #{e.message}")
  end

  def parse(response)
    JSON.parse(response)
  rescue JSON::ParserError => e
    logger.error("cannot parse response from #{uri.host}: #{e.message}")
    []
  end
end
