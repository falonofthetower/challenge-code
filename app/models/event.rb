# frozen_string_literal: true

# A record of each event that is supplied to the webhook by the provider
class Event < ApplicationRecord
  belongs_to :match, optional: true
  has_one :plan, through: :match

  enum match_state: {
    successful: 'successful',
    unchecked: 'unchecked',
    missing: 'missing'
  }

  scope :match_unchecked, -> { where('checked = ?', 'false') }
  scope :match_missing, -> { where('checked = ? AND match_id IS NULL', 'true') }
  scope :match_successful, -> { where('match_id IS NOT NULL') }
end
