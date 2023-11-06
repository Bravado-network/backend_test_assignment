require 'rails_helper'

RSpec.describe RecommendedCarsFinderService do
  describe '#initialize' do
    it 'assigns the `@params`' do
      finder = described_class.new(user_id: 1, price_min: 30_000, price_max: 40_000, query: 'bmw')

      expect(finder.params).not_to be_nil
    end
  end

  describe '#call' do
    it 'raises an error when the user ID is missing' do
      expect { described_class.new.call }.to raise_error(RecommendedCarsFinder::MissingUserIdError)
    end

    it 'filters by the `params[:user_id]`' do
      params = { user_id: 1 }
      index = double(RecommendedCarsIndex)

      allow(RecommendedCarsIndex).to receive(:filter).and_return(index)
      allow(index).to receive(:order)

      described_class.new(params).call

      expect(RecommendedCarsIndex).to have_received(:filter).with(term: { user_id: params[:user_id] })
    end

    it 'searches for car brand name, or part of it, when `params[:query]` is set' do
      brand_name = 'bmw'
      params = { user_id: 1, query: brand_name }
      index = double(RecommendedCarsIndex)
      index_query = double('query')

      allow(RecommendedCarsIndex).to receive(:filter).and_return(index)
      allow(index).to receive(:query).and_return(index_query)
      allow(index_query).to receive(:order)

      described_class.new(params).call

      expect(RecommendedCarsIndex).to have_received(:filter).with(term: { user_id: params[:user_id] })
      expect(index).to have_received(:query).with({ wildcard: { 'brand.name' => '*bmw*' } })
    end

    it 'searches by the minimum price when `params[:price_min]` is set' do
      params = { user_id: 1, price_min: 30_000 }
      index = double(RecommendedCarsIndex)
      index_query = double('query')

      allow(RecommendedCarsIndex).to receive(:filter).and_return(index)
      allow(index).to receive(:query).and_return(index_query)
      allow(index_query).to receive(:order)

      described_class.new(params).call

      expect(RecommendedCarsIndex).to have_received(:filter).with(term: { user_id: params[:user_id] })
      expect(index).to have_received(:query).with({ range: { price: { gte: 30_000 } } })
    end

    it 'searches by the maximum price when `params[:price_max]` is set' do
      params = { user_id: 1, price_max: 30_000 }
      index = double(RecommendedCarsIndex)
      index_query = double('query')

      allow(RecommendedCarsIndex).to receive(:filter).and_return(index)
      allow(index).to receive(:query).and_return(index_query)
      allow(index_query).to receive(:order)

      described_class.new(params).call

      expect(RecommendedCarsIndex).to have_received(:filter).with(term: { user_id: params[:user_id] })
      expect(index).to have_received(:query).with({ range: { price: { lte: 30_000 } } })
    end

    it 'orders the results by `label`, `rank_score` and `price`' do
      params = { user_id: 1, price_max: 30_000 }
      index = double(RecommendedCarsIndex)
      index_query = double('query')
      sorting_params = { label: { missing: '_last', order: :desc }, price: { order: :asc },
                         rank_score: { order: :desc } }

      allow(RecommendedCarsIndex).to receive(:filter).and_return(index)
      allow(index).to receive(:query).and_return(index_query)
      allow(index_query).to receive(:order)

      described_class.new(params).call

      expect(RecommendedCarsIndex).to have_received(:filter).with(term: { user_id: params[:user_id] })
      expect(index_query).to have_received(:order).with(sorting_params)
    end
  end
end
