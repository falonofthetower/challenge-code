# frozen_string_literal: true

# The objective of this exercise. This holds the shape o
# 
class Match < ApplicationRecord
  belongs_to :plan
  has_many :events

  def self.match_keys
    [%w[Plan Name], %w[Company Name]]
  end
end
