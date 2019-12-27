# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessEvent do
  context 'with a valid matchable event' do
    it 'sets the event to checked' do
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

      ProcessEvent.new(event).call

      expect(event.match_status).to eq 'successful'
    end

    it 'connects the event to a match' do
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
      ProcessEvent.new(event).call

      expect(event.plan).to eq plan
    end
  end

  context 'when no match is available' do
    it 'sets the event to checked' do
      event = FactoryBot.create(
        :event,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )

      ProcessEvent.new(event).call

      expect(event.match_status).to eq 'missing'
    end

    it 'leaves the match unset' do
      event = FactoryBot.create(
        :event,
        json_payload: {
          'Plan' => { 'Name' => 'Deductible Plan' },
          'Company' => { 'Name' => 'Athena (123 456)' }
        }
      )

      ProcessEvent.new(event).call

      expect(event.plan).to be_nil
    end
  end
end
