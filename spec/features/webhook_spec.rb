# frozen_string_literal: true

require 'rails_helper'

feature 'payload submission', type: :feature do
  scenario 'a single payload is sent to the webhook' do
    fixture_path = "#{Rails.root}/spec/fixtures/webhooks/single.json"
    fixture_string = JSON.parse(File.read(fixture_path))['body'].first

    fake_redox_webhook('single').send

    event = Event.first

    expect(event.json_payload).to eq fixture_string
    expect(event.checked).to eq false
    expect(event.malformed?).to be_falsey
  end

  scenario 'a single malformed payload is sent to the webhook' do
    fixture_path = "#{Rails.root}/spec/fixtures/webhooks/bad.json"
    fixture_string = JSON.parse(File.read(fixture_path))['body'].first

    fake_redox_webhook('bad').send

    event = Event.first

    expect(event.json_payload).to eq fixture_string
    expect(event.checked).to eq false
    expect(event.malformed?).to be_truthy
    expect(event.match_status).to eq 'malformed'
  end

  scenario 'multiple payloads are sent to the webhook' do
    fixture_path = "#{Rails.root}/spec/fixtures/webhooks/three.json"
    fixture_strings = JSON.parse(File.read(fixture_path))['body']

    fake_redox_webhook('three').send

    events = Event.all

    events.each_with_index do |e, i|
      expect(e.json_payload).to eq fixture_strings[i]
      expect(e.checked).to eq false
      expect(e.malformed?).to be_falsey
    end
  end

  def fake_redox_webhook(fixture)
    FakeRedoxWebhook.new(
      fixture: "#{fixture}.json",
      host: Capybara.current_session.server.host,
      path: '/events',
      port: Capybara.current_session.server.port
    )
  end
end
