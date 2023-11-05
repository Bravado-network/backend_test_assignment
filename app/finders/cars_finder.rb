# frozen_string_literal: true

class CarsFinder
  def self.call(**params)
    new(params).call
  end

  DEFAULT_PAGE = 1
  ITEMS_PER_PAGE = 20

  def initialize(params)
    @params = params
  end

  def call
    Car.search(params).limit(ITEMS_PER_PAGE).offset(page_number)
  end

  private

  attr_reader :params

  def page_number
    (params[:page] || DEFAULT_PAGE) - 1
  end
end
