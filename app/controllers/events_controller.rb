# frozen_string_literal: true

# Accepts external webhooks containg events
class EventsController < ApplicationController
  def create
    Event.create(json_payload: event_parameters, checked: 'false')
  end

  def event_parameters
    params.require('_json').first.to_s
  end
end
