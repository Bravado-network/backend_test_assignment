class Api::V1::CarOffersController < ActionController::API
  def index
    offers = CarOffersFetcher.new(fetch_params).fetch
    render json: offers
  end

  private

  def fetch_params
    params.permit(*%i[user_id query price_min price_max page]).tap do |permited_params|
      permited_params.require(:user_id)
    end
  end
end
