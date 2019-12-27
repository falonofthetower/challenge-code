# frozen_string_literal: true

# app/services/fake_redox_webhook.rb
require 'faraday'

# https://thoughtbot.com/blog/use-faraday-to-test-incoming-webhooks
# This project required whipping up something to fake the incoming webhook
# requests. I didn't do much evaluation here besides it being a convenient leg
# up.
class FakeRedoxWebhook
  def initialize(fixture:, path:, port: nil, host: nil)
    @fixture = fixture
    @path = path
    @port = port || capybara_port
    @host = host || capybara_host
    load_fixture
    construct_connection
  end

  def send
    connection.post do |request|
      request.url path
      request.headers = headers
      request.body = JSON.generate(body)
    end
  end

  private

  def capybara_port
    Capybara.current_session.server.port
  end

  def capybara_host
    Capybara.current_session.server.host
  end

  attr_accessor(
    :body,
    :connection,
    :fixture,
    :headers,
    :path,
    :session
  )

  def construct_connection
    @connection = Faraday.new(url: "http://#{@host}:#{@port}")
  end

  def fixture_path
    "#{Rails.root}/spec/fixtures/webhooks/#{fixture}"
  end

  def load_fixture
    fixture_json = JSON.parse(File.read(fixture_path))

    @headers = fixture_json.fetch('headers')
    @body = fixture_json.fetch('body')
  end
end
