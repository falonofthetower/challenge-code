# frozen_string_literal: true

# spec/support/capybara.rb
RSpec.configure do
  # config.before(:each, type: :feature) do
  #   driven_by :rack_test
  # end

  Capybara.default_driver = :selenium_chrome_headless
  # config.before(:each, type: :feature, js: true) do
  #   driven_by :selenium_chrome_headless
  # end
end
