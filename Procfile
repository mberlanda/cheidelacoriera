web: bundle exec unicorn -C config/unicorn.rb
release: rake db:migrate
worker: bundle exec sidekiq -e production -C config/sidekiq.yml
