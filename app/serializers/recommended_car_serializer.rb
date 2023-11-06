# frozen_string_literal: true

class RecommendedCarSerializer < ActiveModel::Serializer
  alias user scope
  alias car object

  attributes :id
  belongs_to :brand
  attributes :price
  attributes :rank_score, :label
  attributes :model
  attributes :user_id

  def user_id
    user.id
  end

  def rank_score
    fetch_rank_score || nil
  end

  def label
    verify_label || nil
  end

  private

  def good_matching?
    user.preferred_brands.exists?(car.brand.id)
  end

  def perfetct_macthing?
    good_matching? && user.preferred_price_range.include?(car.price)
  end

  def verify_label
    return 'perfect_match' if perfetct_macthing?

    'good_match' if good_matching?
  end

  def fetch_rank_score
    car_rank = CarRankingsIndex.filter(term: { user_id: user_id })
                               .filter(term: { car_id: car.id })
                               .first&.attributes

    car_rank&.dig('rank_score')
  end
end
