RSpec.describe User do
  subject(:model) { build(:user) }

  describe "associations" do
    it { is_expected.to have_many(:user_preferred_brands).dependent(:destroy) }

    it "has_many preferred_brands" do
      expect(model)
        .to have_many(:preferred_brands).through(:user_preferred_brands).source(:brand)
    end
  end
end
