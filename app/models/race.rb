class Race < ApplicationRecord
  has_many :race_participants, dependent: :destroy
  has_many :students, through: :race_participants

  validates :name, presence: true
  validate :must_have_minimum_two_participants
  validate :places_with_no_gaps

  accepts_nested_attributes_for :race_participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  private

  def must_have_minimum_two_participants
    if race_participants.size < 2
      errors.add(:base, "A race must have at least two participants.")
    end
  end

  def places_with_no_gaps
    return if race_participants.any? { |rp| rp.place.blank? }

    places = race_participants.map(&:place).sort

    place_counts = places.tally

    expected_place = 1

    place_counts.keys.sort.each do |current_place|
      if current_place != expected_place
        errors.add(:base, "Places must be assigned without gaps. "\
                          "Found a gap at place #{current_place}, expected place #{expected_place}.")
        return
      end
      expected_place += place_counts[current_place]
    end
  end
end
