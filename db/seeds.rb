# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if ENV['RAILS_DB_SEED']
  [
    %w[admin active],
    %w[fan pending]
  ].each do |role, status|
    User.create!(
      first_name: role.capitalize,
      last_name: status.capitalize,
      phone_number: 1_234_567_890,
      email: "#{status}-#{role}@test.com",
      password: 'testtest',
      password_confirmation: 'testtest',
      role:,
      status:
    )
  end
end
