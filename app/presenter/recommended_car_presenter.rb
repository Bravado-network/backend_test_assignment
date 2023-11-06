# frozen_string_literal: true

class RecommendedCarPresenter
  def initialize(object)
    @object = object
  end

  def as_json(*)
    @object.except('_score', '_explanation', 'user_id')
  end
end
