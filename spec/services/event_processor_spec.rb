# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventProcessor do
  context 'with a single valid event but no matches' do
    it 'moves the event from unchecked to unmatched' do
      event = FactoryBot.create(
        :event,
        checked: false,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }.to_json
      )

      expect(Event.match_unchecked).to eq [event]
      expect(Event.match_missing).to eq []

      EventProcessor.new.call

      expect(Event.match_unchecked).to eq []
      expect(Event.match_missing).to eq [event]
    end
  end

  context 'with a single valid event that has a match' do
    it 'moves event from unchecked to matched' do
      event = FactoryBot.create(
        :event,
        checked: false,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }.to_json
      )
      plan = FactoryBot.create(:plan, name: 'Athena Silver')
      match_string = 'Deductible Plan~Athena (123 456)'
      FactoryBot.create(:match, plan: plan, match_string: match_string)

      expect(Event.match_unchecked).to eq [event]
      expect(Event.match_missing).to eq []

      EventProcessor.new.call

      expect(Event.match_unchecked).to eq []
      expect(Event.match_successful).to eq [event]

      expect(event.reload.plan).to eq plan
    end
  end
end
