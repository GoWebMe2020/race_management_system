require 'rails_helper'

RSpec.describe Race, type: :model do
  let!(:student1) { Student.create(name: "Alice") }
  let!(:student2) { Student.create(name: "Bob") }

  context "validations" do
    it "is valid with valid attributes" do
      race = Race.new(name: "100m Dash")

      race.race_participants.build(student: student1, lane: 1)
      race.race_participants.build(student: student2, lane: 2)

      expect(race).to be_valid
    end

    it "is not valid without a name" do
      race = Race.new(name: nil)

      race.race_participants.build(student: student1, lane: 1)
      race.race_participants.build(student: student2, lane: 2)

      expect(race).to_not be_valid
      expect(race.errors[:name]).to include("can't be blank")
    end

    it "is not valid with fewer than 2 participants" do
      race = Race.new(name: "Race with only one participant")

      race.race_participants.build(student: student1, lane: 1)

      expect(race).to_not be_valid
      expect(race.errors[:base]).to include("A race must have at least two participants.")
    end
  end
end
