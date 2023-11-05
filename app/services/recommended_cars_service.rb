class RecommendedCarsService
  def self.call(**params)
    new(params).call
  end

  MissinUserIdError = Class.new(::StandardError)

  def initialize(params)
    user_id = params.delete(:user_id)

    raise MissingUserIdError unless user_id

    @params = params
  end

  def call
    # Car.search(params).limit(ITEMS_PER_PAGE).offset(page_number)
  end
end
