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

  # Validate that it should not have clash on operator level
  validate :one_tour_at_a_time

  def non_recurring?
    !recurring
  end

  def recurring?
    recurring
  end

  private

  def one_tour_at_a_time
    clashing_tour = Tour.where(operator: operator).select do |tour|
      if starting_timestamp >= tour.starting_timestamp && ending_timestamp <= tour.ending_timestamp
        if tour.dates.present? && dates.present? && (tour.dates & dates).present?
          true
        elsif (repeating_weekdays & tour.repeating_weekdays).present? && repeating_weekday_no == tour.repeating_weekdays
          true
        end
      end
    end.first

    errors.add(:base, "This tour can't be created since it has clash with #{clashing_tour.name} tour") if clashing_tour
  end

  def ending_hour_minute
    hour = length / 60
    minutes = length % 60

    if minutes + starting_minute >= 60
      diff = minutes + starting_minute - 60
      [(hour + starting_hour + 1), diff]
    else
      [(hour + starting_hour), (minutes + starting_minute)]
    end
  end

  def starting_timestamp
    "#{starting_hour}#{starting_minute}".to_i
  end

  def ending_timestamp
    ending_hour, ending_minute = ending_hour_minute
    "#{ending_hour}#{ending_minute}".to_i
  end
end
