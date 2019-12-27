# frozen_string_literal: true

# Accepts external webhooks containg events
class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    JSON.parse(request.body.read).each do |payload|
      Event.new(json_payload: payload).tap do |event|
        event.match_status = event.malformed? ? 'malformed' : 'unchecked'
        event.save
      end
    end
    render json: :ok
  end
end
