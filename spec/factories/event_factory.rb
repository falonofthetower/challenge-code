# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    payload { { 'John' => 'new' }.to_json }
  end
end
