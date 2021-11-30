# cheidelacoriera

[![Build Status](https://travis-ci.org/mberlanda/cheidelacoriera.svg?branch=master)](https://travis-ci.org/mberlanda/cheidelacoriera)
[![Maintainability](https://api.codeclimate.com/v1/badges/19dac7a302ec55f5cd95/maintainability)](https://codeclimate.com/github/mberlanda/cheidelacoriera/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/19dac7a302ec55f5cd95/test_coverage)](https://codeclimate.com/github/mberlanda/cheidelacoriera/test_coverage)

This Rails application aims to become a management system for away fans.

It should include two levels of users:
- administrators: can create new events, set the amount of seats/tickets, export list of participants for every event
- fans: can register for a match

In terms of models, it should include:
- users: credentials and permissions scope
  - fans: people associated to a user account (first_name, last_name, date_of_birth, place_of_birth, fidelity_card_no)
- teams: name, country, url, image_url
- competitions (e.g. championship, national cup, European cup ...)
  - events: date_time, competition, season, home_team, away_team, score, notes
- transport_means
- travels : event, transport_mean
  - travel_seats: total, requested, reserved, available
  - fan_travels: travel, fan, status


### How to run the queue

```
$ bundle exec sidekiq --environment development -C config/sidekiq.yml
```

Image optimization:

```
$ sudo apt install optipng
$ ls -1 *png | xargs optipng -dir optimized/ -strip all -o7
$ sudo apt install jpegoptim
$ ls -1 *jpg | xargs jpegoptim -doptimized --strip-all -v
```

### Create test data in development environment

* Add `:development` group to `:test` only dependecies to load FactoryBot
* Run `bundle exec rails c`
```
Dir[File.expand_path('spec/factories/*.rb', __dir__)].sort.each { |file| require
 file }
FactoryBot.create :user
User.first.active!
User.first.admin!
FactoryBot.create :event
```