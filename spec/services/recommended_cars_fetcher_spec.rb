RSpec.describe RecommendedCarsFetcher do
  subject(:service) { described_class.new(user_id) }

  let(:user_id) { rand(100) }
  let(:rails_cache) { Rails.cache }
  let(:rails_logger) { Rails.logger }

  describe "#fetch" do
    subject(:fetch) { service.fetch }

    context "when there is cached data" do
      let(:cached_data) { double(:cached_data) }

      it "returns cached data" do
        expect(rails_cache)
          .to receive(:fetch)
          .with("recommended_cars/#{user_id}", expires_in: 1.day, skip_nil: true)
          .and_return(cached_data)

        expect(fetch).to eq(cached_data)
      end
    end

    context "when there is no cached data" do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:uri) do
        URI("#{ENV["RECOMMENDATION_SERVICE_URL"]}/recomended_cars.json?user_id=#{user_id}")
      end
      let(:response) do
        [
          { "car_id": 36,  "rank_score": 0.7068 },
          { "car_id": 103, "rank_score": 0.4729 }
        ].to_json
      end

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        allow(Net::HTTP).to receive(:get).with(uri).and_return(response)
        Rails.cache.clear
      end

      context "with successful response from the recommendation service" do
        let(:expected_hash) { { 36 => 0.7068, 103 => 0.4729 } }

        it "returns generated hash based on received response and cache it" do
          expect(fetch).to eq(expected_hash)
          expect(Rails.cache.read("recommended_cars/#{user_id}")).to eq(expected_hash)
        end
      end

      shared_examples "returns default value" do
        it "returns blank hash and does not cache it" do
          expect(fetch).to eq({})
          expect(Rails.cache.exist?("recommended_cars/#{user_id}")).to eq(false)
        end
      end

      context "with blank response from the recommendation service" do
        let(:response) { nil }

        it_behaves_like "returns default value"
      end

      context "with invalid response from the recommendation service" do
        let(:response) { "error" }

        it "logs the error" do
          expect(rails_logger)
            .to receive(:error)
            .with("cannot parse response from #{uri.host}: 783: unexpected token at 'error'")
          fetch
        end

        it_behaves_like "returns default value"
      end

      context "when the recommendation service does not respond" do
        before do
          allow(Net::HTTP)
            .to receive(:get)
            .with(uri)
            .and_raise(NoMethodError, "undefined method `hostname' for nil:NilClass")
        end

        it "logs the error" do
          expect(rails_logger)
            .to receive(:error)
            .with("cannot receive data from #{uri.host}: NoMethodError undefined method `hostname' for nil:NilClass")
          fetch
        end

        it_behaves_like "returns default value"
      end
    end
  end
end
