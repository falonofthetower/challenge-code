# frozen_string_literal: true

# Base class for services
# https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial
# I like this pattern. It creates a single simple rubyesque interface. I am not
# a fan of having a multitude of different patterns running around.
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
