# frozen_string_literal: true

# Processes a single event
# The heart and soul. This is where incoming events are compared to existing
# matches.
class MatchMaker
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def call
    event.update(match_status: status, match: match)
  end

  private

  def status
    match ? 'successful' : 'missing'
  end

  def match
    Match.find_by(match_string: match_string)
  end

  def match_string
    [].tap do |m|
      Match.match_keys.map do |keys|
        m << json.dig(*keys)
      end
    end.join('~')
  end

  def json
    event.json_payload
  end
end
