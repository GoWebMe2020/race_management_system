class Student < ApplicationRecord
  # Associations
  # A student can participate in many races through the race_participants join table.
  has_many :race_participants
  has_many :races, through: :race_participants

  # Validations
  # Ensure every student has a name.
  validates :name, presence: true
end
