# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessEvent do
  context 'with a valid event' do
    ProcessEvent.new(payload).call
  end
end
