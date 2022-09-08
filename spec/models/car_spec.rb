RSpec.describe Car do
  subject(:model) { build(:car) }

  describe "associations" do
    it { is_expected.to belong_to(:brand) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:model) }
  end
end
