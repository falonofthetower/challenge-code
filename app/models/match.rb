# frozen_string_literal: true

# The objective of this exercise. This holds the shape of the match that
# identifies a new event that should be paired with a plan.
# The match_keys are currently hard coded but they represent a flexible way to
# identify the relevant keys to build a match from. These keys could be saved to
# the database creating a dynamic configuration.
class Match < ApplicationRecord
  belongs_to :plan
  has_many :events

  # This would be provider based once you have multiple formats of supplied
  # data to match against
  def self.match_keys
    [%w[Plan Name], %w[Company Name]]
  end
end
