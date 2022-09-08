RSpec.describe Brand do
  subject(:model) { build(:brand) }

  describe "associations" do
    it { is_expected.to have_many(:cars).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
