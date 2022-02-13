# frozen_string_literal: true

# Model for tours data
class Tour < ApplicationRecord
  belongs_to :operator

  # Validation for :name, :starting_hour, :starting_minute, :length
  validates_presence_of :name, :starting_hour, :starting_minute, :length

  # Validation for starting_hour so that we have valid hours
  validates :starting_hour, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }

  # Validation for starting_minute so that we have valid starting minute
  validates :starting_minute, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }

  # Validate that repeating_weekdays and repeating_weekday_no should be absent if non recurring
  validates_absence_of :repeating_weekdays, :repeating_weekday_no, if: :non_recurring?

  # Validate that dates should be absent if recurring
  validates_absence_of :dates, if: :recurring?

  # Validate that repeating_weekdays and repeating_weekday_no should be presence if recurring
  validates_presence_of :repeating_weekdays, :repeating_weekday_no, if: :recurring?

  # Validate that dates should be absent if non recurring
  validates_presence_of :dates, if: :non_recurring?

  def non_recurring?
    !recurring
  end

  def recurring?
    recurring
  end
end
