# frozen_string_literal: true

# Processes an array of events currently received through the webhook
# Most likely this gets kicked off by sidekiq, or processes events off of
# RabbitMQ or some other async setup. Might even be able to abandon this with
# Rabbit
class EventsProcessor
  def call
    Event.match_unchecked.each do |event|
      MatchMaker.new(event).call
    end
  end
end
