class Race < ApplicationRecord
  has_many :race_participants, dependent: :destroy
  has_many :students, through: :race_participants

  validates :name, presence: true
  validate :must_have_minimum_two_participants

  accepts_nested_attributes_for :race_participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  private

  def must_have_minimum_two_participants
    if race_participants.size < 2
      errors.add(:base, "A race must have at least two participants.")
    end
  end
end
