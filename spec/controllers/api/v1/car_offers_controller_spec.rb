require 'spec_helper'

describe Api::V1::CarOffersController, type: :controller do
  describe "#index" do
    let(:params) do
      {
        user_id: rand(100).to_s,
        query: "query",
        price_min: rand(10),
        price_max: rand(11..100),
        page: rand(10)
      }
    end
    let(:offers_fetcher) { instance_double(CarOffersFetcher) }
    let(:offers) do
      [{ id: 1, label: "perfect_match" }, { id: 2, label: "good_match" }]
    end

    before do
      expected_params = params.stringify_keys.transform_values(&:to_s)
      allow(CarOffersFetcher).to receive(:new).with(expected_params).and_return(offers_fetcher)
      allow(offers_fetcher).to receive(:fetch).and_return(offers)
    end

    subject { get :index, params: params }

    it "returns offers" do
      subject

      expect(response).to have_http_status(200)
      expect(parsed_response_body).to match(offers.as_json)
    end
  end
end
