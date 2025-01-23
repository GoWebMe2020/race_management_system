require 'rails_helper'

RSpec.describe Race, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      race = Race.new(name: "100m Dash")
      expect(race).to be_valid
    end

    it "is not valid without a name" do
      race = Race.new(name: nil)
      expect(race).to_not be_valid
    end
  end
end
