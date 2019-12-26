# frozen_string_literal: true

# Models the master list of available plans
class Plan < ApplicationRecord
  has_many :matches
  has_many :events, through: :matches
end
