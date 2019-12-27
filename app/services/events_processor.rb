# frozen_string_literal: true

# Processes an array of events currently received through the webhook
class EventsProcessor
  def call
    Event.match_unchecked.each do |event|
      ProcessEvent.new(event).call
    end
  end
end
