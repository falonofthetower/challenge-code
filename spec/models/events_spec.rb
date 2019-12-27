# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event do
  context '.match_unchecked' do
    it 'returns only events where match is unchecked is false' do
      FactoryBot.create(:event, :successful)
      unchecked = FactoryBot.create(:event, :unchecked)

      expect(Event.match_unchecked).to eq [unchecked]
    end
  end

  context '.match_missing' do
    it 'returns the events where a match has been attempted and failed' do
      missing_match = FactoryBot.create(:event, :missing)

      FactoryBot.create(:event, :successful)
      FactoryBot.create(:event)

      expect(Event.match_missing).to eq [missing_match]
    end
  end

  context '.match_successful' do
    it 'returns the matches that have been made' do
      FactoryBot.create(:event, :missing)

      matched = FactoryBot.create(:event, :successful)
      FactoryBot.create(:event, :unchecked)

      expect(Event.match_successful).to eq [matched]
    end
  end

  describe '.malformed?' do
    it 'returns falsey for an event that matches the given schema' do
      event = FactoryBot.create(:event, :unchecked, json_payload: {})

      expect(event.malformed?).to be_truthy
    end

    it 'returns truthy for an event that does not match the given schema' do
      event = FactoryBot.create(
        :event,
        :unchecked,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )

      expect(event.malformed?).to be_falsey
    end
  end
end
