RSpec.describe CarOffersFetcher do
  subject(:service) { described_class.new(args) }

  let(:user) { create(:user, preferred_price_range: 10_000..20_000) }
  let(:good_match_car2) { create(:car, price: 9_000) }
  let(:args) { { user_id: user.id } }
  let(:recommended_cars_fetcher) { instance_double(RecommendedCarsFetcher) }
  let(:recommended_cars) { {} }

  describe "#fetch" do
    subject(:fetch) { service.fetch }

    before do
      allow(RecommendedCarsFetcher)
        .to receive(:new).with(user.id).and_return(recommended_cars_fetcher)
      allow(recommended_cars_fetcher).to receive(:fetch).and_return(recommended_cars)
      RecommendedCarsFetcher.new(user.id).fetch
    end

    context "when there is no cars" do
      it "returns blank array" do
        expect(fetch).to eq([])
      end
    end

    context "with cars" do
      let!(:audi) { create(:brand, name: "Audi") }
      let!(:bentley) { create(:brand, name: "Bentley") }
      let!(:bmv) { create(:brand, name: "BMW") }
      let!(:car_without_rank_score) { create(:car, brand: audi, price: 11_000) }
      let!(:good_match_car1) { create(:car, brand: bentley, price: 25_000) }
      let!(:car_with_rank_score1) { create(:car, brand: audi, price: 5_000) }
      let!(:car_with_rank_score2) { create(:car, brand: audi, price: 18_000) }
      let!(:car_with_rank_score3) { create(:car, brand: audi, price: 15_000) }
      let!(:perfect_match_car) { create(:car, brand: bentley, price: 15_000) }
      let!(:good_match_car2) { create(:car, brand: bmv, price: 9_000) }
      let(:recommended_cars) do
        {
          good_match_car1.id => 0.34,
          car_with_rank_score1.id => 0.56,
          car_with_rank_score2.id => 0.11,
          car_with_rank_score3.id => 0.11,
          perfect_match_car.id => 0.76
        }
      end

      before do
        create(:user_preferred_brand, user: user, brand: bentley)
        create(:user_preferred_brand, user: user, brand: bmv)
      end

      def car_offer(car, label = nil)
        {
          id: car.id,
          brand: {
            id: car.brand_id,
            name: car.brand.name
          },
          price: car.price,
          rank_score: recommended_cars[car.id],
          model: car.model,
          label: label
        }
      end

      context "without filter arguments" do
        let(:args) { { user_id: user.id } }

        it "returns offers" do
          expect(fetch).to eq([
            car_offer(perfect_match_car, "perfect_match"),
            car_offer(good_match_car1, "good_match"),
            car_offer(good_match_car2, "good_match"),
            car_offer(car_with_rank_score1),
            car_offer(car_with_rank_score3),
            car_offer(car_with_rank_score2),
            car_offer(car_without_rank_score)
          ])
        end
      end

      context "with filter by price" do
        let(:args) do
          {
            user_id: user.id,
            price_min: 10_000,
            price_max: 15_000
          }
        end

        it "returns offers" do
          expect(fetch).to eq([
            car_offer(perfect_match_car, "perfect_match"),
            car_offer(car_with_rank_score3),
            car_offer(car_without_rank_score)
          ])
        end
      end

      context "with filter by brand" do
        let(:args) do
          {
            user_id: user.id,
            query: "Bent",
          }
        end

        it "returns offers" do
          expect(fetch).to eq([
            car_offer(perfect_match_car, "perfect_match"),
            car_offer(good_match_car1, "good_match")
          ])
        end
      end
    end
  end
end
