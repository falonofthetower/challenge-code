# frozen_string_literal: true

# Processes an array of events currently received through the webhook
class EventProcessor
  def call
    Event.match_unchecked.each do |event|
      event.update(
        match: Match.find_by(match_string: match_string(event.json_payload)),
        checked: true
      )
    end
  end

  def match_string(json)
    [].tap do |m|
      Match.match_keys.map do |keys|
        hash = JSON.parse json
        m << hash.dig(*keys)
      end
    end.join('~')
  end
end
