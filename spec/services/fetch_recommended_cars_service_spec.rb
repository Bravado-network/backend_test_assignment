# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchRecommendedCarsService do
  def api_url
    BaseService::BASE_API_URL + described_class::ENDPOINT
  end

  def data
    File.read('spec/fixtures/recommended_cars.json')
  end

  describe '::call' do
    it 'raises an error on timeout'

    it 'raises an error on access denied'

    it 'raises an error with invalid JSON data'

    it 'fetches the recommended cars from the API' do
      allow(HTTPX).to receive(:get).with(api_url).and_return(data)

      service_data = described_class.call
      json_data = JSON.load(service_data)

      expect(json_data.first).to have_key('car_id')
      expect(json_data.first).to have_key('rank_score')
    end
  end
end
