# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'haml-rails'
gem 'jbuilder' # TODO: remove the couple of templates using it
gem 'mini_racer'
gem 'pg'
gem 'rails', '< 6.1' # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'react-rails', '~> 2.4'
gem 'sassc-rails'
gem 'uglifier' # Use Uglifier as compressor for JavaScript assets
gem 'unicorn'
gem 'unicorn-worker-killer'
gem 'webpacker', '4.2.2'

gem 'rails-html-sanitizer', '~> 1.3.0' # Force this version after CVE-2018-8048
gem 'sprockets'

gem 'devise', '~> 4.7.1' # Authentication
gem 'draper'
gem 'lograge' # Lograge for more compact log files
gem 'simple_form' # Form helper

gem 'dry_crud'
gem 'friendly_id'

gem 'gibbon', '~> 3.2' # MailChimp API
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'scout_apm'

gem 'cookies_eu', '~> 1.6' # cookies policy

gem 'sidekiq', '< 6' # Async queue

group :development, :test do
  gem 'bullet'
  gem 'byebug', platform: :mri
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0.beta4'
  gem 'ruby-prof'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'simplecov', '~>0.17.0', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.2.0'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :lint do
  gem 'brakeman', require: false # A static analysis security vulnerability scanner
  gem 'bundler-audit' # Check dependencies
  gem 'haml-lint', require: false # Syntax checker for HAML
  gem 'overcommit', require: false # hook event pre-commit, pre-push
  gem 'rubocop', require: false # A Ruby static code analyzer
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'ruby_css_lint', require: false # Syntax checker for CSS
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

ruby '2.7.0'
