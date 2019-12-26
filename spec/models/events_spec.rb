# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event do
  context '.match_unchecked' do
    it 'returns only events where checked is false' do
      Event.create(checked: true)
      unchecked = Event.create(checked: false)

      expect(Event.match_unchecked).to eq [unchecked]
    end
  end

  context '.match_missing' do
    it 'returns the events where a match has been attempted and failed' do
      missing_match = Event.create(checked: true, match_id: nil)

      Event.create(checked: true, match_id: 1)
      Event.create(checked: false)

      expect(Event.match_missing).to eq [missing_match]
    end
  end

  context '.match_successful' do
    it 'returns the matches that have been made' do
      Event.create(checked: true, match_id: nil)

      matched = Event.create(checked: true, match_id: 1)
      Event.create(checked: false)

      expect(Event.match_successful).to eq [matched]
    end
  end
end
