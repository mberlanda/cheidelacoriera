# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

# rubocop:disable Lint/SuppressedException
begin
  FactoryBot.find_definitions
rescue FactoryBot::DuplicateDefinitionError
end
# rubocop:enable Lint/SuppressedException
