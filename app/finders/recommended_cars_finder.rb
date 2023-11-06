# frozen_string_literal: true

class RecommendedCarsFinder
  MissingUserIdError = Class.new(::StandardError)

  def initialize(params = {})
    @params = params
  end

  def call
    user_id, price_min, price_max, query = params.values_at(:user_id, :price_min, :price_max, :query)

    raise MissingUserIdError unless user_id

    scope = RecommendedCarsIndex.filter(term: { user_id: user_id })

    # <car brand name or part of car brand name to filter by (optional)>
    scope = scope.query(wildcard: { 'brand.name' => "*#{query}*" }) if query
    # <minimum price (optional)>
    scope = scope.query(range: { price: { gte: price_min } }) if price_min
    # <maximum price (optional)>
    scope = scope.query(range: { price: { lte: price_max } }) if price_max
    # Cars should be sorted by:
    #   - label (perfect_match, good_match, null)
    #   - rank_score (DESC)
    #   - price (ASC)
    scope.order(
      label: { order: :desc, missing: '_last' },
      rank_score: { order: :desc },
      price: { order: :asc }
    )
  end

  private

  attr_reader :params
end
