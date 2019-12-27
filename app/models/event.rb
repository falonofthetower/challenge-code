# frozen_string_literal: true

# A record of each event that is supplied to the webhook by the provider
# The event is stored here as a raw record prior to being processed. It includes
# an understanding of having state where it knows whether it is well-formed,
# already process or matched. Doing so allows for more efficient querying.
class Event < ApplicationRecord
  belongs_to :match, optional: true
  has_one :plan, through: :match

  enum match_status: {
    successful: 'successful',
    unchecked: 'unchecked',
    missing: 'missing',
    malformed: 'malformed'
  }

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

  # There was something of a presumption in the challenge that the payload would
  # be perfectly defined and everything would be present. One could describe
  # this as my belief in trust but verify.This isn't really intended as a full
  # fledged validation solution, more an example of where it could fit into the
  # design. At minimum the keys we require are here.
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
