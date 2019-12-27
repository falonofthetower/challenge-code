# frozen_string_literal: true

# Accepts external webhooks containg events
class EventsController < ApplicationController
  def create
    JSON.parse(request.body.read).each do |payload|
      Event.new(json_payload: payload).tap do |event|
        event.match_status = event.malformed? ? 'malformed' : 'unchecked'
        event.save
      end
    end
  end
end
