# frozen_string_literal: true

# A record of each event that is supplied to the webhook by the provider
class Event < ApplicationRecord
  belongs_to :match, optional: true
  has_one :plan, through: :match

  enum match_status: {
    successful: 'successful',
    unchecked: 'unchecked',
    missing: 'missing',
    malformed: 'malformed'
  }

  scope :valid, -> { where(json_errors: false) }
  scope :invalid, -> { where(json_errors: true) }

  scope :match_unchecked, -> { where(match_status: 'unchecked') }
  scope :match_missing, -> { where('match_status = ? AND match_id IS NULL', 'missing') }
  scope :match_successful, -> { where('match_status = ? AND match_id IS NOT NULL', 'successful') }

  def malformed?
    !validator.valid?
  end

  private

  def payload
    JSON.parse(json_payload.to_json)
  end

  def validator
    HashValidator.validate(payload, validations)
  end

  def validations
    {
      'Plan' => {
        'Name' => 'string'
      },
      'Company' => {
        'Name' => 'string'
      }
    }
  end
end
