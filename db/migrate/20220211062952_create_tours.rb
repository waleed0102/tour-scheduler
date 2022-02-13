# frozen_string_literal: true

# Create Tours
# rubocop:disable Metrics/MethodLength
class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table   :tours do |t|
      t.references :operator, foreign_key: true
      t.string     :name, null: false
      t.boolean    :recurring, default: false # Either one time tour or recurring tour
      t.string     :repeating_weekdays, array: true, default: [] # Like repeat every monday and tuesday
      t.integer    :repeating_weekday_no, default: 0 # Like repeat every second monday of month
      t.string     :dates, array: true, default: [] # For one time events
      t.integer    :starting_hour, null: false
      t.integer    :starting_minute, null: false
      t.integer    :length, null: false # In minutes

      t.timestamps
    end
  end
end
# rubocop:enable Metrics/MethodLength
