# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsProcessor do
  context 'with a single valid event but no matches' do
    it 'moves the event from unchecked to unmatched' do
      event = FactoryBot.create(
        :event,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )

      expect(Event.match_unchecked).to eq [event]
      expect(Event.match_missing).to eq []

      EventsProcessor.call

      expect(Event.match_unchecked).to eq []
      expect(Event.match_missing).to eq [event]
    end
  end

  context 'with a single valid event that has a match' do
    it 'moves event from unchecked to matched' do
      event = FactoryBot.create(
        :event,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )
      plan = FactoryBot.create(:plan, name: 'Athena Silver')
      match_string = 'Deductible Plan~Athena (123 456)'
      FactoryBot.create(:match, plan: plan, match_string: match_string)

      expect(Event.match_unchecked).to eq [event]
      expect(Event.match_missing).to eq []

      EventsProcessor.call

      expect(Event.match_unchecked).to eq []
      expect(Event.match_successful).to eq [event]

      expect(event.reload.plan).to eq plan
    end
  end

  context 'with multiple valid events that have matches' do
    it 'should match each of the events' do
      events = []
      3.times do
        events << FactoryBot.create(
          :event,
          json_payload: {
            'Plan' => { 'Name' => 'Deductible Plan' },
            'Company' => { 'Name' => 'Athena (123 456)' }
          }
        )
      end

      plan = FactoryBot.create(:plan, name: 'Athena Silver')
      match_string = 'Deductible Plan~Athena (123 456)'
      FactoryBot.create(:match, plan: plan, match_string: match_string)

      expect(Event.match_unchecked).to eq events
      expect(Event.match_missing).to be_empty

      EventsProcessor.call

      expect(Event.match_unchecked).to be_empty
      expect(Event.match_successful).to eq events

      events.each do |event|
        expect(event.reload.plan).to eq plan
      end
    end
  end

  context 'with a mix of un/matched in/valid events' do
    it 'should handle each of the events in turn' do
      good_event = FactoryBot.create(
        :event,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )
      unmatchable_event = FactoryBot.create(
        :event,
        json_payload: {
          'Plan' => { 'Name' => 'Unmatchable Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )
      other_good_event = FactoryBot.create(
        :event,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )
      plan = FactoryBot.create(:plan, name: 'Athena Silver')
      match_string = 'Deductible Plan~Athena (123 456)'
      FactoryBot.create(:match, plan: plan, match_string: match_string)

      EventsProcessor.call

      expect(Event.match_unchecked).to be_empty
      expect(Event.match_successful).to eq [good_event, other_good_event]
      expect(Event.match_missing).to eq [unmatchable_event]

      expect(good_event.reload.plan).to eq plan
    end
  end

  context 'with an invalid event' do
    it 'should reject the event' do
      FactoryBot.create(
        :event,
        json_payload: {}
      )

      expect(MatchMaker).not_to receive(:call)
    end
  end
end
