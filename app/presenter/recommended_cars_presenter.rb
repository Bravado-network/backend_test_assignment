# frozen_string_literal: true

class RecommendedCarsPresenter
  def initialize(objects)
    @objects = JSON.parse(objects.to_json)
  end

  def as_json(*)
    @objects.map { |object| RecommendedCarPresenter.new(object['attributes']) }
  end
end
