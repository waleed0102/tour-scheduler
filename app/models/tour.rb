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
  validates_absence_of :repeating_weekdays, if: :non_recurring?

  # Validate that dates should be absent if recurring
  validates_absence_of :dates, if: :recurring?

  # Validate that repeating_weekdays and repeating_weekday_no should be presence if recurring
  validates_presence_of :repeating_weekdays, if: :recurring?

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
    "#{starting_hour}:#{starting_minute}"
  end

  def ending_timestamp
    ending_hour, ending_minute = ending_hour_minute
    "#{ending_hour}:#{ending_minute}"
  end

  def self.time_overlap?(tour_a, tour_b)
    (Time.parse(tour_a.starting_timestamp)..Time.parse(tour_a.ending_timestamp)) &
      (Time.parse(tour_b.starting_timestamp)..Time.parse(tour_b.ending_timestamp))
  end

  def self.weekdays_overlap?(tour_a, tour_b)
    (tour_a.repeating_weekdays & tour_b.repeating_weekdays).present? &&
      tour_a.repeating_weekday_no == tour_b.repeating_weekday_no
  end

  private

  def one_tour_at_a_time
    clashing_tour = Tour.where(operator: operator).select do |tour|
      if Tour.time_overlap?(self, tour)
        if tour.dates.present? && dates.present? && (tour.dates & dates).present?
          true
        elsif Tour.weekdays_overlap?(self, tour)
          true
        end
      end
    end.first

    errors.add(:base, "This tour can't be created since it has clash with #{clashing_tour.name} tour") if clashing_tour
  end
end
