class ImportRecommendedCarsForUserService
  def initialize(user_id:)
    @user_id = user_id
  end

  def call
    CarRankingsIndex.import car_rankings

    Car.joins(:brand).find_in_batches(batch_size: 100) do |cars|
      data = ActiveModel::Serializer::CollectionSerializer.new(cars, scope: user,
                                                                     serializer: RecommendedCarSerializer).to_json
      RecommendedCarsIndex.import JSON.parse(data)
    end
  end

  private

  attr_reader :user_id

  def user
    @user ||= User.joins(:preferred_brands).find(user_id)
  end

  def car_rankings
    FetchRecommendedCarsService.new(user_id).call
  end
end
