# frozen_string_literal: true

# Create Operators
class CreateOperators < ActiveRecord::Migration[7.0]
  def change
    create_table :operators do |t|
      t.string :name
      t.string :email
      t.string :country

      t.timestamps
    end
  end
end
