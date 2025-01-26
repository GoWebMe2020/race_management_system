class RaceParticipant < ApplicationRecord
  belongs_to :race
  belongs_to :student

  validates :lane, presence: true
  validates :place, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }

  validates :lane, uniqueness: { scope: :race_id }
  validates :student_id, uniqueness: { scope: :race_id }
end
