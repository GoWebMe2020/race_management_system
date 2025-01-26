class RaceParticipant < ApplicationRecord
  # Associations
  # A race participant belongs to a specific race and student.
  belongs_to :race
  belongs_to :student

  # Validations
  # Ensure the lane is present.
  validates :lane, presence: true

  # Allow place to be nil, but if provided, it must be a positive integer.
  validates :place, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }

  # Ensure lane numbers are unique within the scope of a race.
  # This prevents multiple participants from being assigned the same lane in the same race.
  validates :lane, uniqueness: { scope: :race_id }

  # Ensure a student can only participate in a given race once.
  validates :student_id, uniqueness: { scope: :race_id }
end
