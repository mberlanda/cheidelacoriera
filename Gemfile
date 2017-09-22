source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2' # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg', '~> 0.18' # Use postgresql as the database for Active Record
gem 'puma', '~> 3.0' # Use Puma as the app server
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.2' # Use CoffeeScript for .coffee assets and views
gem 'therubyracer', platforms: :ruby # See https://github.com/rails/execjs#readme for more supported runtimes
gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'haml-rails', '~> 0.9'

gem 'drape', '~> 1.0.0.beta1'
gem 'devise', '~> 4.2'  # Authentication
gem 'simple_form', '~> 3.4' # Form helper
gem 'lograge', '~> 0.5.1' # Lograge for more compact log files

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.1.0', platform: :mri
  gem 'rspec-rails', '~> 3.6.0'
  gem 'rails-controller-testing', '1.0.2'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'ffaker', '~> 2.5.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :lint do
  gem 'overcommit', '~> 0.41', require: false  # hook event pre-commit, pre-push
  gem 'brakeman', '~> 3.7.2', require: false  # A static analysis security vulnerability scanner
  gem 'haml-lint', '~> 0.26', require: false  # Syntax checker for HAML
  gem 'ruby_css_lint', '~> 0.1', require: false  # Syntax checker for CSS
  gem 'rubocop', '~> 0.50', require: false  # A Ruby static code analyzer
  gem 'bundler-audit', '~> 0.6'  # Check dependencies
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.4.0'
