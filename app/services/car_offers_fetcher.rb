class CarOffersFetcher
  PER_PAGE = 20
  MATCH_LABEL_MAP = {
     1 => "perfect_match",
     0 => "good_match",
  }.freeze

  def initialize(args = {})
    @args = args
    @user_id = args.fetch(:user_id).to_i
  end

  def fetch
    cars_by_args.map { |car| car_hash(car) }
  end

  private

  attr_reader :args, :user_id

  def car_hash(car)
    {
      id: car.id,
      brand: {
        id: car.brand_id,
        name: car.brand_name
      },
      price: car.price,
      rank_score: car.rank_score.zero? ? nil : car.rank_score,
      model: car.model,
      label: MATCH_LABEL_MAP[car.match]
    }
  end

  def recommended_cars
    @recommended_cars ||= RecommendedCarsFetcher.new(user_id).fetch
  end

  def cars_by_args
    scope = Car.all
    scope = add_joins_to_scope(scope)
    scope = add_select_to_scope(scope)
    scope = add_conditions_to_scope(scope)
    scope = scope.order("match DESC, rank_score DESC, cars.price ASC")
    scope = scope.offset((args[:page] - 1) * PER_PAGE) if args[:page].present? && args[:page] > 1
    scope.limit(PER_PAGE)
  end

  def add_joins_to_scope(scope)
    scope
      .joins(:brand)
      .joins("
        LEFT JOIN user_preferred_brands upb ON
             upb.user_id = #{user_id} AND upb.brand_id = cars.brand_id
      ")
      .joins("JOIN users ON users.id = #{user_id}")
  end

  def recommended_cars_when_cases
    recommended_cars.map {|car_id, rank_score| "WHEN cars.id = #{car_id} THEN #{rank_score}" }
  end

  def add_select_to_scope(scope)
    scope.select("
      cars.*,
      brands.name as brand_name,
      CASE
        WHEN upb.brand_id IS NULL THEN -1
        WHEN (
          cars.price BETWEEN
            lower(users.preferred_price_range) AND upper(users.preferred_price_range)
        ) THEN 0
        ELSE 1
      END AS match,
      CASE
        #{recommended_cars_when_cases.join(" ")}
        ELSE 0
      END AS rank_score
    ")
  end

  def add_conditions_to_scope(scope)
    scope = scope.where("brands.name LIKE ?", "%#{args[:query]}%") if args[:query].present?
    scope = scope.where(price: args[:price_min]..) if args[:price_min].present?
    scope = scope.where(price: ..args[:price_max]) if args[:price_max].present?
    scope
  end
end
