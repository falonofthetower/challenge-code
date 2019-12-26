# frozen_string_literal: true

require 'rails_helper'

feature 'payload submission', type: :feature do
  scenario 'a single payload is sent to the webhook' do
    fixture_path = "#{Rails.root}/spec/fixtures/webhooks/single.json"
    fixture_string = JSON.parse(File.read(fixture_path))['body'].first.to_s

    fake_redox_webhook('single').send

    event = Event.first

    expect(event.json_payload).to eq fixture_string
    expect(event.checked).to eq false
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
