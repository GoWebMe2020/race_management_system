class Race < ApplicationRecord
  # Associations
  # A race has many participants, and destroying a race will also destroy its participants.
  has_many :race_participants, dependent: :destroy

  # A race is associated with many students through its participants.
  has_many :students, through: :race_participants

  # Validations
  # Ensure the race has a name.
  validates :name, presence: true

  # Custom validation to ensure the race has at least two participants.
  validate :must_have_minimum_two_participants

  # Custom validation to ensure there are no gaps in the assigned places for participants.
  validate :places_with_no_gaps

  # Allow nested attributes for race participants.
  # This enables creating or updating participants directly through the race form.
  accepts_nested_attributes_for :race_participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  private

  # Custom Validation: Ensure the race has at least two participants.
  # Adds an error if there are fewer than two participants in the race.
  def must_have_minimum_two_participants
    if race_participants.size < 2
      errors.add(:base, "A race must have at least two participants.")
    end
  end

  # Custom Validation: Ensure there are no gaps in the assigned places for participants.
  # Validates that places assigned to participants are consecutive, starting from 1.
  # Adds an error if there are missing or duplicate places.
  def places_with_no_gaps
    # Extract the sorted list of places, excluding nil/blank entries.
    places = race_participants.map(&:place).compact.sort

    # Skip validation if there are no places to validate.
    return if places.empty?

    # Count occurrences of each place.
    place_counts = places.tally

    # Check for gaps in the sequence of places.
    expected_place = 1
    place_counts.keys.sort.each do |current_place|
      if current_place != expected_place
        errors.add(:base, "Places must be assigned without gaps. "\
                          "Found a gap at place #{current_place}, expected place #{expected_place}.")
        return
      end
      # Increment the expected place, accounting for ties.
      expected_place += place_counts[current_place]
    end
  end
end
