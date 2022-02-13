# frozen_string_literal: true

class Operator < ApplicationRecord
  has_many :tours

  validates_presence_of :name, :email, :country
  validates_uniqueness_of :email
end
