# frozen_string_literal: true

# Processes a single event
# The heart and soul. This is where incoming events are compared to existing
# matches.
class MatchMaker < ApplicationService
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def call
    event.update(match_status: status, match: match)
  end

  # This extracts the string we are going to search for into the database.
  # It is probably one of the more fixed portions of the code because once you
  # have extracted it in this way it is preserved in the database. If necessary
  # one could always rebuild all of the matches by rebuilding a new match_string
  # with different keys. It would not be ideal, but doable.
  def match_string
    [].tap do |pieces|
      Match.match_keys.map do |keys|
        pieces << json.dig(*keys)
      end
    end.join('~')
  end

  private

  def status
    match ? 'successful' : 'missing'
  end

  def match
    Match.find_by(match_string: match_string)
  end

  def json
    event.json_payload
  end
end
