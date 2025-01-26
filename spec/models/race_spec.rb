require 'rails_helper'

RSpec.describe Race, type: :model do
  let!(:student1) { Student.create!(name: "Alice") }
  let!(:student2) { Student.create!(name: "Bob") }
  let!(:student3) { Student.create!(name: "Charlie") }

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

  describe "places_with_no_gaps validation" do
    it "allows partial assignment if not all places are set" do
      race = Race.new(name: "Test Race")
      race.race_participants.build(student: student1, lane: 1, place: 1)
      race.race_participants.build(student: student2, lane: 2)
      race.race_participants.build(student: student3, lane: 3)

      expect(race).to be_valid
    end

    it "is valid when some participants have no place" do
      race = Race.new(name: "DNF Race")
      race.race_participants.build(student_id: 1, lane: 1, place: 1)
      race.race_participants.build(student_id: 2, lane: 2, place: nil)
      race.race_participants.build(student_id: 3, lane: 3, place: 2)
      expect(race).to be_valid
    end

    it "is valid with a correct tie-based sequence" do
      race = Race.new(name: "Tie Race")
      race.race_participants.build(student: student1, lane: 1, place: 1)
      race.race_participants.build(student: student2, lane: 2, place: 1)
      race.race_participants.build(student: student3, lane: 3, place: 3)

      expect(race).to be_valid
    end

    it "is invalid if there is a gap" do
      race = Race.new(name: "Gap Race")
      race.race_participants.build(student: student1, lane: 1, place: 1)
      race.race_participants.build(student: student2, lane: 2, place: 2)
      race.race_participants.build(student: student3, lane: 3, place: 4)

      expect(race).not_to be_valid
      expect(race.errors[:base]).to include("Places must be assigned without gaps. Found a gap at place 4, expected place 3.")
    end
  end
end
