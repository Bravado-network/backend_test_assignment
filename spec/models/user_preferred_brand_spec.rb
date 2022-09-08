RSpec.describe UserPreferredBrand do
  subject(:model) { build(:user_preferred_brand) }

  describe "associations" do
    it { is_expected.to belong_to(:brand) }
    it { is_expected.to belong_to(:user) }
  end
end
