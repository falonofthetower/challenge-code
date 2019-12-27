# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    json_payload { { 'John' => 'new' } }
    match_status { 'unchecked' }
  end

  trait :unchecked do
    match_status { 'unchecked' }
  end

  trait :successful do
    match_status { 'successful' }
    match { FactoryBot.create(:match, plan: FactoryBot.create(:plan)) }
  end

  trait :missing do
    match_status { 'missing' }
  end

  trait :malformed do
    match_status { 'malformed' }
  end
end
