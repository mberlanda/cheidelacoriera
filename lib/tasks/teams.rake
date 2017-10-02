# frozen_string_literal: true

namespace :teams do
  desc 'Serie A 2017/2018 Teams data'
  task seriea20172018: :environment do
    fp = Rails.root.join('data', 'teams_seriea_20172018.json')
    teams = JSON.parse(File.read(fp), symbolize_names: true).fetch(:teams)

    before_count = Team.count
    teams.each { |t| Team.create(**t) {} }
    after_count = Team.count

    puts "#{after_count - before_count} out of #{teams.count} teams created"
  end
end
