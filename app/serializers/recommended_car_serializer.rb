class RecommendedCarSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :brand
  attributes :price
  attributes :rank_score, :label

  alias user scope
  alias car object

  def rank_score
    # TODO
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
end
